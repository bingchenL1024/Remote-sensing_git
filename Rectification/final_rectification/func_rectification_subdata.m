%Bingchen Liu Sep 23, 2024
% This is a function used in rectification code
% it runs the rectification for subset of the full data to speed up the
% process

%viewId_input = 1:floor(length(images.Files)/3)

function [Products] = func_rectification_subdata(viewId_input,images,Products,R,iP_u,iP_v,cc,include_gray)
    [rows, cols, numChannels] = size(undistortImage(readimage(images, 1), R(cc).cameraParams.Intrinsics)); %assuming all images in the same 20 min collections are the same dim
    Irgb_temp = repmat(uint8([0]), size(Products(1).localX,1)*size(Products(1).localX,2),numChannels);

        for viewId = viewId_input %=================loop through time --> 2400 frames in total
            tic%
            I = undistortImage(readimage(images, viewId), R(cc).cameraParams.Intrinsics);
            for pp = 1:length(Products)
                % clear Irgb_temp
                % Irgb_temp(:) = NaN; %V0 Carson and Bingchen modificationsep20 
                %[rows, cols, numChannels] = size(I);
                %Irgb_temp = repmat(uint8([0]), size(Products(pp).localX,1)*size(Products(pp).localX,2),numChannels);

                for i = 1:numChannels
                        channel = I(:,:,i);
                        Irgb_temp(~isnan(iP_u),i) = channel(sub2ind([rows, cols], iP_u(~isnan(iP_u)), iP_v(~isnan(iP_u))));
                end
                Irgb_temp_img=reshape(Irgb_temp, size(Products(pp).localX,1),size(Products(pp).localX,2),3);
            
                if contains(Products(pp).type, 'Grid')
                    if strcmp(include_gray, 'No') 
                        Products(pp).Irgb_2d(viewId-viewId_input(1)+1, :,:,:) = Irgb_temp_img;
                    end 
                    if strcmp(include_gray, 'Yes') % =======================================================================perform PIV
                        %Products(pp).Igray_2d(viewId-viewId_input(1)+1, :,:) =rgb2gray(Irgb_temp_img);
                        if viewId-viewId_input(1) == 0 %if it is the first frame
                            im_PIV.A =  rgb2gray(Irgb_temp_img);
                        else  % if it's not the first frame --> do PIV 
                            im_PIV.B = rgb2gray(Irgb_temp_img);
                            interrogationarea = 128;%64; % window size of first pass
                            step = 64; % step of first pass
                            subpixfinder = 1; % 1 = 3point Gauss, 2 = 2D Gauss
                            mask_inpt = [];%[]; %Mask, if needed, generate via: imagesc(image); [temp,Mask{1,1},Mask{1,2}]=roipoly;
                            roi_inpt = []; %Region of interest: [x,y,width,height] in pixels
                            passes = 4;%2  % 1-4 nr. of passes
                            int2 = 64;%32 % second pass window size
                            int3 = 32; % third pass window size
                            int4 = 16; % fourth pass window size
                            imdeform = '*linear'; % '*spline' is more accurate, but slower
                            repeat = 0; % 0 or 1 : Repeat the correlation four times and multiply the correlation matrices.
                            mask_auto = 0; % 0 or 1 : Disable Autocorrelation in the first pass.
                            do_linear_correlation = 0; % 0 or 1 : Use circular correlation (0) or linear correlation (1).
                            do_correlation_matrices = 0;  % 0 or 1 : Disable Autocorrelation in the first pass.
                            repeat_last_pass = 0; % 0 or 1 : Repeat the last pass of a multipass analyis
                            delta_diff_min = 0.025; % Repetitions of last pass will stop when the average difference to the previous pass is less than this number.
     
                            [x_pixel,y_pixel,u_pixel_raw,v_pixel_raw,~,CC,~] = piv_FFTmulti(im_PIV.A,im_PIV.B,interrogationarea,step, ...
                                subpixfinder,mask_inpt,roi_inpt,passes,int2,int3,int4,imdeform,repeat,mask_auto,do_linear_correlation, ...
                                do_correlation_matrices,repeat_last_pass,delta_diff_min);
                            %x_pixel_tot(t,:,:) = x_pixel;
                            %y_pixel_tot(t,:,:) = y_pixel;
                            %u_pixel = u_pixel_raw.*spa_res.*temp_res;
                            %v_pixel = v_pixel_raw.*spa_res.*temp_res;
                            Products.x_pixel_tot(viewId-viewId_input(1),:,:)=x_pixel;
                            Products.y_pixel_tot(viewId-viewId_input(1),:,:)=y_pixel;
                            Products.u_pixel_tot(viewId-viewId_input(1),:,:) = u_pixel_raw;
                            Products.v_pixel_tot(viewId-viewId_input(1),:,:) = v_pixel_raw;
                            Products.CC_tot(viewId-viewId_input(1),:,:) = CC;
                            im_PIV.A= im_PIV.B;
                            im_PIV.B= [];
                        end % If this is the first frame or not 
                    end %=====================================================================================================perform PIV
                    Products(pp).t_ind(viewId-viewId_input(1)+1) = viewId;
                else
                    Products(pp).Irgb_2d(viewId-viewId_input(1)+1, :,:) = Irgb_temp_img;
                end % if contains(Products(pp).type, 'Grid')
                % if viewId  == 5 %for debug 
                %     keyboard
                % end 

            end
            toc


        end %=================loop through time --> 2400 frames in total
        
end 