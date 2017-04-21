clear all, close all

imgbk = imread('SonMated\\BG_1.tif');

thr = 30;

minArea = 20;

seqLength = 6255;

point1 = [0,0];
point2 = [0,0];

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
    
    
    regnum = length(inds);  
    
    if regnum
        for j=1:regnum
            [lin col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            
%             cent1(i)= regionProps(j).Centroid(1);
%             cent2(i)= regionProps(j).Centroid(2);
%            
%              TENTATIVA DE FAZER O PATH, QUASE QUE FUNCIONAVA 
% 
%             for l=1:length(cent1)
%                 hold on; axis off;
%                 plot(cent1(l),cent2(l), 'Marker', 'd','MarkerFaceColor' ,'r', 'MarkerEdgeColor' ,'k','MarkerSize',3 );
%             end
                
            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[1 1 0], 'linewidth',2);
        end

    if (length(regionProps) == 2)
        
        point1=[regionProps(1).Centroid(1), regionProps(1).Centroid(2)];
        point2=[regionProps(2).Centroid(1), regionProps(2).Centroid(2)];

        X = [point1(1), point1(2); point2(1), point2(2)];    

        %Euclidean distance of the coins
        distance = pdist(X,'euclidean');
        line([point1(1) point2(1)] , [point1(2) point2(2)], [1 1], 'Marker','.','LineStyle','-', 'Color','red');
        middlePoint = [(point1(1)+point2(1))/2, (point1(2)+point2(2))/2];
        t = text(middlePoint(1), middlePoint(2), num2str(distance));    
         
    elseif (length(regionProps) > 2)
%         Amax=0;
%         Amin=0;
%         for k=1:length(regionProps)
%             if regionProps(k).Area > Amax
%                 Amax = regionProps(k).Area;
%                 point1=[regionProps(k).Centroid(1), regionProps(k).Centroid(2)];
%             elseif (regionProps(k).Area < Amax && regionProps(k).Area > Amin)
%                 Amin = regionProps(k).Area;
%                 point2=[regionProps(k).Centroid(1), regionProps(k).Centroid(2)];
%             end
%         end
     
 
        
    else
        distance = 0;
    end
    
    drawnow
    subplot(1,2,1);
    x(i) = i;
    y(i) = distance;
    
    plot(x,y);
    drawnow
    subplot(1,2,2);
    
   
    end

    
      
    
end

   
   
    