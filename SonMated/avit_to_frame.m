clear all


obj = VideoReader('sonofmated5.avi');
  nFrame = 40*25;
  step = 40;
  
  vid4D = zeros([obj.Height obj.Width 3 nFrame/step]);
  figure,
  k = 1;
  for i=1:step:nFrame
      i
      img = read(obj,i);
      vid4D(:,:,:,k) = img;
      imshow(img); drawnow
      k = k+1;
      %pause
  end
  bkg = median(vid4D,4);
  imwrite(uint8(bkg),['BG_1.tif']);
  imshow(uint8(bkg));


vid = read(obj);
frames = obj.NumberOfFrames;
for x = 1 : frames
    imwrite(vid(:,:,:,x),strcat('frame_',num2str(x),'.tif'));
end

% frames - 6255