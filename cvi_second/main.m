clear all, close all
warning('off', 'Images:initSize:adjustingMag');
seqLength = 1000;
time_struct = [];

%Load Ground Truth into array vectorGT   [frameNr x y w h id tf]  id e tf
%são irreleventes
filename = 'movie.gt.txt';
delimiterIn = ' ';
vectorGT = importdata(filename,delimiterIn);



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

    %imshow(imgdif);
    %drawnow
    
end