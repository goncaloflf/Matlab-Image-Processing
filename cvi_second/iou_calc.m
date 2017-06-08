function  iou_vector  = iou_calc( ground_box_vector, regions_vector )
%IOU_CALC Summary of this function goes here
%   Detailed explanation goes here
    
    aux = [];

     iou_vector = [];
    for h = 1: length(regions_vector)
       if (~isempty(regions_vector(h).Area))
           disp('yo')
           ground_box_vector(h+1,2) 
           ground_box_vector(h+1,3) 
           ground_box_vector(h+1,4) 
           ground_box_vector(h+1,5)
           box=[ground_box_vector(h+1,2) ground_box_vector(h+1,3) ground_box_vector(h+1,4) ground_box_vector(h+1,5)];
            interA = rectint(box, regions_vector(h).BoundingBox);
            unionA = ((ground_box_vector(h+1,4))*(ground_box_vector(h+1,5)))+ ((regions_vector(h).BoundingBox(3))*(regions_vector(h).BoundingBox(4)))- interA;
            iou = interA/unionA;
            iou_vector(length(iou_vector)+1)= iou;
            iou_vector
           
%            size = length(aux)+1;
%            aux(size).Area = regions_vector(h).Area;
%            aux(size).Centroid = regions_vector(h).Centroid;
%            aux(size).BoundingBox = regions_vector(h).BoundingBox;
%            aux(size).FilledImage = regions_vector(h).FilledImage;
%     
       else
           
           
       end
    end


%            box=[ground_box_vector(h+1).X ground_box_vector(h+1).Y ground_box_vector(h+1).W ground_box_vector(h+1).H];
%             interA = rectint(box, regions_vector(h).BoundingBox);
%             unionA = ((ground_box_vector(h+1).W)*(ground_box_vector(h+1).H))+ ((regions_vector(h).BoundingBox(3))*(regions_vector(h).BoundingBox(4)))- interA;
%             iou = interA/unionA;
%             iou_vector(length(iou_vector)+1)= iou;
%             iou_vector


%     interA = rectint(ground_box, test_box);
%     unionA = (ground_box(4)*ground_box(5))+ (test_box(4)*test_box(5))- interA;
%     iou = interA/unionA;


end

