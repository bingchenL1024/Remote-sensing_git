%% Actual field data 
addpath /Users/bingchenliu/Desktop/Oceanography/OCM/code/Video-Currents-Toolbox-master_BLmodified
%load('/Users/benjaminliu/Desktop/Oceanography/Code/20211215_Torrey_02_2_pixInst.mat')%test
%load('/Volumes/ARGUS1_10_C/20211215_Torrey/02/20211215_Torrey_02_2_pixInst.mat') %5m resolution
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/20211215_Torrey_02_2_pixInst.mat') %1m resolution 
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/Bingchen_pixInst_600.mat') % 10cm resolution
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/C.mat') % time information of the data

%time =datetime(t,'ConvertFrom','datenum');
%%
% Get original rectified image 
% figure(55)
% full_im = pixInst.Irgb;
% full_im = full_im(:,:,:,1);
% figure(33)
% imagesc(full_im)

%% create video to display the motion of foam (test)
% for ii= 1:1967
%     full_im = pixInst.Irgb;
%     full_im = full_im(:,:,:,ii);
%     surfIm = full_im(350:900,500:800,:);
%     imshow(surfIm)
%     pause(0.12)
% end 
%% change crossshore/time/alongshore position to check foam pattern (test)
% for ii = 1:75
% freq=2;
% t_step = 1/freq; %time step of the data(depends on sampling frequency, eg:2Hz --> 0.5s)
% t_range = 1:70;
% crossshore_d = 690; %distance offshore - check pixInst.X
% alongshore_d = 711:746;% transction distance along shore - check pixInst.Y
% %alongshore_d = 90:150;%test 
% Ir=squeeze(pixInst.Irgb(alongshore_d, crossshore_d,:,t_range));
% %Ir=transpose(squeeze(pixInst.Irgb(:,136,:,:)),2);
% Ir_ind=permute(Ir,[3,1,2]);
% Ir_ind_gray = rgb2gray(Ir_ind);
% % figure(1)
% % image(Ir_ind_gray)
% % data = Ir_ind_gray;
% % stackStruct.data = data;
% 
% t=zeros(length(t_range),1);
% for i = 1:length(t_range)
%     t(i,1)=i*t_step;
% end 
% stackStruct.dn = t; %time interval for the alongshore transction 
% 
% xy=zeros(length(alongshore_d),2);
% xy(:,1) =pixInst.X(1,crossshore_d);
% xy(:,2) =pixInst.Y(alongshore_d);  
% stackStruct.xyzAll = xy;
% 
% figure(4)
% Ir_ind_stack = permute(Ir_ind,[2,1,3]);
% stackPlotter(Ir_ind_stack,xy(:,2)',t ,'y');
% pause(0.5)
% end 
%% data input (start of actual code) Hacked 
freq=2;
t_step = 1/freq; %time step of the data(depends on sampling frequency, eg:2Hz --> 0.5s)
t_range = 1:600;
crossshore_d = 1980; %distance offshore - check pixInst.X
alongshore_d = 1250:1550;% transction distance along shore - check pixInst.Y
% %% load data image (turn RGB to gray)
% Ir=squeeze(pixInst.Irgb(alongshore_d, crossshore_d,:,t_range));
% %Ir=transpose(squeeze(pixInst.Irgb(:,136,:,:)),2);
% Ir_ind=permute(Ir,[3,1,2]);
% Ir_ind_gray = rgb2gray(Ir_ind);
% figure(1)
% image(Ir_ind_gray)
% data = Ir_ind_gray;
% stackStruct.data = data;

 %% load data image (use directly gray)
Ir=squeeze(pixInst.Igray(alongshore_d, crossshore_d,t_range));
%Ir=transpose(squeeze(pixInst.Irgb(:,136,:,:)),2);
%Ir_ind_gray=permute(Ir,[3,1,2]);
% figure(1)
% image(Ir_ind_gray)
data = Ir';
stackStruct.data = data;

%% load time information 
t=zeros(length(t_range),1);
for i = 1:length(t_range)
    t(i,1)=i*t_step;
end 
t = t(:)/(24*60*60);
stackStruct.dn = t; %time interval for the alongshore transction , should be in unit of days 

%% load location information 
xy=zeros(length(alongshore_d),2);
xy(:,1) =pixInst.X(1,crossshore_d);
xy(:,2) =pixInst.Y(alongshore_d);  
stackStruct.xyzAll = xy;

% %% time stack image 
% figure(4)
% Ir_ind_stack = permute(Ir_ind,[2,1,3]);
% stackPlotter(Ir_ind_stack,xy(:,2)',t ,'y');
% pause(0.5)
%% Inputs 
% Load example stack structure
%load('test_data'); %BL hacked 
%stackStruct = load('CIRN_example_stackstruct');

%stackStruct = rmfield(stackStruct , "inst" ); %hacked, DELETE right after test 

% Grab stack: grayscale image of timestack, size [MxN]
stack = stackStruct.data;
stack =double(stack);

% Grab time: time line (starting from zero) of stack, size [1xM]
time = stackStruct.dn;
%time = time';
% Grab xy: x,y position [Nx2] of each pixel in a dimension (equally spaced)
xyz = stackStruct.xyzAll;
xy = xyz(:,1:2);

% Set Twin: the time length of the FFT window (in points)
% For 2 Hz data, Twin = 128 will yield a 64s average current
Twin = 128; 
%Twin =64; %BL hacked 

% Set Tstep: time length to step the window (in points)
% For 2 Hz data, Tstep = 64 will yield a current estimate every 32 s
Tstep = 64; 
%Tstep = 32; %BL hacked  

% Set vBounds: [minV maxV], units m/s or vector of desired velocity steps,
% Set this to empty, [], to use defaults [-3 3]
vB = [];

% Set fkBounds = [fmin fmax kmin kmax], vector of frequency and wavenumber
%      bounds energy out of side of these bounds will be set to 0.  Useful
%      to eliminate some of the wave contamination that leaks in.  Set this
%      to empty, [], to use defaults.
fkB = [];

% Set {plotFlag}: optional, if true (~=0) will display a running plot of
%      the data processing
plotFlag = 1;

videoCurrentOut = videoCurrentGen(stack, time, xy, vB, fkB, ...
    Twin, Tstep, plotFlag);

%% plot data 
% figure(3)
% for i = 1:length(videoCurrentOut.meanV)
%     current_t(i)= i*(Tstep/freq);
% end 
% errorbar(current_t,videoCurrentOut.meanV,videoCurrentOut.stdV)




%save('/Users/benjaminliu/Desktop/Oceanography/Code/output_data/Current_v/2Hz_100_120127_500t_16_32.mat','videoCurrentOut')



