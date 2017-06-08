function [ region , time_struct  ] = checkByRedGT( im , time_struct, vectorGT, flag, frame)
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
    regionProps= regionprops(bw_red,'area','Filledimage','Centroid','BoundingBox');

    if flag == 1
       time_struct = [];
       time_struct(1).Centroid = [vectorGT(frame-2810,2)+(vectorGT(frame-2810,4)/2),vectorGT(frame-2810,3)+(vectorGT(frame-2810,5)/2)]; 
       time_struct(1).Area = 900;
    end
    
    lastcent=[time_struct(1).Centroid(1),time_struct(1).Centroid(2)];
    dist = 150;
    region = [];   
    
    for i = 1 : length(regionProps)
       aux_point = [regionProps(i).Centroid(1),regionProps(i).Centroid(2)];
       aux_dist = pdist([lastcent(1),lastcent(2);aux_point(1),aux_point(2)],'euclidean');
       if aux_dist < dist 
           region = regionProps(i);
           dist = aux_dist;
       end
    end
    
    if length(region) == 1
        time_struct(2:end) = time_struct(1:end-1);
        time_struct(1).Area = 900;
        time_struct(1).Centroid = [region.Centroid(1),region.Centroid(2)];
    end


    % Puts red objects in rectangular box
%     hold on
%     for object_red = 1:length(stats_red)
%         
%         rectangle('Position',[stats_red(object_red).BoundingBox(1)-30, stats_red(object_red).BoundingBox(2)-30,stats_red(object_red).BoundingBox(3)+60,stats_red(object_red).BoundingBox(4)+60], 'EdgeColor',[1 0 0], 'linewidth',2);
%         drawnow
%         
%     end
%     hold off

end



