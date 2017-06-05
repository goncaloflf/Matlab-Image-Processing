clear all


obj = VideoReader('video.avi');




for x = 2809 : 3809
    img = read(obj,x);
    imwrite(img,strcat('frame_',num2str(x),'.tif'));
end

% frames - 6255