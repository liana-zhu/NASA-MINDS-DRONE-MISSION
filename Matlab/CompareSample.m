clear all; close all; clc;


% Load reference image, and compute surf features
source_image = imread('king_diamond.bmp');
source_image_bw = rgb2gray(source_image);
source_points = detectSURFFeatures(source_image_bw);
[source_features,  source_validPoints] = extractFeatures(source_image_bw,  source_points);

figure; 
imshow(source_image);
hold on; 
plot(source_points.selectStrongest(50));


% Visual 25 SURF features
figure;
subplot(5,5,3); 
title('First 25 Features');

for i = 1:25
    scale = source_points(i).Scale;
    image = imcrop(source_image, [source_points(i).Location - 10 * scale 20 * scale 20 * scale]);
    subplot(5,5,i);
    imshow(image);
    hold on;
    rectangle('Position', [5 * scale 5 * scale 10 * scale 10 * scale], 'Curvature', 1, 'EdgeColor', 'g');
end


% Compare to video frame
image = imread('holding_king_diamond.png');
I = rgb2gray(image);


% Detect features
I_pts = detectSURFFeatures(I);
[I_features, I_validPts] = extractFeatures(I, I_pts);
figure;
imshow(image);
hold on; 
plot(I_pts.selectStrongest(50));


% Compare card image to video frame
index_pairs = matchFeatures(source_features, I_features);

ref_matched_pts = source_validPoints(index_pairs(:, 1)).Location;
I_matched_pts = I_validPts(index_pairs(:, 2)).Location;

figure;
showMatchedFeatures(image, source_image, I_matched_pts, ref_matched_pts, 'montage');
title('Showing all matches');


% Define Geometric Transformation Objects
gte = vision.GeometricTransformEstimator; 
gte.Method = 'Random Sample Consensus (RANSAC)';

[tform_matrix, inlierIdx] = step(gte, ref_matched_pts, I_matched_pts);

ref_inlier_pts = ref_matched_pts(inlierIdx, :);
I_inlier_pts = I_matched_pts(inlierIdx, :);


% Draw the lines to matched points
figure;
showMatchedFeatures(image, source_image, I_inlier_pts, ref_inlier_pts, 'montage');
title('Showing match only with Inliers');


% Transform the corner points 
% This will show where the object is located in the image

tform = maketform('affine', double(tform_matrix));
[width, height, ~] = size(source_image);
corners = [0,0; height,0; height,width; 0,width];
new_corners = tformfwd(tform, corners(:, 1),corners(:, 2));
figure;
imshow(image);
patch(new_corners(:,1), new_corners(:,2), [0 1 0], 'FaceAlpha', 0.5);
