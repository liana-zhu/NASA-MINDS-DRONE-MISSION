function binaryImage = thresholdImage(I)

channel1Min = 0.962;
channel1Max = 0.026;

channel2Min = 0.000;
channel2Max = 1.000;

channel3Min = 0.006;
channel3Max = 1.001;

% Create mask based on chosen histogram thresholds
binaryImage = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);    