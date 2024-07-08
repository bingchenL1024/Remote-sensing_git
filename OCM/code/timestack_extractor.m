%this function is used to get time stacks for a given location. And it will
%be used in timestack_prep to generate time stack in multiple location and
%time 

%example of input 
%xlocation = 1980;
%ylocation = 1350;
%xrange = 0;
%yrange = 200;
%t_range = 1:600;


function data = timestack_extractor_2D(xlocation,ylocation,xrange,yrange,t_range,data_gray)


function data = timestack_extractor_1D(xlocation,ylocation,xrange,yrange,t_range,data_gray)

freq=2;
t_step = 1/freq; %time step of the data(depends on sampling frequency, eg:2Hz --> 0.5s)


crossshore_d = (xlocation-xrange/2):(xlocation+xrange/2); %distance offshore - check pixInst.X
alongshore_d = (ylocation-yrange/2):(ylocation+yrange/2);% transction distance along shore - check pixInst.Y


Ir=squeeze(data_gray(alongshore_d, crossshore_d,t_range));
data = Ir';

end 

