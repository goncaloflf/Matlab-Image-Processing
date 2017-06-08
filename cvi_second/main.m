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
exec_type=0;
dir = 0;
sca = 0;

disp('Bem vindo aos barquinhos');
disp('1: Execução normal');
disp('2: TRE');
disp('3: SRE');
disp('4: Sair');
opcao = input('Escolha a opção: ');
switch(opcao)
    case 1
        exec_type = 1;
    case 2
        exec_type = 2;
    case 3
        exec_type = 3;
        disp('Escolha a direcção');
        disp('1: Up');
        disp('2: Down');
        disp('3: Left');
        disp('4: Right');
        dir = input('Escolha a direcção: ');
        disp('Escolha o escalamento');
        disp('1: 0,8x');
        disp('2: 0,9x');
        disp('3: 1,1x');
        disp('4: 1,2x');
        sca = input('Escolha o escalamento: ');
    case 4
        return;
    otherwise
        disp('Opção inválida');
        return;
end


for i = 0: 5 : seqLength

    
    imgfr = imread(sprintf('video\\frame_%.1d.tif',2809+ i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr)
    drawnow
    
    if (i < 1000)
        drawGT(vectorGT, i);
    end
    [mask_v, targets]= vessel_detection(imgfr,9,200,1);
    if exec_type == 1
        [ region,time_struct ] = target_filter(targets, time_struct, imgfr, 2809+i);
    elseif exec_type == 2
        [ region,time_struct ] = target_filterGT(targets, time_struct, imgfr, 2809+i,vectorGT);
    elseif exec_type == 3
        [ region,time_struct ] = target_filterSRE(targets, time_struct, imgfr, 2809+i,vectorGT, dir, sca);
    end

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
    tre_plot(vectorIoU, exec_type, dir, sca);
 %   tre_plot( vecIoU1, vecIoU2, vecIoU3, vecIoU4, vecIoU5); 


