clear all, close all
seqLength = 1000;


for i = 0: seqLength
 
  
    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    [mask_v, targets]= vessel_detection(imgfr,9,200,1);
    target_filter(targets);

    %imshow(imgdif);
    %drawnow
    
end