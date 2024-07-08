% This code load the saved timestack and perform analysis on it to obtain
% current in both x and y direction 
clear
addpath /Users/bingchenliu/Desktop/Oceanography/research/OCM/code/Video-Currents-Toolbox-master_BLmodified
load ('/Users/bingchenliu/Desktop/Oceanography/research/OCM/data/timestack_Bingchen_pixInst_600.mat')
load('/Users/bingchenliu/Desktop/Oceanography/research/OCM/data/Bingchen_pixInst_600.mat') % 10cm resolution


stackStruct.data = timestack_raw;

freq=2; %hz
t_step = 1/freq; %time step of the data(depends on sampling frequency, eg:2Hz --> 0.5s)
t=zeros(length(timerange),1);
for i = 1:length(timerange)
    t(i,1)=i*t_step;
end 
t = t(:)/(24*60*60);
stackStruct.dn = t; %time interval for the alongshore transction , should be in unit of days 


%% OCM input/prep outside of the loop 
dim_data = size(timestack_raw);

% Grab time: time line (starting from zero) of stack, size [1xM]
time = stackStruct.dn;
% Set Twin: the time length of the FFT window (in points)
% For 2 Hz data, Twin = 128 will yield a 64s average current
%Twin = 128; 
Twin =40; %BL hacked 

% Set Tstep: time length to step the window (in points)
% For 2 Hz data, Tstep = 64 will yield a current estimate every 32 s
%Tstep = 64; 
Tstep = 20; %BL hacked  

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

parameters = "Twin = 40; Tstep = 20; xrange=10 m; yrange=10 m; spacialresolu = 10 m ";
%% OCM execution 

for i = 1:dim_data(1)
    for j = 1:dim_data(2)

        %alongshore current calculation
        stack_along = stackStruct.data{i,j}.alongshore;
        stack_along =double(stack_along);
        xyz_along = stackStruct.data{i,j}.alongstack_location;
        xy_along = xyz_along(:,1:2);

        currentVel.along = videoCurrentGen(stack_along, time, xy_along, vB, fkB, ...
             Twin, Tstep, plotFlag);



        % cross shore current calculation 
        stack_cross = stackStruct.data{i,j}.crossshore;
        stack_cross =double(stack_cross);
        xyz_cross = stackStruct.data{i,j}.crossstack_location;
        xy_cross = xyz_cross(:,1:2);

        currentVel.cross = videoCurrentGen(stack_cross, time, xy_cross, vB, fkB, ...
             Twin, Tstep, plotFlag);
        
        videoCurrentOut{i,j}= currentVel;

    end 
end 




%% quality control (calculate average standard deviation)
%stdV_ratio.along = zeros(dim_data(1),dim_data(2),length(videoCurrentOut{1,1}.along.meanV));
%stdV_ratio.cross = zeros(dim_data(1),dim_data(2),length(videoCurrentOut{1,1}.cross.meanV));

stdV_abs.along = zeros(dim_data(1),dim_data(2),length(videoCurrentOut{1,1}.along.meanV));
stdV_abs.cross = zeros(dim_data(1),dim_data(2),length(videoCurrentOut{1,1}.cross.meanV));

for i = 1:dim_data(1)
    for j = 1:dim_data(2)
        %stdV_ratio.along(i,j,:) = videoCurrentOut{i,j}.along.stdV./abs(videoCurrentOut{i,j}.along.meanV); %in % std/varible
        %stdV_ratio.cross(i,j,:) = videoCurrentOut{i,j}.cross.stdV./abs(videoCurrentOut{i,j}.cross.meanV); %in % std/varible
                
        
        stdV_abs.along(i,j,:) = videoCurrentOut{i,j}.along.stdV;
        stdV_abs.cross(i,j,:) = videoCurrentOut{i,j}.cross.stdV;
    end 
end

stdV_avg.along = mean(stdV_abs.along(:,:,:),'all')
stdV_avg.cross = mean(stdV_abs.cross(:,:,:),'all')


save('/Users/bingchenliu/Desktop/Oceanography/research/OCM/data/currentV/currentV_Bingchen_pixInst_600_3','videoCurrentOut','vellocation','stdV_avg','parameters')










