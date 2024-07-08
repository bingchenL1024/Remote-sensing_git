%this function is used to get time stacks for a given location. And it will
%be used in timestack_prep to generate time stack in multiple location and
%time 

%example of input 
%xlocation = 1980;
%ylocation = 1350;
%xrange = 0; range when computing x direction velocity
%yrange = 200; range when computing y direction velocity
%t_range = 1:600;


function data = timestack_extractor_2D(xlocation,ylocation,xrange,yrange,t_range,data_gray,xlocmap,ylocmap)

data.alongshore = timestack_extractor_1D(xlocation,ylocation,0,yrange,t_range,data_gray);
data.crossshore = timestack_extractor_1D(xlocation,ylocation,xrange,0,t_range,data_gray);


alongstack_location = zeros(length((ylocation-yrange/2):(ylocation+yrange/2)),2);
alongstack_location(:,1) = xlocmap(1,xlocation);
alongstack_location(:,2) = ylocmap((ylocation-yrange/2):(ylocation+yrange/2),1);
data.alongstack_location = alongstack_location;

crossstack_location = zeros(length((xlocation-xrange/2):(xlocation+xrange/2)),2);
crossstack_location(:,1) = xlocmap(1,(xlocation-xrange/2):(xlocation+xrange/2));
crossstack_location(:,2) = ylocmap(ylocation,1);
data.crossstack_location = crossstack_location;
end 




function data1 = timestack_extractor_1D(xlocation,ylocation,xrange,yrange,t_range,data_gray)

crossshore_d = (xlocation-xrange/2):(xlocation+xrange/2); %distance offshore - check pixInst.X
alongshore_d = (ylocation-yrange/2):(ylocation+yrange/2);% transction distance along shore - check pixInst.Y


Ir=squeeze(data_gray(alongshore_d, crossshore_d,t_range));
data1 = Ir';

end 

