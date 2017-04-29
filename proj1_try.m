clear all, close all

imgbk = imread('SonMated\\BG_1.tif');

thr = 30;

minArea = 20;

seqLength = 6255;

point1 = [0,0];
point2 = [0,0];
cent1= [];
cent2= [];
cent3= [];
cent4= [];

se= strel('disk',9);

figure;


for i = 1: seqLength
    i
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
    
    
    regnum = length(inds);  
    
    if regnum
        for j=1:regnum
            [lin col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            
            
            centmin = 1;

                cent1(i)= regionProps(inds(1)).Centroid(1);
                cent2(i)= regionProps(inds(1)).Centroid(2); 
                cent3(i)= regionProps(inds(2)).Centroid(1);
                cent4(i)= regionProps(inds(2)).Centroid(2); 


            if(length(cent1) > 10)
                centmin = (length(cent1)-10);
            end
            
            for l=(centmin):length(cent1)
                hold on; axis off;
                %line([cent1(l) cent2(l)] , [cent1(l+1) cent2(l+1)], [1 1], 'Marker','.','LineStyle','-', 'Color','red');
                plot(cent1(l),cent2(l), 'Marker', 'd','MarkerFaceColor' ,'r', 'MarkerEdgeColor' ,'k','MarkerSize',3 );                  
                plot(cent3(l),cent4(l), 'Marker', 'd','MarkerFaceColor' ,'b', 'MarkerEdgeColor' ,'k','MarkerSize',3 );
            end
              
            
            
            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[1 1 0], 'linewidth',2);
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

   
   
    