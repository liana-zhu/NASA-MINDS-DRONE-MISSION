%% Import images
load template;
load yield;

frame = yield;
imshowpair(templateYield,frame,'montage'); 
title('Compare Template vs Image');

templateMatch = vision.TemplateMatcher;

% Convert images to grayscale
yieldTemplate = rgb2gray(templateYield);
grayFrame = rgb2gray(frame);

tic
yieldLocation = step(templateMatch,grayFrame,yieldTemplate);  
toc

% insert text to the image
frame = insertShape(frame,'FilledRectangle',[yieldLocation 30 15]);
textInsert = vision.TextInserter('Location',yieldLocation,'Text','Yield');
frame = step(textInsert,frame);
frame = insertMarker(frame,yieldLocation);
figure; 
imshow(frame); 
title('Detected Yield Sign');

% Import images
load template;
load yield;

frame = yield;
imshowpair(templateYield,frame,'montage'); 
title('Compare Template vs Image');

templateMatch = vision.TemplateMatcher('ROIInput',true,'BestMatch',true);

% Convert image to hsv
yieldHSV = rgb2hsv(frame);
blobObject = vision.BlobAnalysis;
object = thresholdImage(yieldHSV);
object = imopen(object,strel('disk',1));
object = imclose(object,strel('octagon',9));
[area,centroid,bbox]= step(blobObject,object);
count = length(area);
if count~=0 
    % Find bounding box
    [amax,aidx] = max(area);
    mbbox = bbox(aidx,:);
    yieldTemplate = rgb2gray(templateYield);
    grayFrame = rgb2gray(frame);

    tic
    yieldLocation = step(templateMatch,grayFrame,yieldTemplate,mbbox);  
    toc

    frame = insertShape(frame,'FilledRectangle',[yieldLocation 30 15]);
    textInsert = vision.TextInserter('Location',yieldLocation,'Text','Yield');
    frame = step(textInsert,frame);
    frame = insertMarker(frame,yieldLocation);
    figure; imshow(frame); 
    title('Detected Yield Sign');
end

% Import images
load template;

% Convert template images to hsv
templateStopH = rgb2hsv(templateStopH);
templateYieldH = rgb2hsv(templateYield);
templateEnterH = rgb2hsv(templateEnter);

templateStopMask = double(thresholdImage(templateStopH));
yieldTemplate = double(thresholdImage(templateYieldH));
templateEnterMask = double(thresholdImage(templateEnterH));

fileReader = vision.VideoFileReader('vipwarnsigns.avi');
videoPlayer = vision.DeployableVideoPlayer('Location',[100 100],'Name','Traffic Sign Recognition');
templateMatch = vision.TemplateMatcher('ROIInput',true,'BestMatch',true);
index = 0;
while(~isDone(fileReader)) 
    index = index + 1;
    frame = step(fileReader);
    yieldHSV = rgb2hsv(frame);
    blobObject = vision.BlobAnalysis;
    object = thresholdImage(yieldHSV);
    object = imopen(object,strel('disk',1));
    object = imclose(object,strel('octagon',9));
    [area,centroid,bbox]= step(blobObject,object);
    count = length(area);
    if count~=0 
        [amax,aidx] = max(area);
        mbbox = bbox(aidx,:);    
        frameHsv = rgb2hsv(frame);
        frameBm = double(thresholdImage(frameHsv));
        [locStop,nvalStop,nvalidStop] = step(templateMatch,frameBm,templateStopMask,mbbox);
        [yieldLocation,nvalYield,nvalidYield] = step(templateMatch,frameBm,yieldTemplate,mbbox); 
        [locEnter,nvalEnter,nvalidEnter] = step(templateMatch,frameBm,templateEnterMask,mbbox);
        nvalMeanStop = mean(nvalStop(:));
        nvalMeanYield = mean(nvalYield(:));
        nvalMeanEnter = mean(nvalEnter(:));
        
        signFound = false;
        if nvalidStop~=0 && nvalMeanStop<300
            location = locStop;
            text = 'Stop';
            signFound = true;
        end
        if nvalidYield~=0 && nvalMeanYield<800
            location = yieldLocation;
            text = 'Yield';
            signFound = true;
        end
        if nvalidEnter~=0 && nvalMeanEnter<500
            location = locEnter;
            text = 'Do Not Enter';
            signFound = true;
        end
        if signFound
            frame = insertShape(frame,'FilledRectangle',[location 7*length(text) 15]);
            textInsert = vision.TextInserter('Location',location,'Text',text);
            frame = step(textInsert,frame);   
            frame = insertMarker(frame,location);
        end
        step(videoPlayer,frame);
    end
end
release(fileReader);
release(videoPlayer);
