%% Train Object
% Load data
load stopSigns
input_data = data;
stopSign = fullfile(matlabroot,'toolbox','vision','visiondata','stopSignImages');
addpath(stopSign);
nonStopSign = fullfile(matlabroot,'toolbox','vision','visiondata','nonStopSigns');
fileDetect = 'signDetect.xml';
% Measure time execute
tic
trainCascadeObjectDetector(fileDetect, ...
                         input_data, nonStopSign,...
                         'False Alarm', 0.1,'Number Stages', 5);
toc

%% Run object detector
% Load test image
load stop_sign
frame = stop_sign;
figure; 
imshow(img);
% Specify xml file
fileDetect = 'signDetect.xml';

detector = vision.CascadeObjectDetector(fileDetect);


boundBox = step(detector, frame);
frame = insertShape(frame,'Rectangle',boundBox);
textLocation = boundBox(1:2)+[0 -15];
frame = insertShape(frame,'FilledRectangle',[textLocation 30 15]);
textInsert = vision.TextInserter('Location',textLocation,'Text','Stop');
frame = step(textInsert,frame);
figure; 
imshow(frame);

%% Run trained detector on video

fileDetect = 'signDetect.xml';
stopSignDetector = vision.CascadeObjectDetector(fileDetect,'MaxSize',[75 75]);
fileReader = vision.VideoFileReader('vipwarnsigns.avi','VideoOutputDataType','uint8');
videoPlayer = vision.DeployableVideoPlayer;
frame = step(fileReader);
step(videoPlayer,frame);
index = 0;
while ~isDone(fileReader)
    index = index + 1;
    frame = step(fileReader);
    boundBox = step(stopSignDetector,frame);
    count = size(boundBox,1);
    if count
        frame = insertShape(frame,'Rectangle',boundBox);
        textLocation = boundBox(1:2)+[0 -15];
        frame = insertShape(frame,'FilledRectangle',[textLocation 30 15]);
        textInsert = vision.TextInserter('Location',textLocation,'Text','Stop');
        frame = step(textInsert,frame);
    end
    step(videoPlayer,frame);
end

%% Testing with larger dataset to remove false rate

load stopSigns
input_data = data;
stopSign = fullfile(matlabroot,'toolbox','vision','visiondata','stopSignImages');
addpath(stopSign);
nonStopSign = fullfile(pwd,'nonStopSignImagesLarge');
fileDetect = 'signDetect1.xml';
% Measure time execute
tic
trainCascadeObjectDetector(fileDetect, ...
                         input_data, nonStopSign,...
                         'FalseAlarmRate', 0.001,'NumCascadeStages', 5);
toc

%% Run object detector on video
fileDetect = 'signDetect1.xml';
stopSignDetector = vision.CascadeObjectDetector(fileDetect,'MaxSize',[75 75]);
fileReader = vision.VideoFileReader('vipwarnsigns.avi','VideoOutputDataType','uint8');
videoPlayer = vision.DeployableVideoPlayer;
index = 0;
while ~isDone(fileReader)
    index = index + 1;
    frame = step(fileReader);
    boundBox = step(stopSignDetector,frame);
    count = size(boundBox,1);
    if count
        frame = insertShape(frame,'Rectangle',boundBox);
        textLocation = boundBox(1:2)+[0 -15];
        frame = insertShape(frame,'FilledRectangle',[textLocation 30 15]);
        textInsert = vision.TextInserter('Location',textLocation,'Text','Stop');
        frame = step(textInsert,frame);
    end
    % View frame
    step(videoPlayer,frame);
end
