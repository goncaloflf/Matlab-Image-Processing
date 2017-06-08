function  iou_plot( iou_vector )

sortedIoU = sort(iou_vector,'descend');

figure;
hold on;
plot(sortedIoU, linspace(0, length(sortedIoU), length(sortedIoU)));
drawnow

end 