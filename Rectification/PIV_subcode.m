% Bingchen Liu, Aug 8, 2024
% This code process PIV and is a test case 
% The final goal after testing is to incorporate into
% "ARGUS_rectification_new_BL.m" 

%% initial input
spa_res = 0.1; %m
temp_res = 0.5; %hz
downsamp_rate = 2*(1/temp_res); 

%% =============== PIV Prep ======================================
%load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/0p1_resolution/Jan11_2024/ARGUS2_Cam1_1704999662100_Products_0.1mres_5s.mat')
%clearvars -except Products
%load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/PIV_data/imgray_1hz.mat')
load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/PIV_data/imgray_0p5hz.mat')


%% convert image to gray scale
% load('/Volumes/SIO_CPG_8T/Fletcher/Jan11_bigwave_2min/Processed_data/ARGUS2_Cam1_1704999662100_Products.mat')
% dim_image = size(Products.Irgb_2d);
% t_downsamp_max = floor(dim_image(1)/downsamp_rate);
% for t = 1:t_downsamp_max
%     image_temp  = squeeze(Products.Irgb_2d(downsamp_rate*t,:,:,:));
%     image_downsamp(t,:,:) = rgb2gray(image_temp);
% 
% end 
% save('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/PIV_data/imgray_1hz','image_downsamp')







%% =============== Apply PIV ======================================
%imdomain_x = 1400:2000;
%imdomain_y = 4746:6000;
t_downsamp_max = size(image_downsamp,1);
imdomain_x = 1:2000;
imdomain_y = 4000:6000;

for t =1:t_downsamp_max-1
    imageA = squeeze(image_downsamp(t,imdomain_y,imdomain_x));
    imageB = squeeze(image_downsamp(t+1,imdomain_y,imdomain_x));
    
    % imageA = squeeze(image_downsamp(1,:,:));
    % imageB = squeeze(image_downsamp(2,:,:));
    % imagesc(imageA); [temp,Mask{1,1},Mask{1,2}]=roipoly;
    
    
    
    interrogationarea = 128;%64; % window size of first pass
    step = 64; % step of first pass
    subpixfinder = 1; % 1 = 3point Gauss, 2 = 2D Gauss
    mask_inpt = [];%[]; %Mask, if needed, generate via: imagesc(image); [temp,Mask{1,1},Mask{1,2}]=roipoly;
    roi_inpt = []; %Region of interest: [x,y,width,height] in pixels
    passes = 4;%2  % 1-4 nr. of passes
    int2 = 64;%32 % second pass window size
    int3 = 32; % third pass window size
    int4 = 16; % fourth pass window size
    imdeform = '*linear'; % '*spline' is more accurate, but slower
    repeat = 0; % 0 or 1 : Repeat the correlation four times and multiply the correlation matrices.
    mask_auto = 0; % 0 or 1 : Disable Autocorrelation in the first pass.
    do_linear_correlation = 0; % 0 or 1 : Use circular correlation (0) or linear correlation (1).
    do_correlation_matrices = 0;  % 0 or 1 : Disable Autocorrelation in the first pass.
    repeat_last_pass = 0; % 0 or 1 : Repeat the last pass of a multipass analyis
    delta_diff_min = 0.025; % Repetitions of last pass will stop when the average difference to the previous pass is less than this number.
    
    [x_pixel,y_pixel,u_pixel_raw,v_pixel_raw,~,CC,~] = piv_FFTmulti(imageA,imageB,interrogationarea,step, ...
        subpixfinder,mask_inpt,roi_inpt,passes,int2,int3,int4,imdeform,repeat,mask_auto,do_linear_correlation, ...
        do_correlation_matrices,repeat_last_pass,delta_diff_min);
    %x_pixel_tot(t,:,:) = x_pixel;
    %y_pixel_tot(t,:,:) = y_pixel;
    u_pixel = u_pixel_raw.*spa_res.*temp_res;
    v_pixel = v_pixel_raw.*spa_res.*temp_res;
    u_pixel_tot(t,:,:) = u_pixel;
    v_pixel_tot(t,:,:) = v_pixel;
    CC_tot(t,:,:) = CC;
    warning off
