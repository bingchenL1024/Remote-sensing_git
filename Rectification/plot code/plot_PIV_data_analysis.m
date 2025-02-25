% Bingchen Liu Sep 29, 2024
% This code is used to process PIV output and run some test 


clear
close all

% PIV.cam1 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Jan11_bigwave_2min/Processed_data/ARGUS2_Cam1_1704999662100_Products_pt1_subrate_4.mat');
% PIV.cam2 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Jan11_bigwave_2min/Processed_data/ARGUS2_Cam2_1704999662100_Products_pt1_subrate_4.mat');


PIV.cam1 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/ARGUS2_Cam1_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam2 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/ARGUS2_Cam2_1724011261560_Products_pt1_subrate_4.mat');
PIV.cam3 =load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM_2min/PIV_only/Fletcher_1724011320_Products_pt1_subrate_4.mat');

% PIV.cam1 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/Processed_data/ARGUS2_Cam1_1721235661332_Products_pt1_subrate_4.mat');
% PIV.cam2 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/Processed_data/ARGUS2_Cam2_1721235661332_Products_pt1_subrate_4.mat');
% PIV.cam3 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/Processed_data/Fletcher_1721235720_Products_pt1_subrate_4.mat');


timex.cam1 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/timex/Processed_data/ARGUS2_Cam1_1724009400_Products.mat');
timex.cam2 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/timex/Processed_data/ARGUS2_Cam2_1724009400_Products.mat');
timex.cam3 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/Aug18_1PM_2min/timex/Processed_data/Fletcher_1724009402_Fletcher_Products.mat');

% timex.cam1 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/timex/Processed_data/ARGUS2_Cam1_1721235720_timex.mat');
% timex.cam2 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/timex/Processed_data/ARGUS2_Cam2_1721235720_timex.mat');
% timex.cam3 = load('/Volumes/SIO_CPG_8T/Data/Fletcher/July17_10AM/timex/Processed_data/Fletcher_1721235602_Fletcher_timex.mat');


IrIndv(:,:,:,1) = squeeze(timex.cam1.Products.Irgb_2d);
IrIndv(:,:,:,2) = squeeze(timex.cam2.Products.Irgb_2d);
IrIndv(:,:,:,3) = squeeze(timex.cam3.Products.Irgb_2d);
timex_cam123 = cameraSeamBlend(IrIndv);


%% qc

cclim = 0.5;
vellim = 0.1;

figure()
subplot(1,3,1)
p1=cdfplot(PIV.cam1.Products.CC_tot(:));
xlabel('Cross-correlation','FontSize', 20)
ylabel('CDF','FontSize',20)
title('Camera 1 Data','FontSize',25)
p1.LineWidth = 4;

subplot(1,3,2)
p2= cdfplot(PIV.cam2.Products.CC_tot(:));
xlabel('Cross-correlation','FontSize', 20)
ylabel('CDF','FontSize',20)
title('Camera 2 Data','FontSize',25)
p2.LineWidth = 4;

subplot(1,3,3)
p3=cdfplot(PIV.cam3.Products.CC_tot(:));
xlabel('Cross-correlation','FontSize', 20)
ylabel('CDF','FontSize',20)
title('Camera 3 Data','FontSize',25)
p3.LineWidth = 4;


% PIV.cam1.Products.u_pixel_tot(find(PIV.cam1.Products.CC_tot<cclim)) = NaN;
% PIV.cam1.Products.v_pixel_tot(find(PIV.cam1.Products.CC_tot<cclim)) = NaN;
% PIV.cam2.Products.u_pixel_tot(find(PIV.cam2.Products.CC_tot<cclim)) = NaN;
% PIV.cam2.Products.v_pixel_tot(find(PIV.cam2.Products.CC_tot<cclim)) = NaN;
% PIV.cam3.Products.u_pixel_tot(find(PIV.cam3.Products.CC_tot<cclim)) = NaN;
% PIV.cam3.Products.v_pixel_tot(find(PIV.cam3.Products.CC_tot<cclim)) = NaN;

n_nan.cam1.u = squeeze(sum(isnan(PIV.cam1.Products.u_pixel_tot),1));
n_nan.cam1.v = squeeze(sum(isnan(PIV.cam1.Products.v_pixel_tot),1));
n_nan.cam2.u = squeeze(sum(isnan(PIV.cam2.Products.u_pixel_tot),1));
n_nan.cam2.v = squeeze(sum(isnan(PIV.cam2.Products.v_pixel_tot),1));
n_nan.cam3.u = squeeze(sum(isnan(PIV.cam3.Products.u_pixel_tot),1));
n_nan.cam3.v = squeeze(sum(isnan(PIV.cam3.Products.v_pixel_tot),1));


