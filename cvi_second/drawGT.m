function drawGT( vectorGT, i )

%vectorGT [frameNr x y w h id tf] 
%pos [x y w h]

 i=i+2;  %porque o vetor começa em 1  porque os valores estão desde o frame 2808 e não do 2809

 hold on;
 rectangle('Position',[vectorGT(i,2) , vectorGT(i,3), vectorGT(i,4), vectorGT(i,5)], 'EdgeColor',[0.486275 0.988235 0], 'linewidth',2);
 drawnow

 disp(i);
 disp(vectorGT(i,1));
end