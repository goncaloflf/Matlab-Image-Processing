function [ regions ] = target_filter( targets )
%TARGET_FILTER Summary of this function goes here
%   Detailed explanation goes here
    
    minArea = 6000; 
    
    regionProps = regionprops(targets,'area','Filledimage','Centroid'); 
    regions = find([regionProps.Area]>minArea);
    regions
    
end

