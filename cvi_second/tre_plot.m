function  tre_plot( iou_vec )

figure;
hold on;


modAux = mod(length(iou_vec), 5);

interval = (length(iou_vec)-modAux)/5;

v1 = iou_vec(1:interval);
v2 = iou_vec(interval+1: interval*2);
v3 = iou_vec(interval*2+1 : interval*3);
v4 = iou_vec(interval*3+1 : interval*4);
v5 = iou_vec(interval*4+1 : interval*5);


 plot(sort(v1, 'descend'), linspace(0, length(v1),length(v1)), ...
     sort(v2, 'descend'), linspace(0, length(v2),length(v2)), ...
     sort(v3, 'descend'), linspace(0, length(v3),length(v3)), ...
     sort(v4, 'descend'), linspace(0, length(v4),length(v4)), ...
     sort(v5, 'descend'), linspace(0, length(v5),length(v5)));
drawnow

disp(v1);

end 

