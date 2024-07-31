% Bingchen Liu July 15, 2024
% This code is used to explore camera rectifiation  
clear
close all 
% cam1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/ARGUS2_Cam1_1702144862060_Products_July23.mat');
% cam2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/ARGUS2_Cam2_1702144862060_Products_July23.mat');
% cam3 = load('/Volumes/SIO_CPG_8T/Fletcher/Processed_data/cam3_test/ARGUS2_Cam3_1702144862060_Products_run2.mat');

cam1 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_Images_cam12/Processed_data/ARGUS2_Cam1_1722272520344_Products.mat');
cam2 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_Images_cam12/Processed_data/ARGUS2_Cam2_1722272520344_Products.mat');
cam3 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_images_cam3/Processed_data/ARGUS2_Cam3_1722272520315_Products.mat');


t_inst = 1;
image_cam1= cam1.Products.Irgb_2d;
image_cam2= cam2.Products.Irgb_2d;
image_cam3= cam3.Products.Irgb_2d;

image2d_cam123= squeeze(image_cam1(t_inst,:,:,:))+squeeze(image_cam2(t_inst,:,:,:))+squeeze(image_cam3(t_inst,:,:,:));

limx = cam1.Products.localX;
limy = cam2.Products.localY;

figure()
imshow(image2d_cam123,'XData',limx(1,:),'YData',limy(:,1))
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
%save('/Users/bingchenliu/Desktop/Oceanography/research/Remote_sensing_total/Rectification/calib_data/Product_Fletcher_gridonly_0p5res','Products','origin_grid')