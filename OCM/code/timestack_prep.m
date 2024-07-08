% this code is used to extract time stack from original raw data for OCM
% analysis, and save it in a cell array.

addpath /Users/bingchenliu/Desktop/Oceanography/OCM/code/Video-Currents-Toolbox-master_BLmodified
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/Bingchen_pixInst_600.mat') % 10cm resolution


%% display raw video
% for i = 1:600
%     imagesc(data_gray(:,:,i))
%     pause(0.05)
% end 


%% 
data_gray = pixInst.Igray;
xlocmap = pixInst.X;
ylocmap = pixInst.Y;
xrange = 100; %10 m (100*0.1m) wide pixel bar (0.1 m resolution)
yrange = 100; %10 m (100*0.1m) wide pixel bar 
timerange = 1:600;%total duration of the time stack 
ximage= 1750:3000; %section of image that want to use --- note this is column number
yimage = 200:2398;% section of image that want to use --- note this row number
spacialresolu = 100; %10 m (100*0.1m) resolution of current estimation: obtain current estimation every XXX meter 



for i = 1:floor((yimage(end)-yimage(1))/spacialresolu)
    for j = 1:floor((ximage(end)-ximage(1))/spacialresolu)
        timestack_raw{i,j} = timestack_extractor_2D(ximage(1)+spacialresolu*j,yimage(1)+spacialresolu*i,xrange,yrange,timerange,data_gray,xlocmap,ylocmap);
        vellocation{i,j} =[yimage(1)+spacialresolu*i,ximage(1)+spacialresolu*j];  % note this is in order of (y -alongshore, x - crosshore)
    end 
end 


save('/Users/bingchenliu/Desktop/Oceanography/OCM/data/timestack_Bingchen_pixInst_600','timestack_raw','vellocation','timerange')



