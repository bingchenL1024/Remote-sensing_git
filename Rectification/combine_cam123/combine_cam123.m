% Bingchen Liu Aug 31,2024
% This code:
    %combine RECTIFIED camera 123 image together and use Athina's cameraSeamBlend. 
    %turn the color into grayscale for PIV analysis
    %down sample the data for PIV analysis

addpath(genpath('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git'))

%% load data

% cam1_pt1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt1.mat');
% %cam1_pt2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt2.mat');
% %cam1_pt3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam1_1724011261560_Products_pt3.mat');
% cam2_pt1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt1.mat');
% %cam2_pt2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt2.mat');
% %cam2_pt3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/ARGUS2_Cam2_1724011261560_Products_pt3.mat');
% cam3_pt1 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/Fletcher_1724011202_Products_pt1.mat');
% %cam3_pt2 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/Fletcher_1724011202_Products_pt2.mat');
% %cam3_pt3 = load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_git/data/Processed_data/Aug18_1PM/Fletcher_1724011202_Products_pt3.mat');


%%
temp_res = 1; %hz
downsamp_rate = 2*(1/temp_res); 
dim_image = size(cam1_pt1.Products.Irgb_2d);
t_downsamp_max = floor(dim_image(1)/downsamp_rate);

for t = 1:5%t_downsamp_max
    % 
    % im_temp(:,:,:,1) = squeeze(cam1_pt1.Products.Irgb_2d(t,:,:,:));
    % im_temp(:,:,:,2) = squeeze(cam2_pt1.Products.Irgb_2d(t,:,:,:));
    % im_temp(:,:,:,3) = squeeze(cam3_pt1.Products.Irgb_2d(t,:,:,:));

    im_temp(:,:,1) = rgb2gray(squeeze(cam1_pt1.Products.Irgb_2d(t,:,:,:)));
    im_temp(:,:,2) = rgb2gray(squeeze(cam2_pt1.Products.Irgb_2d(t,:,:,:)));
    im_temp(:,:,3) = rgb2gray(squeeze(cam3_pt1.Products.Irgb_2d(t,:,:,:)));

    %im_full_rgb(t,:,:,:) = cameraSeamBlend(im_temp);
    im_full_gray(t,:,:,:) = rgb2gray(cameraSeamBlend(im_temp));

    clear im_temp
end 



% function GetSize(this) 
%    props = properties(this); 
%    totSize = 0; 
% 
%    for ii=1:length(props) 
%       currentProperty = getfield(this, char(props(ii))); 
%       s = whos('currentProperty'); 
%       totSize = totSize + s.bytes; 
%    end
% 
%    fprintf(1, '%d bytes\n', totSize); 
% end



