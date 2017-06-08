function [centroid , area ] = change_box( ground_box, direction, sca , frame)
%CHANGE_BOX Summary of this function goes here
%   Detailed explanation goes here

%vectorGT [frameNr x y w h id tf] 
%         disp('1: Up');
%         disp('2: Down');
%         disp('3: Left');
%         disp('4: Right');

%         disp('1: 0,8x');
%         disp('2: 0,9x');
%         disp('3: 1,1x');
%         disp('4: 1,2x');

    if ( direction == 1)
         new_box(3) = ground_box(frame-2810,3) * 0.9; 
    elseif ( direction == 2)
         new_box(3) = ground_box(frame-2810,3) * 1.1;
    elseif ( direction == 3)
         new_box(2) = ground_box(frame-2810,2) * 0.9;
    elseif ( direction == 4)
         new_box(2) = ground_box(frame-2810,2) * 1.1;
    end
 
    switch(sca)
        case 1
            size = 0.8;
        case 2
            size = 0.9;
        case 3
            size = 1.1;
        case 4
            size = 1.2;
    end
    
    new_box(4) = ground_box(frame-2810,4)* size;   
    new_box(5) = ground_box(frame-2810,5)* size;
    new_box(6) = ground_box(frame-2810,6);
    new_box(1) = ground_box(frame-2810,1);
    new_box(7) = ground_box(frame-2810,7);
    
    centroid = [new_box(2) + new_box(4)/2, new_box(3) + new_box(5)/2];
    area = new_box(5) * new_box(4);
end

