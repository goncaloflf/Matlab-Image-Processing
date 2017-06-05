clear all, close all
seqLength = 1000;


for i = 0: seqLength
 
  
    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    vessel_detection(imgfr,9,200,1);
    %imshow(imgdif);
    %drawnow
    
end