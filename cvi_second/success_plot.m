function  success_plot( iou_vector )
%SUCCESS_PLOT Summary of this function goes here
%   Detailed explanation goes here
    new_vector =zeros(1,10);
    for i=1: length(iou_vector)
        j = round(iou_vector(i)*10);
        for k = 1: j
            new_vector(k) = new_vector(k) +1;
        end
    end
    
    figure;
    plot([0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], new_vector);
    
end

