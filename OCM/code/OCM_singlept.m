%% Actual field data 
addpath /Users/bingchenliu/Desktop/Oceanography/OCM/code/Video-Currents-Toolbox-master_BLmodified
%load('/Users/benjaminliu/Desktop/Oceanography/Code/20211215_Torrey_02_2_pixInst.mat')%test
%load('/Volumes/ARGUS1_10_C/20211215_Torrey/02/20211215_Torrey_02_2_pixInst.mat') %5m resolution
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/20211215_Torrey_02_2_pixInst.mat') %1m resolution 
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/Bingchen_pixInst_600.mat') % 10cm resolution
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/C.mat') % time information of the data

%% data input (start of actual code) Hacked 
freq=2;
t_step = 1/freq; %time step of the data(depends on sampling frequency, eg:2Hz --> 0.5s)
t_range = 1:600;
crossshore_d = 1980; %distance offshore - check pixInst.X
alongshore_d = 1250:1450;% transction distance along shore - check pixInst.Y
resolution_y = (alongshore_d(end)-alongshore_d(1))*0.1 % in meters 

 %% load data image (use directly gray)
Ir=squeeze(pixInst.Igray(alongshore_d, crossshore_d,t_range));
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


%% Inputs 

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

videoCurrentOut = videoCurrentGen(stack, time, xy, vB, fkB,Twin, Tstep, plotFlag);