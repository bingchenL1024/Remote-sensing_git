%% Synthetic image for testing 
addpath('/Users/bingchenliu/Desktop/Oceanography/OCM/code/Video-Currents-Toolbox-master_BLmodified')
freq=1;
data = randi([70,80],60,70); %60s and 70m
for i = 1:60
    data(i,i)=randi([200,210],1);
    data(i,i+1)=randi([200,210],1);
    data(i,i+2)=randi([200,210],1);
    data(i,i+3)=randi([200,210],1);
    data(i,i+4)=randi([200,210],1);
end 

for i = 1:40
%% 
    data(i,i+30)=randi([190,210],1);
end 

% for i = 1:70
%     data(15,i)= randi([260,280],1);
%     data(30,i)= randi([260,280],1);
%     data(45,i)= randi([260,280],1);
% end 


stackStruct.data = data;
t=zeros(60,1);
for i = 1:60
    t(i,1)=i;
end 
stackStruct.dn = t; 

xy=zeros(70,2);
xy(:,1) =150;
xy(:,2) =1:70;  
stackStruct.xyzAll = xy;

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

% Grab xy: x,y position [Nx2] of each pixel in a dimension (equally spaced)
xyz = stackStruct.xyzAll;
xy = xyz(:,1:2);

% Set Twin: the time length of the FFT window (in points)
% For 2 Hz data, Twin = 128 will yield a 64s average current
%Twin = 128; 
Twin = 24; %BL hacked 

% Set Tstep: time length to step the window (in points)
% For 2 Hz data, Tstep = 64 will yield a current estimate every 32 s
%Tstep = 64; 
Tstep = 16; %BL hacked  

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


for i = 1:length(videoCurrentOut.meanV)
    current_t(i)= i*(Tstep/freq);
end 

    












 


