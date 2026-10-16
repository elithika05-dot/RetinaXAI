















































































clc;
clear;
close all;

%% RETINAXAI - Explainable AI Screening

% Load trained model
load('/MATLAB Drive/RETINAXAI/trainedNetFinal.mat');

%% Select retinal image

[file,path] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png','Retinal Images'}, ...
    'Select Retinal Fundus Image');

if isequal(file,0)
    disp('No image selected.');
    return;
end

%% Prepare image

img = imread(fullfile(path,file));
img = imresize(img,[224 224]);

if size(img,3) == 1
    img = repmat(img,1,1,3);
end

%% AI prediction

[predictedLabel,scores] = classify(trainedNetFinal,img);

confidence = max(scores)*100;

% Convert MATLAB class 1-5 to DR grade 0-4
grade = double(predictedLabel)-1;

%% Severity

severityNames = { ...
    'No DR', ...
    'Mild DR', ...
    'Moderate DR', ...
    'Severe DR', ...
    'Proliferative DR'};

severity = severityNames{grade+1};

%% Referable screening

if grade >= 2
    referral = 'REFERABLE';
else
    referral = 'NON-REFERABLE';
end

%% Image quality

grayImg = im2gray(img);

brightnessValue = mean(grayImg(:));
contrastValue = std2(grayImg);

if contrastValue < 25
    qualityStatus = 'LOW';
elseif brightnessValue < 30 || brightnessValue > 225
    qualityStatus = 'LOW';
else
    qualityStatus = 'ACCEPTABLE';
end

%% Grad-CAM

scoreMap = gradCAM( ...
    trainedNetFinal, ...
    img, ...
    predictedLabel);

%% Report window

reportFig = uifigure( ...
    'Name','RETINAXAI - AI Screening Report', ...
    'Position',[80 40 1250 800]);

%% Header

uilabel(reportFig, ...
    'Text','RETINAXAI', ...
    'FontSize',30, ...
    'FontWeight','bold', ...
    'HorizontalAlignment','center', ...
    'Position',[450 745 350 40]);

uilabel(reportFig, ...
    'Text','Explainable AI for Diabetic Retinopathy Screening', ...
    'FontSize',16, ...
    'HorizontalAlignment','center', ...
    'Position',[350 715 550 30]);

%% Images

ax1 = uiaxes(reportFig, ...
    'Position',[40 425 500 270]);

imshow(img,'Parent',ax1);
title(ax1,'Original Retinal Fundus Image');
axis(ax1,'image');

ax2 = uiaxes(reportFig, ...
    'Position',[700 425 500 270]);

imshow(img,'Parent',ax2);
hold(ax2,'on');

imagesc(ax2,scoreMap,'AlphaData',0.5);
colormap(ax2,'jet');
colorbar(ax2);

title(ax2,'Grad-CAM Explanation');
axis(ax2,'image');

hold(ax2,'off');

%% AI RESULT TITLE

uilabel(reportFig, ...
    'Text','AI SCREENING RESULT', ...
    'FontSize',16, ...
    'FontWeight','bold', ...
    'Position',[40 375 300 30]);

%% Grade

uilabel(reportFig, ...
    'Text',sprintf('Predicted DR Grade: %d',grade), ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'Position',[40 335 300 30]);

%% Severity

uilabel(reportFig, ...
    'Text',['Severity: ' severity], ...
    'FontSize',15, ...
    'Position',[40 300 400 25]);

%% Confidence

uilabel(reportFig, ...
    'Text',sprintf('AI Confidence: %.2f%%',confidence), ...
    'FontSize',15, ...
    'Position',[40 265 350 25]);

%% Referral

uilabel(reportFig, ...
    'Text',['Screening Category: ' referral], ...
    'FontSize',16, ...
    'FontWeight','bold', ...
    'Position',[40 225 500 30]);

%% Image Quality Title

uilabel(reportFig, ...
    'Text','IMAGE QUALITY ASSESSMENT', ...
    'FontSize',16, ...
    'FontWeight','bold', ...
    'Position',[650 375 350 30]);

%% Brightness

uilabel(reportFig, ...
    'Text',sprintf('Brightness: %.2f',brightnessValue), ...
    'FontSize',14, ...
    'Position',[650 335 300 25]);

%% Contrast

uilabel(reportFig, ...
    'Text',sprintf('Contrast: %.2f',contrastValue), ...
    'FontSize',14, ...
    'Position',[650 300 300 25]);

%% Quality status

uilabel(reportFig, ...
    'Text',['Quality Status: ' qualityStatus], ...
    'FontSize',15, ...
    'FontWeight','bold', ...
    'Position',[650 265 350 25]);

%% Explanation

uilabel(reportFig, ...
    'Text','MODEL EXPLANATION', ...
    'FontSize',16, ...
    'FontWeight','bold', ...
    'Position',[650 225 300 30]);

uilabel(reportFig, ...
    'Text','Highlighted regions indicate image areas', ...
    'FontSize',13, ...
    'Position',[650 190 400 25]);

uilabel(reportFig, ...
    'Text','that influenced the AI prediction.', ...
    'FontSize',13, ...
    'Position',[650 165 400 25]);

%% Disclaimer

uilabel(reportFig, ...
    'Text','AI screening prototype - not a medical diagnosis.', ...
    'FontSize',12, ...
    'Position',[40 85 500 25]);

uilabel(reportFig, ...
    'Text','Final clinical decision should be made by a qualified ophthalmologist.', ...
    'FontSize',12, ...
    'Position',[40 60 700 25]);

%% Footer

uilabel(reportFig, ...
    'Text','RETINAXAI | Explainable AI Screening', ...
    'FontSize',11, ...
    'Position',[950 60 250 25]);

disp('RETINAXAI report generated successfully.');