% Bingchen Liu Sep 29, 2024
% This code is used to process PIV output and run some test 

PIV.cam1 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/ARGUS2_Cam1_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam2 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/ARGUS2_Cam2_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam3 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/Fletcher_1724011320_Products_pt1_subrate_4.mat');

% PIV.cam1 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Jan11_bigwave_2min/Processed_data/ARGUS2_Cam1_1704999662100_Products_pt1_subrate_4.mat');
% PIV.cam2 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Jan11_bigwave_2min/Processed_data/ARGUS2_Cam2_1704999662100_Products_pt1_subrate_4.mat');

u_mean.cam1 = squeeze(mean(PIV.cam1.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam1 = squeeze(mean(PIV.cam1.Products.v_pixel_tot,1,'omitnan'));
u_mean.cam2 = squeeze(mean(PIV.cam2.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam2 = squeeze(mean(PIV.cam2.Products.v_pixel_tot,1,'omitnan'));
u_mean.cam3 = squeeze(mean(PIV.cam3.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam3 = squeeze(mean(PIV.cam3.Products.v_pixel_tot,1,'omitnan'));

%im_test_all = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/0p1_resolution/Jan11_2024/ARGUS2_Cam1_1704999662100_Products_0.1mres_5s.mat');
%im_test = squeeze(im_test_all.Products.Irgb_2d(1,:,:,:));
%%

x_cross = 0:0.1:200;
y_along = 0:0.1:600;

[grid_x,grid_y] = meshgrid(x_cross,y_along);

dispres = 8;

%%

figure(1)
% imshow(im_test,'XData',grid_x(1,:),'YData',grid_y(:,1))
% hold on
q1=quiver(squeeze(PIV.cam1.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam1.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam1(1:dispres:end,1:dispres:end),v_mean.cam1(1:dispres:end,1:dispres:end) ...
    ,2,'b','LineWidth',1.5);
hold on 
q2=quiver(squeeze(PIV.cam2.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam2.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam2(1:dispres:end,1:dispres:end),v_mean.cam2(1:dispres:end,1:dispres:end) ...    
    ,2,'b','LineWidth',1.5);
hold on 
q3=quiver(squeeze(PIV.cam3.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam3.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam3(1:dispres:end,1:dispres:end),v_mean.cam3(1:dispres:end,1:dispres:end) ...
    ,2,'b','LineWidth',1.5);
% xlabel('cross-shore location (10^{-1}m)','FontSize',24)
% ylabel('Along-shore location (10^{-1}m)','FontSize',24) 
axis on 
ylabel('Downcoast \leftarrow Along-shore Location (m) \rightarrow Upcoast')
xlabel('Offshore \leftarrow Cross-shore Location (m) \rightarrow Onshore')
set(gca, 'FontSize', 20)
set(gca,'YDir','normal')
set(gca,'XDir','normal')
q1.Color= 'red';
q2.Color = 'blue';
q3.Color = 'green';
scale = 0.1;
pos = get(gca, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
hold off 