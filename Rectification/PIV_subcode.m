% Bingchen Liu, Aug 8, 2024
% This code process PIV and is a test case 
% The final goal after testing is to incorporate into
% "ARGUS_rectification_new_BL.m" 

%% =============== PIV Prep ======================================
load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/0p1_resolution/Jan11_2024/ARGUS2_Cam1_1704999662100_Products_0.1mres_5s.mat')



dim_image = size(Products.Irgb_2d);
t_1hz_max = floor(dim_image(1)/2);
image_1hz = zeros(t_1hz_max,dim_image(2),dim_image(3)); %down sample to avoid foam 


for t = 1:t_1hz_max
    image_1hz(t,:,:) = rgb2gray(squeeze(Products.Irgb_2d(2*t,:,:,:)));
end 


% for t = 1:dim_image(1)
%     imshow(squeeze(image_1hz(t,:,:)),[])
%     drawnow
%     pause(0.5)
% end 

%% =============== Apply PIV ======================================
%imdomain_x = 1400:2000;
%imdomain_y = 4746:6000;
imdomain_x = 1:2000;
imdomain_y = 4000:6000;
imageA = squeeze(image_1hz(1,imdomain_y,imdomain_x));
imageB = squeeze(image_1hz(2,imdomain_y,imdomain_x));

% imageA = squeeze(image_1hz(1,:,:));
% imageB = squeeze(image_1hz(2,:,:));
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

[x_pixel,y_pixel,u_pixel,v_pixel,~,CC,~] = piv_FFTmulti(imageA,imageB,interrogationarea,step, ...
    subpixfinder,mask_inpt,roi_inpt,passes,int2,int3,int4,imdeform,repeat,mask_auto,do_linear_correlation, ...
    do_correlation_matrices,repeat_last_pass,delta_diff_min);

%% =============== PIV Visualization ======================================
close all 
dispres = 3;
dim_im = size(u_pixel);
figure()
h1 = imshow(imageA,[]);
hold on 
quiver(x_pixel(1:dispres:end,1:dispres:end),y_pixel(1:dispres:end,1:dispres:end),u_pixel(1:dispres:end,1:dispres:end),v_pixel(1:dispres:end,1:dispres:end),5,'b','LineWidth',1.5);

x_ref = 100;
y_ref= 200;
u_ref = 20;
v_ref = 0;
quiver(x_ref, y_ref, u_ref, v_ref, 5, 'r','LineWidth',2.5);
text(x_ref, y_ref -50, 'Reference scale: 2m/s', 'Color', 'r','FontSize',25);
axis on 
xlabel('cross-shore location (10^{-1}m)','FontSize',24)
ylabel('cross-shore location (10^{-1}m)','FontSize',24)
hold off 


figure()
imagesc(CC)
colorbar;
caxis([-1,1]);
cmocean('balance')
%%
figure()
quiver(x_pixel,y_pixel,u_pixel,v_pixel,5,'b','LineWidth',1.5);


figure()
for i = 1:5
    imagesc(squeeze(image_1hz(i,:,:)))
    pause(1)
end 

