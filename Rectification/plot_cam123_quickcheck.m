% Bingchen Liu Aug 27 2024
% This code plot the camera 123 rectified image to see the FOV
clear
cam3 = load('/Volumes/SIO_CPG_8T/Fletcher/cam3_postmove_test/Processed_data/Fletcher_1724115340_Products.mat');
cam2 = load('/Volumes/SIO_CPG_8T/Fletcher/BC_Images_cam12/Processed_data/ARGUS2_Cam2_1722272520344_Products.mat');

t_inst = 1;
image_cam2 = cam2.Products.Irgb_2d;
image_cam3 = cam3.Products.Irgb_2d;
image2d_cam23= squeeze(image_cam2(t_inst,:,:,:))+squeeze(image_cam3(t_inst,:,:,:));
imagesc(image2d_cam23)