end 

u_pixel_mean = squeeze(mean(u_pixel_tot,1,'omitnan'));
v_pixel_mean = squeeze(mean(v_pixel_tot,1,'omitnan'));

 %% =============== PIV Visualization ======================================
close all 
dispres = 8;
dim_im = size(u_pixel);

outputVideo = VideoWriter('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/figures/PIV_current.mp4','MPEG-4'); % Create a video file
outputVideo.FrameRate = 1; % Set the frame rate
open(outputVideo); % Open the video file for writing


for t = 1:119
    figure(1)
    h1 = imshow(squeeze(image_downsamp(t,imdomain_y,imdomain_x)),[]);
    hold on 
    h2=quiver(x_pixel(1:dispres:end,1:dispres:end),y_pixel(1:dispres:end,1:dispres:end), ...
        squeeze(u_pixel_tot(t,1:dispres:end,1:dispres:end)),squeeze(v_pixel_tot(t,1:dispres:end,1:dispres:end)),0,'b','LineWidth',1.5);
    hold on 
    x_ref = 100;
    y_ref= 200;
    u_ref = 1;
    v_ref = 0;
    h3=quiver(x_ref, y_ref, u_ref, v_ref, 0, 'r','LineWidth',2.5);
    scale = 100;
    hU2 = get(h2,'UData');
    hV2 = get(h2,'VData');
    set(h2,'UData',scale*hU2,'VData',scale*hV2)
    hU3 = get(h3,'UData');
    hV3 = get(h3,'VData');
    set(h3,'UData',scale*hU3,'VData',scale*hV3)
    text(x_ref, y_ref -50, 'Reference scale: 1m/s', 'Color', 'r','FontSize',25);
    axis on 
    xlabel('cross-shore location (10^{-1}m)','FontSize',24)
    ylabel('Along-shore location (10^{-1}m)','FontSize',24)
    xlim([0 2000])
    ylim([0 2000])
    hold off 

    width=15;
    height = 15;
    set(gcf,'Units','inches','Position',[0,0,width,height])
    frame = getframe(gcf);
    % Write the frame to the video
    writeVideo(outputVideo, frame);
    % Close the figure after capturing to avoid too many open windows
    close(gcf);
end 
close(outputVideo); % Close the video file to finalize it


% figure()
% imagesc(CC)
% colorbar;
% caxis([-1,1]);
% cmocean('balance')

%% mean current map
dispres = 10;
dim_im = size(u_pixel);

figure(2)
h1 = imshow(squeeze(image_downsamp(t,imdomain_y,imdomain_x)),[]);
hold on 
h2=quiver(x_pixel(1:dispres:end,1:dispres:end),y_pixel(1:dispres:end,1:dispres:end), ...
    u_pixel_mean(1:dispres:end,1:dispres:end),v_pixel_mean(1:dispres:end,1:dispres:end),0,'b','LineWidth',1.5);
hold on 
x_ref = 100;
y_ref= 200;
u_ref = 1;
v_ref = 0;
h3=quiver(x_ref, y_ref, u_ref, v_ref, 0, 'r','LineWidth',2.5);
scale = 100;
hU2 = get(h2,'UData');
hV2 = get(h2,'VData');
set(h2,'UData',scale*hU2,'VData',scale*hV2)
hU3 = get(h3,'UData');
hV3 = get(h3,'VData');
set(h3,'UData',scale*hU3,'VData',scale*hV3)
text(x_ref, y_ref -50, 'Reference scale: 1m/s', 'Color', 'r','FontSize',25);
axis on 
xlabel('cross-shore location (10^{-1}m)','FontSize',24)
ylabel('Along-shore location (10^{-1}m)','FontSize',24)
set(gca,'YDir','normal')
set(gca,'XDir','normal')
hold off 



