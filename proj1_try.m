clear all, close all

tic

imgbk = imread('SonMated\\BG_1.tif');

thr = 30;

minArea = 20;

seqLength = 6255;

t=0;

nrTouch = 0;
inTouch = false;
firstTouch = 0;

male = 0;
female = 0;

distanceMale=0;
distanceFemale=0;

point1 = [0,0];
point2 = [0,0];
cent1= zeros(seqLength);
cent2= zeros(seqLength);
cent3= zeros(seqLength);
cent4= zeros(seqLength);

se= strel('disk',9);

figure;


for i = 1: seqLength
    
    imgfr = imread(sprintf('SonMated\\frame_%.1d.tif',i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr);
    
    imgdif = ... %cria uma binary image imgdif que é a diferença entre o frame actual e o background dando uma imagem com os elementos que se estão a mover // works
       (abs(double(imgbk(:,:,1))-double(imgfr(:,:,1)))>thr) | ...
       (abs(double(imgbk(:,:,2))-double(imgfr(:,:,2)))>thr) | ...
       (abs(double(imgbk(:,:,3))-double(imgfr(:,:,3)))>thr);
    
    %imshow(imgdif);
    %drawnow
    
    bw = imclose(imgdif, se); % faz uma dilatação seguida de uma erosão com SE correspondente //works

    %imshow(bw);
    %drawnow    

    [lb num]=bwlabel(bw); % faz label das zonas encontradas no imgdif //works
    regionProps = regionprops(lb,'area','Filledimage','Centroid'); % vai buscar as propriedades das zonas encontradas //works

    
    inds = find([regionProps.Area]>minArea);
    
%     for z=1:length(regionProps)
%        regionProps.Area 
%     end

    %find male and female
    if (length(inds)) > 1
        if(regionProps(inds(1)).Area > regionProps(inds(2)).Area)
            male = 2; female = 1;
        else
            male = 1; female = 2;
        end
    else
        male = 1; female = 1;
    end
            
    
    regnum = length(inds);  
    
    if regnum
        for j=1:regnum
            [lin col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            
            
            centmin = 1;
            if (length(inds)> 1)
                cent1(i)= regionProps(inds(1)).Centroid(1);
                cent2(i)= regionProps(inds(1)).Centroid(2); 
                cent3(i)= regionProps(inds(2)).Centroid(1);
                cent4(i)= regionProps(inds(2)).Centroid(2); 
            end

            if(i > 10)
                centmin = (i-10);
            end

              
            
            if(j==male)
                rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
            elseif(j==female)
                rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[1 0.0784314 0.576471], 'linewidth',2)
            end
        end

    if (length(inds) > 1)
        
        point1=[regionProps(inds(1)).Centroid(1), regionProps(inds(1)).Centroid(2)];
        point2=[regionProps(inds(2)).Centroid(1), regionProps(inds(2)).Centroid(2)];

        X = [point1(1), point1(2); point2(1), point2(2)];    

        %Euclidean distance of the coins
        distance = pdist(X,'euclidean');
        line([point1(1) point2(1)] , [point1(2) point2(2)], [1 1], 'Marker','.','LineStyle','-', 'Color','red');
        middlePoint = [(point1(1)+point2(1))/2, (point1(2)+point2(2))/2];
        t = text(middlePoint(1), middlePoint(2), num2str(distance)); 
        
        inTouch = false;
        
    else
        distance = 0;
        if (inTouch == false)
            inTouch=true;
            nrTouch = nrTouch + 1;
        end
        if (firstTouch==0)
            firtTouch=1;
            t=toc;
        end
    end
    
    for l=(centmin):i
        hold on; axis off;
        if (length(inds)> 1 && l > 2)
            d1 =  pdist([cent1(l-1), cent1(l) ; cent2(l-1), cent2(l)],'euclidean');
            d2 =  pdist([cent3(l-1), cent3(l) ; cent4(l-1), cent4(l)],'euclidean');
            str1 = strcat('Mite 1 velocity: ',num2str(d1), ' pixel/frame');
            str2 = strcat('Mite 2 velocity: ',num2str(d2), ' pixel/frame');
            
            distanceMale = distanceMale + d1; %fix, not d1
            distanceFemale = distanceFemale + d2; %fix, not d2
            
            
            line([cent1(l-1) cent1(l)] , [cent2(l-1)  cent2(l)], [1 1],'LineStyle','-', 'Color','red');
            line([cent3(l-1) cent3(l)] , [cent4(l-1)  cent4(l)], [1 1],'LineStyle','-', 'Color','blue');
%             plot([cent1(l-1) cent1(l)] , [cent2(l-1)  cent2(l)])
%             plot([cent3(l-1) cent3(l)] , [cent4(l-1)  cent4(l)])
%             plot(cent1(l),cent2(l), 'Marker', 'd','MarkerFaceColor' ,'r', 'MarkerEdgeColor' ,'k','MarkerSize',3 );                  
%             plot(cent3(l),cent4(l), 'Marker', 'd','MarkerFaceColor' ,'b', 'MarkerEdgeColor' ,'k','MarkerSize',3 );
        end
    end 
    if (length(inds)> 1 && l > 2)
        tex = text(0, -100, str1);
        tex1 = text(0, -60, str2);
    end

    subplot(1,2,1);
    
    
    x(i) = i;
    y(i) = distance; 
    plot(x,y);
    
    hTitle  = title ('Distance Between Mites');
    hYLabel = ylabel('Distance (pixel) ');
    hXLabel = xlabel('Frames ');
    set( gca                       , ...
    'FontName'   , 'Helvetica' );
    set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
    set([gca]             , ...
    'FontSize'   , 8           );
    set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );
    set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );

    set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'LineWidth'   , 1         );
    subplot(1,2,2);
    drawnow

    end
 

end
disp(num2str(t));
fprintf('Number of touches: %i \n', nrTouch);
%fprintf('Time spent until the 1st couple (or touch) occurs: %s \n', num2str(t));
fprintf('Distance performed by the male: %i \n', distanceMale);
fprintf('Distance performed by the female: %i \n', distanceFemale);

   
   
    