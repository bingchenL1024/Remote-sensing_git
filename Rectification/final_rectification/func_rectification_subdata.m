%Bingchen Liu Sep 23, 2024
% This is a function used in rectification code
% it runs the rectification for subset of the full data to speed up the
% process

%viewId_input = 1:floor(length(images.Files)/3)

function [Products] = func_rectification_subdata(viewId_input,images,Products,R,iP_u,iP_v,cc,include_gray,include_PIV)
    [rows, cols, numChannels] = size(undistortImage(readimage(images, 1), R(cc).cameraParams.Intrinsics)); %assuming all images in the same 20 min collections are the same dim
    Irgb_temp = repmat(uint8([0]), size(Products(1).localX,1)*size(Products(1).localX,2),numChannels);

        for viewId = viewId_input %=================loop through time --> 2400 frames in total
            tic
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
                    if strcmp(include_gray, 'Yes') 
                        Products(pp).Igray_2d(viewId-viewId_input(1)+1, :,:) =rgb2gray(Irgb_temp_img);
                    end 
                    Products(pp).t_ind(viewId-viewId_input(1)+1) = viewId;
                else
                    Products(pp).Irgb_2d(viewId-viewId_input(1)+1, :,:) = Irgb_temp_img;
                end % if contains(Products(pp).type, 'Grid')
% if viewId == viewId_input(end)
%     keyboard
% end
            end
            toc
        end %=================loop through time --> 2400 frames in total
        
end 