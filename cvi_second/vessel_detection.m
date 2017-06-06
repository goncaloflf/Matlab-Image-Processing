
function [mask_v, targets] = vessel_detection(I,SR,R_threshold,dif_threshold)
    % I 		- input image
    % mask_v	- binary mask
    % features	- array of region features

    %vessel detection
    %mask = (mask(I,[],3)>R_threshold.*((max(I,[],3)-min(I,[],3))));
    mask = (I(:,:,1)>R_threshold)...
            .*(abs(I(:,:,2)-I(:,:,1))<dif_threshold)...
            .*(abs(I(:,:,3)-I(:,:,1))<dif_threshold);

    SE = strel('disk',SR); mask_v = imdilate(mask,SE);
    
%     imshow(mask_v)
%     drawnow
    targets = bwlabel(mask_v);

   % I(:,:,1)

end
