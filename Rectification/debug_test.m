
%% To see if the coodinate of all PIV time stack is the same 
for i = 1:58
    test_diff_x(i,:,:) = diff(Products.x_pixel_tot(i,:,:)-Products.x_pixel_tot(i+1,:,:));
end

for i = 1:58
    test_diff_y(i,:,:) = diff(Products.x_pixel_tot(i,:,:)-Products.x_pixel_tot(i+1,:,:));
end

sum(test_diff_x,'all')
sum(test_diff_y,'all')