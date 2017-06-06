clear all, close all
seqLength = 1000;
time_struct = [];



for i = 0: 5 : seqLength

    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    [mask_v, targets]= vessel_detection(imgfr,9,200,1);
    [ region,time_struct ] = target_filter(targets, time_struct);

    %imshow(imgdif);
    %drawnow
    
end