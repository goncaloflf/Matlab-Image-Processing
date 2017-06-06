clear all, close all
seqLength = 1000;
time_struct = [];
aux = 1;


for i = 0: 5 : seqLength
 
    if (aux < 5)
       aux = aux + 1; 
    else
       aux = 1;
    end
    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    [mask_v, targets]= vessel_detection(imgfr,9,200,1);
    [ region,time_struct ] = target_filter(targets, time_struct, aux);

    %imshow(imgdif);
    %drawnow
    
end