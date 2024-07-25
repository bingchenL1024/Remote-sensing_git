%% get_origin
function [origin_grid] = get_origin(Mopnum)


load('/Users/bingchenliu/Documents/GitHub/Remote-sensing_code/Rectification/Toolbox/MopTableUTM.mat')
origin_grid = [Mop.BackLat(Mopnum) Mop.BackLon(Mopnum) Mop.Normal(Mopnum)];