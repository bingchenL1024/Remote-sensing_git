load('/Volumes/SIO_CPG_8T/Fletcher/Processed_data/ARGUS2_Cam1_1702144862060_Products.mat')
image= Products.Irgb_2d;
imdim = size(image);
for t = 1:15
    imagesc(squeeze(image(t,:,:,:)))
    %imshow
    pause(0.1)
end 