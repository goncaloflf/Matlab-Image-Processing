function [ region,time_struct ] = target_filter( targets,time_struct, aux )
%TARGET_FILTER Summary of this function goes here
%   Detailed explanation goes here
    
    minArea = 1000; 
    close = false;
    region = [];
    regionProps = regionprops(targets,'area','Filledimage','Centroid','BoundingBox'); 
    inds = find([regionProps.Area]>minArea);
    
   
    regcount = length(inds);
  
    
    if (regcount > 0)

        for k= 1: regcount
 

           if(regionProps(inds(k)).BoundingBox(1) <= 0.5 || regionProps(inds(k)).BoundingBox(1)+ regionProps(inds(k)).BoundingBox(3) >= 1023 || regionProps(inds(k)).BoundingBox(2) <= 0.5 ||  regionProps(inds(k)).BoundingBox(2)+ regionProps(inds(k)).BoundingBox(4) >= 767)
               hold on;
               rectangle('Position',[regionProps(inds(k)).BoundingBox(1), regionProps(inds(k)).BoundingBox(2),regionProps(inds(k)).BoundingBox(3),regionProps(inds(k)).BoundingBox(4)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
               drawnow
           else
               
               for j = 1: length(regionProps)
                    close = false;
                    point1=[regionProps(inds(k)).Centroid(1), regionProps(inds(k)).Centroid(2)];
                    point2=[regionProps(j).Centroid(1), regionProps(j).Centroid(2)];
                    distance = pdist([point1(1), point1(2); point2(1), point2(2)],'euclidean');
%                     distance
                    if( (0 < distance) &&(distance < 200))
                        close = true;
                        break;
                    end
                   
               end
               
               if (close == false)
                   size = length(time_struct);
                   length(time_struct)
                   if (size <= 5 ) 
                       time_struct(size+1).Area = regionProps(inds(k)).Area;
                       time_struct(size+1).Centroid = [regionProps(inds(k)).Centroid(1),regionProps(inds(k)).Centroid(2)];
                       
                   else
                       time_struct(aux).Area = regionProps(inds(k)).Area;
                       time_struct(aux).Centroid = [regionProps(inds(k)).Centroid(1),regionProps(inds(k)).Centroid(2)];
                   end
                   
                   region = regionProps(inds(k));
               end
           end
                       if(length(region) == 1)
                            rectangle('Position',[region(1).BoundingBox(1), region(1).BoundingBox(2),region(1).BoundingBox(3),region(1).BoundingBox(4)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
                            drawnow
                       end
        end

    end
end

