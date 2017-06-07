function  new_box  = change_box( ground_box, direction, size )
%CHANGE_BOX Summary of this function goes here
%   Detailed explanation goes here


    if ( direction == 'u')
        new_box(2) = ground_box(2) * 0.9; 
    elseif ( direction =='d')
         new_box(2) = ground_box(2) * 1.1;
    elseif ( direction == 'l')
         new_box(1) = ground_box(1) * 0.9;
    elseif ( direction == 'r')
         new_box(1) = ground_box(1) * 1.1;
    end
 
    new_box(3) = ground_box(3)* size;
    new_box(4) = ground_box(3)* size;
    
end

