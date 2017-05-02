clear all, close all

imgbk = imread('SonMated\\BG_1.tif');

thr = 30;

minArea = 20;

seqLength = 6255;

Switch = false;

nrTouch = 0;
inTouch = false;

firstTouch = 0; %no codigo comentado
firstTouchTime=0; %no codigo comentado
timeSpent=0; %no codigo comentado
timeDisplay=0; %not used

male = 0;
female = 0;

distanceMale=0;
distanceFemale=0;

point1 = [0,0];
point2 = [0,0];
cent1= zeros(seqLength);
cent2= zeros(seqLength);
cent3= zeros(seqLength);
cent4= zeros(seqLength);

se= strel('disk',9);

figure;



for i = 1: seqLength
    
    imgfr = imread(sprintf('SonMated\\frame_%.1d.tif',i)); %corre cada frame do video com o ciclo //works
    hold off
    imshow(imgfr);
    
    imgdif = ... %cria uma binary image imgdif que � a diferen�a entre o frame actual e o background dando uma imagem com os elementos que se est�o a mover // works
       (abs(double(imgbk(:,:,1))-double(imgfr(:,:,1)))>thr) | ...
       (abs(double(imgbk(:,:,2))-double(imgfr(:,:,2)))>thr) | ...
       (abs(double(imgbk(:,:,3))-double(imgfr(:,:,3)))>thr);
    
    %imshow(imgdif);
    %drawnow
    
    bw = imclose(imgdif, se); % faz uma dilata��o seguida de uma eros�o com SE correspondente //works

    %imshow(bw);
    %drawnow    

    [lb num]=bwlabel(bw); % faz label das zonas encontradas no imgdif //works
    regionProps = regionprops(lb,'area','Filledimage','Centroid'); % vai buscar as propriedades das zonas encontradas //works

    
    inds = find([regionProps.Area]>minArea);
    
%     for z=1:length(regionProps)
%        regionProps.Area 
%     end

    %find male and female
    if (length(inds)) > 1
        if(regionProps(inds(1)).Area > regionProps(inds(2)).Area)
            male = 2; female = 1;male_o = 2; female_o = 1;
        else
            male = 1; female = 2;male_o = 1; female_o = 2;
        end
    else
        male = 1; female = 1;male_o = 1; female_o = 1;
    end
            
    
    regnum = length(inds);  
    
    if regnum
        
        centmin = 1;
        if (length(inds)> 1)
            cent1(i)= regionProps(inds(male)).Centroid(1);
            cent2(i)= regionProps(inds(male)).Centroid(2); 
            cent3(i)= regionProps(inds(female)).Centroid(1);
            cent4(i)= regionProps(inds(female)).Centroid(2); 
        else
            cent1(i)= regionProps(inds(1)).Centroid(1);
            cent2(i)= regionProps(inds(1)).Centroid(2); 
            cent3(i)= regionProps(inds(1)).Centroid(1);
            cent4(i)= regionProps(inds(1)).Centroid(2); 
        end

        if(i > 10)
            centmin = (i-10);
        end    

        for l=(centmin):i
            hold on; axis off;
            if (  l > 2 )
                
                d1 = pdist([cent1(l-1), cent2(l-1) ; cent1(l), cent2(l)],'euclidean');
                d1_aux = pdist([cent1(l-1), cent2(l-1) ; cent3(l), cent4(l)],'euclidean');
                d2 = pdist([cent3(l-1), cent4(l-1) ; cent3(l), cent4(l)],'euclidean');
                d2_aux = pdist([cent3(l-1), cent4(l-1) ; cent1(l), cent2(l)],'euclidean');
                if ( d1_aux < d1 && Switch == false)
                    male_switch = female;
                    female_switch = male;
                    d1 = d1_aux;
                    male = male_switch;
                    female = female_switch;
                    Switch = true;
                elseif ( d2_aux < d2 && Switch == false)
                    male_switch = female;
                    female_switch = male;
                    d2 = d2_aux;
                    male = male_switch;
                    female = female_switch;
                    Switch = true;
                else 
                    male = male_o;
                    female = female_o;
                    Switch = false;
                end
                
                str1 = strcat('Mite 1 velocity: ',num2str(d1), ' pixel/frame');
                str2 = strcat('Mite 2 velocity: ',num2str(d2), ' pixel/frame');

                distanceMale = distanceMale + d1; %fix, not d1
                distanceFemale = distanceFemale + d2; %fix, not d2

                if ( Switch == true)
                line([cent1(l-1) cent3(l)] , [cent2(l-1)  cent4(l)], [1 1],'LineWidth',2.25,'LineStyle','-', 'Color','red');
                line([cent3(l-1) cent1(l)] , [cent4(l-1)  cent2(l)], [1 1],'LineWidth',2.25,'LineStyle','-', 'Color','blue');
                Switch = false;
                else
                    line([cent1(l-1) cent1(l)] , [cent2(l-1)  cent2(l)], [1 1],'LineWidth',2.25,'LineStyle','-', 'Color','red');
                    line([cent3(l-1) cent3(l)] , [cent4(l-1)  cent4(l)], [1 1],'LineWidth',2.25,'LineStyle','-', 'Color','blue');
                end
    %             plot([cent1(l-1) cent1(l)] , [cent2(l-1)  cent2(l)])
    %             plot([cent3(l-1) cent3(l)] , [cent4(l-1)  cent4(l)])
    %             plot(cent1(l),cent2(l), 'Marker', 'd','MarkerFaceColor' ,'r', 'MarkerEdgeColor' ,'k','MarkerSize',3 );                  
    %             plot(cent3(l),cent4(l), 'Marker', 'd','MarkerFaceColor' ,'b', 'MarkerEdgeColor' ,'k','MarkerSize',3 );
            end
        end         
        
        
        for j=1:regnum
            [lin col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            
            if(j==male)
                rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[0.117647 0.564706 1], 'linewidth',2);
            elseif(j==female)
                rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)], 'EdgeColor',[1 0.0784314 0.576471], 'linewidth',2)
            end
        end

    if (length(inds) > 1)
        
        point1=[regionProps(inds(1)).Centroid(1), regionProps(inds(1)).Centroid(2)];
        point2=[regionProps(inds(2)).Centroid(1), regionProps(inds(2)).Centroid(2)];

        X = [point1(1), point1(2); point2(1), point2(2)];    

        %Euclidean distance of the coins
        distance = pdist(X,'euclidean');
        line([point1(1) point2(1)] , [point1(2) point2(2)], [1 1], 'Marker','.','LineStyle','-', 'Color','red');
        middlePoint = [(point1(1)+point2(1))/2, (point1(2)+point2(2))/2];
        time = text(middlePoint(1), middlePoint(2), num2str(distance)); 
        
        inTouch = false;
        
    else
        distance = 0;
        if (inTouch == false)
            inTouch=true;
            nrTouch = nrTouch + 1;
        end
