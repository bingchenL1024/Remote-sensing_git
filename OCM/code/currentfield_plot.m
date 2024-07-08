%this code is used for plotting current field with original video image
addpath /Users/bingchenliu/Desktop/Oceanography/research/OCM/code/Video-Currents-Toolbox-master_BLmodified
%load('/Users/bingchenliu/Desktop/Oceanography/OCM/data/Bingchen_pixInst_600.mat') % 10cm resolution
load('/Users/bingchenliu/Desktop/Oceanography/research/OCM/data/currentV/currentV_Bingchen_pixInst_600_2.mat')
dim = size(vellocation);

figure (1)

for timestep= 1:17
for i = 1: dim(1)
    for j = 1: dim(2)
        quiver(vellocation{i,j}(2),vellocation{i,j}(1),videoCurrentOut{i,j}.along.meanV(timestep),videoCurrentOut{i,j}.cross.meanV(timestep),50,'b','LineWidth',1.5);
        %set(h1,'AutoScale','on', 'AutoScaleFactor', 2)
        
        %% add vector scale 
        %An additional row of points  is added at y=2.2:
        [X,Y]=meshgrid(1850,100);
        %Then a reference arrow velocity is defined at x=0.2 and y=2.2, while rest of points are left as zero:
        u_rf=zeros(1,1);
        v_rf=zeros(1,1);
        u_rf(1,1)=1;
        %Thus, quiver plot is applied including the new row:
        quiver([X;vellocation{i,j}(2)],[Y;vellocation{i,j}(1)],[u_rf;videoCurrentOut{i,j}.along.meanV(timestep)],[v_rf;videoCurrentOut{i,j}.cross.meanV(timestep)],0.05,'b','LineWidth',1.5); %is done like this to be sure we got the same arrow AutoScale
        %Finally some text is included:
        text(1800,50,'Arrow scale: 1m/s')
        hold on 
    end 
end 
hold off 
xlabel('Cross shore location (pixel index)')
ylabel('Along shore location (pixel index)')
drawnow
end 










