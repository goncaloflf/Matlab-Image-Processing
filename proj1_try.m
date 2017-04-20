clear all

%imgbk = imread('SonMated\\bg.tif');

vid = VideoReader('sonofmated5.avi');
imgbk = median(vid,4);

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
    cent = regionProps.Centroid;
    
    regnum = length(inds);  
    
    if regnum
        for j=1:regnum
            [lin col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            
            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[1 1 0], 'linewidth',2);
        end

    if (length(regionProps) > 1)
        
        point1=[regionProps(1).Centroid(1), regionProps(1).Centroid(2)];
        point2=[regionProps(2).Centroid(1), regionProps(2).Centroid(2)];

        X = [point1(1), point1(2); point2(1), point2(2)];    

        %Euclidean distance of the coins
        distance = pdist(X,'euclidean');
        line([point1(1) point2(1)] , [point1(2) point2(2)], [1 1], 'Marker','.','LineStyle','-', 'Color','red');
        middlePoint = [(point1(1)+point2(1))/2, (point1(2)+point2(2))/2];
        t = text(middlePoint(1), middlePoint(2), num2str(distance)); 
        
        
  
        %scatter(distance, i);
         
    end

        
    end
    drawnow     
    
    
end