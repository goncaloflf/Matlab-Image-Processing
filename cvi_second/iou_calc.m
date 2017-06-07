function  iou  = iou_calc( ground_box, test_box )
%IOU_CALC Summary of this function goes here
%   Detailed explanation goes here
    
    interA = rectint(ground_box, test_box);
    unionA = (ground_box(3)*ground_box(4))+ (test_box(3)*test_box(4))- interA;
    iou = interA/unionA;


end

