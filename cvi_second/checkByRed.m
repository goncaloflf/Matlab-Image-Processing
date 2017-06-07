function [ output_args ] = checkByRed( im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    snap = im;
    % Extract red by subtracting red from grayscale
    snap_red = imsubtract(snap(:,:,1), rgb2gray(snap));
    % Filter out noise
    snap_red = medfilt2(snap_red, [3 3]);

    % Convert new snapshot to binary
    snap_red = im2bw(snap_red,0.34);

    % Remove pixles less than 300px
    snap_red = bwlabel(snap_red, 8);

    % Label all connected components
    bw_red = bwlabel(snap_red,8);

    % Properties for each labeled region
    stats_red = regionprops(bw_red, 'BoundingBox','Centroid');
    
    
    % Display new image
    hold off
    %imshow(bw_red);
    %drawnow
    % Puts red objects in rectangular box
    for object_red = 1:length(stats_red)
        
        rectangle('Position',[stats_red(object_red).BoundingBox(1)-30, stats_red(object_red).BoundingBox(2)-30,stats_red(object_red).BoundingBox(3)+60,stats_red(object_red).BoundingBox(4)+60], 'EdgeColor',[1 0 0], 'linewidth',2);
        drawnow
        
    end

end



