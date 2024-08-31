% Bingchen Liu Aug 31,2024
% This code combine RECTIFIED camera 123 image together. 

cam1_pt1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt1.mat');
cam1_pt2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt2.mat');
cam1_pt3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt3.mat');
cam2_pt1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt1.mat');
cam2_pt2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt2.mat');
cam2_pt3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt3.mat');

cam3_pt1=load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug19_1PM/Fletcher_1724097602_Products_pt1.mat');


im_cam12 = cam1_pt1.Products.Irgb_2d(1,:,:,:)+cam3_pt1.Products.Irgb_2d(1,:,:,:)+cam2_pt1.Products.Irgb_2d(1,:,:,:);

im_cam12(:,:,:,1) = squeeze(cam1_pt1.Products.Irgb_2d(1,:,:,:));
im_cam12(:,:,:,2) = squeeze(cam2_pt1.Products.Irgb_2d(1,:,:,:));
im_cam12(:,:,:,3) = squeeze(cam3_pt1.Products.Irgb_2d(1,:,:,:));

test_im = cameraSeamBlend(im_cam12);








