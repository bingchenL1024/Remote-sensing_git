% Bingchen Liu July 15, 2024
% This code is used to explore camera rectifiation  
clear
close all 
% cam1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/ARGUS2_Cam1_1702144862060_Products_July23.mat');
% cam2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/ARGUS2_Cam2_1702144862060_Products_July23.mat');
% cam3 = load('/Volumes/SIO_CPG_8T/Fletcher/Processed_data/cam3_test/ARGUS2_Cam3_1702144862060_Products_run2.mat');

% cam1 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_Images_cam12/Processed_data/ARGUS2_Cam1_1722272520344_Products.mat');
% cam2 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_Images_cam12/Processed_data/ARGUS2_Cam2_1722272520344_Products.mat');
% cam3 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_images_cam3/Processed_data/ARGUS2_Cam3_1722272520315_Products.mat');

cam1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/1100_900/ARGUS2_Cam1_1722272520344_Products.mat');
cam2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/1100_900/ARGUS2_Cam2_1722272520344_Products.mat');
cam3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/1100_900/ARGUS2_Cam3_1722272520315_Products.mat');

% MOPS coordinate
load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/Rectification/Toolbox/MopTableUTM.mat')

% cam1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/600_400/ARGUS2_Cam1_1722272520344_Products.mat');
% cam2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/600_400/ARGUS2_Cam2_1722272520344_Products.mat');
% cam3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/BC_image/600_400/ARGUS2_Cam3_1722272520315_Products.mat');


t_inst = 1;
image_cam1= cam1.Products.Irgb_2d;
image_cam2= cam2.Products.Irgb_2d;
image_cam3= cam3.Products.Irgb_2d;

image2d_cam123= squeeze(image_cam1(t_inst,:,:,:))+squeeze(image_cam2(t_inst,:,:,:))+squeeze(image_cam3(t_inst,:,:,:));

limx_lon = cam1.Products.localX;
limy_lat = cam1.Products.localY;

limx = cam1.Products.Eastings;
limy = cam1.Products.Northings;


MOPS.MOPS657_UTM  = [Mop.BackXutm(657) Mop.BackYutm(657); Mop.OffXutm(657) Mop.OffYutm(657)];
MOPS.MOPS656_UTM  = [Mop.BackXutm(656) Mop.BackYutm(656); Mop.OffXutm(656) Mop.OffYutm(656)];
MOPS.MOPS655_UTM  = [Mop.BackXutm(655) Mop.BackYutm(655); Mop.OffXutm(655) Mop.OffYutm(655)];
MOPS.MOPS654_UTM  = [Mop.BackXutm(654) Mop.BackYutm(654); Mop.OffXutm(654) Mop.OffYutm(654)];
MOPS.MOPS653_UTM  = [Mop.BackXutm(653) Mop.BackYutm(653); Mop.OffXutm(653) Mop.OffYutm(653)];
MOPS.MOPS652_UTM  = [Mop.BackXutm(652) Mop.BackYutm(652); Mop.OffXutm(652) Mop.OffYutm(652)];
MOPS.MOPS651_UTM  = [Mop.BackXutm(651) Mop.BackYutm(651); Mop.OffXutm(651) Mop.OffYutm(651)];
MOPS.MOPS650_UTM  = [Mop.BackXutm(650) Mop.BackYutm(650); Mop.OffXutm(650) Mop.OffYutm(650)];


%% add geotiff

E1 = limx(end,1);  % Easting of the upper-left corner
N1 = limy(end,1); % Northing of the upper-left corner
E2 = limx(1,end);  % Easting of the lower-right corner
N2 = limy(1,end); % Northing of the lower-right corner

[imageHeight, imageWidth, ~] = size(image2d_cam123);

% Create a spatial reference object
R = georefcells([N1 N2], [E1 E2], [imageHeight, imageWidth]);
% Define the output GeoTIFF file name
outputFilename = 'output_geotiff.tif';

% Write the GeoTIFF
geotiffwrite(outputFilename, image2d_cam123, R);

% Optional: Define the coordinate system using the EPSG code for UTM
info = geotiffinfo(outputFilename);
proj = geotiffinfo(outputFilename);
utmZone = 11; % Replace with your UTM zone
utmEPSG = sprintf('EPSG:%d', 32600 + utmZone); % 326xx for northern hemisphere, 327xx for southern
geotiffwrite(outputFilename, imageData, R, 'CoordRefSysCode', utmEPSG);

%% plot in UTM
figure()
image(limx(:),limy(:),image2d_cam123)
hold on 
scatter(MOPS.MOPS655_UTM(1,1),MOPS.MOPS655_UTM(1,2),500,'filled','r')
axis on 
hold off




plot(MOPS.MOPS657_UTM(:,1), MOPS.MOPS657_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS656_UTM(:,1), MOPS.MOPS656_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS656_UTM(:,1), MOPS.MOPS656_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS655_UTM(:,1), MOPS.MOPS655_UTM(:,2),'LineWidth',5)
hold on
plot(MOPS.MOPS654_UTM(:,1), MOPS.MOPS654_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS653_UTM(:,1), MOPS.MOPS653_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS652_UTM(:,1), MOPS.MOPS652_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS651_UTM(:,1), MOPS.MOPS651_UTM(:,2),'LineWidth',5)
hold on 
plot(MOPS.MOPS650_UTM(:,1), MOPS.MOPS650_UTM(:,2),'LineWidth',5)
legend('MOP657','MOP656','MOP655','MOP654','MOP653','MOP652','MOP651','MOP650','FontSize',18)
set(gca,'YDir','normal')
%set(gca,'XDir','reverse')
axis on 
xlabel('Easting (m)','FontSize',22)
ylabel('Northing(m)','FontSize',22)
hold off 

%% plot in local coordinate

figure()
imshow(image2d_cam123,'XData',limx_lon(1,:),'YData',limy_lat(:,1))
set(gca,'YDir','normal')
set(gca,'XDir','reverse')
axis on 
xlabel('Cross-shore Location (m)','FontSize',22)
ylabel('Along-shore Location (m)','FontSize',22)


%% loop through to create a video

for t = 1:100
image_cam1= cam1.Products.Irgb_2d;
imdim_cam1 = size(image_cam1);
image2d_cam1= squeeze(image_cam1(t,:,:,:));

image_cam2= cam2.Products.Irgb_2d;
imdim_cam2 = size(image_cam2);
image2d_cam2= squeeze(image_cam2(t,:,:,:));
image2d_cam12 = image2d_cam1+image2d_cam2;

% figure(1)
% subplot(2,1,1)
% imagesc(image2d_cam1)
% set(gca,'YDir','normal')
% subplot(2,1,2)
% imagesc(image2d_cam2)
% set(gca,'YDir','normal')
% 

limx = cam1.Products.localX;
limy = cam2.Products.localY;
figure(2)
imshow(image2d_cam12,'XData',limx(1,:),'YData',limy(:,1))
%set(gca,'YDir','normal')
%set(gca,'XDir','reverse')
axis on 
xlabel('Cross-shore Location (m)','FontSize',22)
ylabel('Along-shore Location (m)','FontSize',22)
drawnow
pause(0.5)
end 

%%
save('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/calib_data/Products/Product_Fletcher_gridonly_0p5res_1100_900','Products','origin_grid')