%         if (firstTouch==0)    %Codigo para detetar primeiro toque
%             firstTouchTime=timeSpent;
%             firstTouch=1;
%         end
%             
    end
     

    if (length(inds)> 1 && l > 2)
        tex = text(0, -100, str1);
        tex1 = text(0, -60, str2);
    end
    
    str3 = strcat('Distance performed by the male: ', num2str(distanceMale), ' pixels');
    str4 = strcat('Distance performed by the female: ', num2str(distanceMale), ' pixels');
    str5 = strcat('Time spent until the 1st couple (or touch) occurs: ', 'todo'); %insert time variable
    str6 = strcat('Number of touches: ', num2str(nrTouch));

    %Display distante
    tex2 = text(0, -300, str3);
    tex3 = text(0, -260, str4);
    
    %Display legend: Male, Female
    tex4 = text(0, 500, '\bullet', 'color',[0.117647 0.564706 1] );
    tex5 = text(20, 500, 'Male');
    tex6 = text(110, 500, '\bullet', 'color',[1 0.0784314 0.576471]);
    tex7 = text(130, 500, 'Female');
    
    %Display Time
    tex8 = text(0, -160, str5);
    
    %Display Touhes
    tex9 = text(0, -200, str6);


    subplot(1,2,1);
    
    
    x(i) = i;
    y(i) = distance; 
    plot(x,y);
    
    hTitle  = title ('Distance Between Mites');
    hYLabel = ylabel('Distance (pixel) ');
    hXLabel = xlabel('Frames ');
   

    set( gca                       , ...
    'FontName'   , 'Helvetica' );
    set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
    set([gca]             , ...
    'FontSize'   , 8           );
    set([hXLabel, hYLabel]  , ...
    'FontSize'   , 10          );
    set( hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );

    set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'on'      , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'LineWidth'   , 1         );
    subplot(1,2,2);
    drawnow

    end
 
    end





   
   
    