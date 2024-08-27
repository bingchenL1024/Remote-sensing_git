% Bingchen Liu Aug 26, 2024
% This code plot the camera orientation using plotCamera
cam3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/calib_data/CPG_Data/Fletcher_cam3_postmove.mat');
cam12=load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/calib_data/CPG_Data/ARGUS2_cam12.mat');
cam1 = cam12.R(1);
cam2 = cam12.R(2);

figure()
plotCamera(AbsolutePose=cam1.worldPose,Size= 0.1)
hold on 
plotCamera(AbsolutePose=cam2.worldPose,Size= 0.1)
hold on 
plotCamera(AbsolutePose=cam3.R.worldPose,Size= 0.1)
hold off 