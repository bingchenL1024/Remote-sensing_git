% Bingchen Liu Sep 29, 2024
% This code is used to process PIV output and run some test 

PIV.cam1 =load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/Processed_data/ARGUS2_Cam1_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam2 =load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/Processed_data/ARGUS2_Cam2_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam3 =load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/Processed_data/Fletcher_1724011320_Products_pt1_subrate_4.mat');


u_mean.cam1 = squeeze(mean(PIV.cam1.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam1 = squeeze(mean(PIV.cam1.Products.v_pixel_tot,1,'omitnan'));
u_mean.cam2 = squeeze(mean(PIV.cam2.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam2 = squeeze(mean(PIV.cam2.Products.v_pixel_tot,1,'omitnan'));
u_mean.cam3 = squeeze(mean(PIV.cam3.Products.u_pixel_tot,1,'omitnan'));
v_mean.cam3 = squeeze(mean(PIV.cam3.Products.v_pixel_tot,1,'omitnan'));
%%
dispres = 5;
figure(1)
q1=quiver(squeeze(PIV.cam1.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    squeeze(PIV.cam1.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    u_mean.cam1(1:dispres:end,1:dispres:end),v_mean.cam1(1:dispres:end,1:dispres:end) ...
    ,3,'b','LineWidth',1.5);
hold on 
q2=quiver(squeeze(PIV.cam2.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    squeeze(PIV.cam2.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    u_mean.cam2(1:dispres:end,1:dispres:end),v_mean.cam2(1:dispres:end,1:dispres:end) ...
    ,3,'b','LineWidth',1.5);
hold on 
q3=quiver(squeeze(PIV.cam3.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    squeeze(PIV.cam3.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)), ...
    u_mean.cam3(1:dispres:end,1:dispres:end),v_mean.cam3(1:dispres:end,1:dispres:end) ...
    ,3,'b','LineWidth',1.5);
xlabel('cross-shore location (10^{-1}m)','FontSize',24)
ylabel('Along-shore location (10^{-1}m)','FontSize',24)
set(gca,'YDir','normal')
set(gca,'XDir','normal')
q1.Color= 'red';
q2.Color = 'blue';
q3.Color = 'green';
hold off 