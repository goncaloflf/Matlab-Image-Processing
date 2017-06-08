clear all, close all
warning('off', 'Images:initSize:adjustingMag');
seqLength = 1000;
time_struct = [];
regions_vector = {};
truth_vector = [];

%Load Ground Truth into array vectorGT   [frameNr x y w h id tf]  id e tf
%são irreleventes
filename = 'movie.gt.txt';
delimiterIn = ' ';
vectorGT = importdata(filename,delimiterIn);

vectorIoU = zeros(1000);

%for i = 0: 5 : seqLength

for i = 0: 5:  seqLength

    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    if (i < 1000)
        drawGT(vectorGT, i);
    end
    [mask_v, targets]= vessel_detection(imgfr,9,200,1);
    [ region,time_struct ] = target_filter(targets, time_struct, imgfr, 2809+i);
   

    if (~isequal(region, []))
        regions_vector(i).Area = region.Area;
        regions_vector(i).Centroid = region.Centroid;
        regions_vector(i).BoundingBox = region.BoundingBox;
        regions_vector(i).FilledImage = region.FilledImage;
        indice = find (vectorGT(:,1) == 2809 + i);
        size = length(truth_vector)+1;
        truth_vector(size).Frames = vectorGT(indice,1);
        truth_vector(size).X = vectorGT(indice,2);
        truth_vector(size).Y = vectorGT(indice,3);
        truth_vector(size).W = vectorGT(indice,4);
        truth_vector(size).H = vectorGT(indice,5);
        
    end

    %imshow(imgdif);
    %drawnow
    
end
    vectorIoU=iou_calc(vectorGT, regions_vector);
    iou_plot(vectorIoU);
    tre_plot(vectorIoU);
 %   tre_plot( vecIoU1, vecIoU2, vecIoU3, vecIoU4, vecIoU5); 


