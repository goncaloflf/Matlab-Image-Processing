function proj1_try

    clear all, close all

    globalCount = tic;

    imgbk = imread('SonMated\\BG_1.tif');

    thr = 30;

    minArea = 20;

    seqLength = 6255;

    Switch = false;

    nrTouch = 0;
    inTouch = false;


nrCouples=0;
coupleDurations = zeros(1,10);


    firstTouch = 0; 
    firstTouchTime=0; 
    totalTime=0;


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

    rate = 1;
    
    drawTrail = true;
    lastNormal = -10;
    x = [];
    y = [];
    
    function faster(source,event) 
       rate = rate * 2;
       drawTrail = false;
    end

    function normalSpeed(source,event)
       rate = 1;
       drawTrail = true;
       lastNormal = i;
    end

    i=1;

    while i <= seqLength
        
        countTime = tic;

        imgfr = imread(sprintf('SonMated\\frame_%.1d.tif',i)); %corre cada frame do video com o ciclo //works
        hold off
        imshow(imgfr);


        
        
        imgdif = ... %cria uma binary image imgdif que ? a diferen?a entre o frame actual e o background dando uma imagem com os elementos que se est?o a mover // works
        (abs(double(imgbk(:,:,1))-double(imgfr(:,:,1)))>thr) | ...
        (abs(double(imgbk(:,:,2))-double(imgfr(:,:,2)))>thr) | ...
        (abs(double(imgbk(:,:,3))-double(imgfr(:,:,3)))>thr);
        
        %imshow(imgdif);
        %drawnow
        
        bw = imclose(imgdif, se); % faz uma dilata??o seguida de uma eros?o com SE correspondente //works

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

            if(drawTrail && i-lastNormal > 10)
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
                        
                        str1 = strcat('Mite 1 velocity: ',space, num2str(d1), space, ' pixel/frame');
                        str2 = strcat('Mite 2 velocity: ',space, num2str(d2), space, ' pixel/frame');

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
            
            if (inTouch==true)
                inTouch = false;
                duration = toc(coupleTime)*rate;
                if (duration >= 60)
                    nrCouples=nrCouples + 1;
                    coupleDurations(nrCouples+1)=duration;
                end
            end
            inTouch = false;
            
        else
            hold off
            distance = 0;
            img_crop = imcrop(imgfr, [regionProps(inds(1)).Centroid(1)-50,regionProps(inds(1)).Centroid(2)-50,100,100]);
            img_resized = imresize(img_crop,[480,720]);
            imshow(img_resized);
            if (inTouch == false)
                inTouch=true;
                coupleTime = tic;
                nrTouch = nrTouch + 1;
            end
            if (firstTouch==0)    
                firstTouchTime=toc(globalCount)*rate;
                firstTouch=1;  
            end
                
        end
        

        if (length(inds)> 1 && l > 2)
            tex = text(0, -100, str1);
            tex1 = text(0, -60, str2);
        end
        
        space={' '};
        
        str3 = strcat('Distance performed by the male: ', space, num2str(distanceMale), space, ' pixels');
        str4 = strcat('Distance performed by the female: ', space, num2str(distanceFemale), space, ' pixels');
        str6 = strcat('Number of touches: ', space, num2str(nrTouch));

    if (firstTouchTime == 0)
        str5 = strcat('Time spent until the 1st couple (or touch) occurs: ', space, num2str(totalTime), space, 'seconds');
    else
       str5 = strcat('Time spent until the 1st couple (or touch) occurs: ', space, num2str(firstTouchTime), space, 'seconds');  
    end
    
    for j=1:nrCouples
        if coupleDurations(nrCouples+1) > 0
            strAux = strcat('Couple number', space, num2str(j), space, 'lasted', space, num2str(coupleDurations(nrCouples+1)-60),space, 'seconds');
            text (0 , 500 + j*40, strAux);
        end
    end
    
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
        
        
        x(length(x)+1) = i;
        y(length(y)+1) = distance; 
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
    
        totalTime = totalTime + toc(countTime)*rate;
        
        uicontrol('Style','pushbutton','String','Fast Forward','Callback',@faster,'Position',[10 5 90 30]);
        uicontrol('Style','pushbutton','String','Normal Speed','Callback',@normalSpeed,'Position',[100 5 90 30]);
        
        i = i + rate;
        end
end




   
   
    