%% QC 

ratio =0.5*0.1 ;
nan_ratio =0.9;

u_mean.cam1 = squeeze(mean(PIV.cam1.Products.u_pixel_tot,1,'omitnan')).*ratio;
v_mean.cam1 = squeeze(mean(PIV.cam1.Products.v_pixel_tot,1,'omitnan')).*ratio;
u_mean.cam2 = squeeze(mean(PIV.cam2.Products.u_pixel_tot,1,'omitnan')).*ratio;
v_mean.cam2 = squeeze(mean(PIV.cam2.Products.v_pixel_tot,1,'omitnan')).*ratio;
u_mean.cam3 = squeeze(mean(PIV.cam3.Products.u_pixel_tot,1,'omitnan')).*ratio;
v_mean.cam3 = squeeze(mean(PIV.cam3.Products.v_pixel_tot,1,'omitnan')).*ratio;

% u_mean.cam1(find(abs(u_mean.cam1)<vellim)) = NaN;
% u_mean.cam2(find(abs(u_mean.cam2)<vellim)) = NaN;
% u_mean.cam3(find(abs(u_mean.cam3)<vellim)) = NaN;



u_mean.cam1(find(n_nan.cam1.u>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;
v_mean.cam1(find(n_nan.cam1.v>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;
u_mean.cam2(find(n_nan.cam2.u>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;
v_mean.cam2(find(n_nan.cam2.v>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;
u_mean.cam3(find(n_nan.cam3.u>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;
v_mean.cam3(find(n_nan.cam3.v>size(PIV.cam1.Products.u_pixel_tot,1)*nan_ratio))=NaN;

%im_test_all = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/0p1_resolution/Jan11_2024/ARGUS2_Cam1_1704999662100_Products_0.1mres_5s.mat');
%im_test = squeeze(im_test_all.Products.Irgb_2d(1,:,:,:));
%%
close all
x_cross = 0:0.1:200;
y_along = 0:0.1:600;

[grid_x,grid_y] = meshgrid(x_cross,y_along);

dispres = 10;
x_ref = 75;
y_ref= 140;
u_ref = 0.5;
v_ref = 0;
scale_vec= 35;

figure()
imshow(timex_cam123,'XData',grid_x(1,:),'YData',grid_y(:,1))
 hold on
q1=quiver(squeeze(PIV.cam1.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam1.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam1(1:dispres:end,1:dispres:end),v_mean.cam1(1:dispres:end,1:dispres:end) ...
    ,0,'b','LineWidth',1.5);
hold on 
q2=quiver(squeeze(PIV.cam2.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam2.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam2(1:dispres:end,1:dispres:end),v_mean.cam2(1:dispres:end,1:dispres:end) ...    
    ,0,'b','LineWidth',1.5);
hold on 
q3=quiver(squeeze(PIV.cam3.Products.x_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    squeeze(PIV.cam3.Products.y_pixel_tot(1,1:dispres:end,1:dispres:end)./10), ...
    u_mean.cam3(1:dispres:end,1:dispres:end),v_mean.cam3(1:dispres:end,1:dispres:end) ...
    ,0,'b','LineWidth',1.5);
hold on 
q4=quiver(x_ref, y_ref, u_ref, v_ref, 0, 'm','LineWidth',2.5);

hU1 = get(q1,'UData');
hV1 = get(q1,'VData');
hU2 = get(q2,'UData');
hV2 = get(q2,'VData');
hU3 = get(q3,'UData');
hV3 = get(q3,'VData');
hU4 = get(q4,'UData');
hV4 = get(q4,'VData');

set(q1,'UData',scale_vec*hU1,'VData',scale_vec*hV1)
set(q2,'UData',scale_vec*hU2,'VData',scale_vec*hV2)
set(q3,'UData',scale_vec*hU3,'VData',scale_vec*hV3)
set(q4,'UData',scale_vec*hU4,'VData',scale_vec*hV4)


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
pos(2) = pos(2)+scale*pos(4)-0.05;
pos(4) = (1-scale)*pos(4);
set(gca, 'Position', pos)
legend('North-facing cam','South-facing cam','Central cam')
text(x_ref, y_ref+20, '0.5m/s', 'Color', 'm','FontSize',25);
title('2-min Averaged Current','August 18 1PM Collection','FontSize',25)
xlim([60,150])
hold off 