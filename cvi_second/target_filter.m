function [ region,time_struct ] = target_filter( targets,time_struct,im ,frame)
%TARGET_FILTER Summary of this function goes here
%   Detailed explanation goes here
    
    minArea = 1000; 
    close = false;
    region = [];
    regionProps = regionprops(targets,'area','Filledimage','Centroid','BoundingBox'); 
    inds = find([regionProps.Area]>minArea);
    usingRed = 0;
   
    regcount = length(inds);
  
    
    if (regcount > 0)

        for k= 1: regcount
            if((regcount == 1 && regionProps(inds(1)).Area > 10000))
               fprintf('AQUI CRL %i.\n',frame);
               [region time_struct] = checkByRed(im, time_struct);
               usingRed = 1;
               
            elseif (regcount > 1)
                bigInd = find([regionProps.Area]>2000);
                aux = 0;
                if(~isempty(bigInd))
                    for v = 1 : regcount
                       if(rectint(regionProps(bigInd(1)).BoundingBox,regionProps(inds(v)).BoundingBox) ~= 0 && (regionProps(bigInd(1)).BoundingBox(1) ~= regionProps(inds(v)).BoundingBox(1)))
                           aux = aux + 1;
                       end
                    end
                    if(aux == regcount - 1)
                       [region time_struct] = checkByRed(im, time_struct);
                       usingRed = 1;
                    end
                end
                    
            end
            

           if(regionProps(inds(k)).BoundingBox(1) <= 0.5 || regionProps(inds(k)).BoundingBox(1)+ regionProps(inds(k)).BoundingBox(3) >= 1023 || regionProps(inds(k)).BoundingBox(2) <= 0.5 ||  regionProps(inds(k)).BoundingBox(2)+ regionProps(inds(k)).BoundingBox(4) >= 767)
%                hold on;
%                rectangle('Position',[regionProps(inds(k)).BoundingBox(1), regionProps(inds(k)).BoundingBox(2),regionProps(inds(k)).BoundingBox(3),regionProps(inds(k)).BoundingBox(4)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
%                drawnow
           elseif usingRed == 0
               
               for j = 1: length(regionProps)
                    close = false;
                    point1=[regionProps(inds(k)).Centroid(1), regionProps(inds(k)).Centroid(2)];
                    point2=[regionProps(j).Centroid(1), regionProps(j).Centroid(2)];
                    distance = pdist([point1(1), point1(2); point2(1), point2(2)],'euclidean');
%                     distance
                    if( (0 < distance) &&(distance < 100))
                        close = true;
                        break;
                    end
                   
               end
               
               if (close == false)
                   size = length(time_struct);
                   if (size == 0 ) 
                       time_struct(size+1).Area = regionProps(inds(k)).Area;
                       time_struct(size+1).Centroid = [regionProps(inds(k)).Centroid(1),regionProps(inds(k)).Centroid(2)];
                       
                   else
                    
                        for z = 1: size
                           if( abs(time_struct(z).Area - regionProps(inds(k)).Area) < 1000 && pdist([time_struct(1).Centroid(1), time_struct(1).Centroid(2); regionProps(inds(k)).Centroid(1),regionProps(inds(k)).Centroid(2)],'euclidean') < 500)
                                time_struct(2:end) = time_struct(1:end-1);
                                time_struct(1).Area = regionProps(inds(k)).Area;
                                time_struct(1).Centroid = [regionProps(inds(k)).Centroid(1),regionProps(inds(k)).Centroid(2)];
                                region = regionProps(inds(k));
                                break;
                           end
                        end
                   end
                   
               
               end
           end
                       if(length(region) == 1)
                            if usingRed == 0
                                rectangle('Position',[region(1).BoundingBox(1), region(1).BoundingBox(2),region(1).BoundingBox(3),region(1).BoundingBox(4)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
                                drawnow
                            elseif usingRed == 1
                                rectangle('Position',[region(1).BoundingBox(1)-30, region(1).BoundingBox(2)-30,region(1).BoundingBox(3)+60,region(1).BoundingBox(4)+60], 'EdgeColor',[1 0 0], 'linewidth',2);
                                drawnow      
                            end
                       end
        end

    end
end

