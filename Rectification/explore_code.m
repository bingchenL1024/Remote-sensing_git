% Bingchen Liu July 15, 2024
% This code is used to explore camera rectifiation  
clear
close all 
cam1 = load('/Users/bingchenliu/Desktop/Oceanography/research/Remote_sensing_total/Rectification/Processed_data/ARGUS2_Cam1_1702144862060_Products_July23.mat');
cam2 = load('/Users/bingchenliu/Desktop/Oceanography/research/Remote_sensing_total/Rectification/Processed_data/ARGUS2_Cam2_1702144862060_Products_July23.mat');

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