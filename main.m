clear
clc

% Source folder for the image data.
sourceFolder = 'SEQ1';
% Run parameters.
diffThreshold = 50;

% Find all images in the specified directory.
% Assume the number of images in a working set is unknown.
% Assume all the .jpg files are part of the dataset. 
cd(sourceFolder);
files = dir('*.jpg');
numImages = numel(files);
cd('..');

% Assume first file contains the background.
bgPath = strcat(sourceFolder, '/', '1.jpg');
bgImage = importdata(bgPath, 'jpg');

% Assume all files have the same resoulution.
[imageWidth, imageHeight, channels] = size(bgImage);

% Open each other file in the SEQ1 folder.
% for iImageNum = 2 : numImages;
    % Substract background; assume camera does not move.
    imgPath = strcat(sourceFolder, '/', '10.jpg');
    image = importdata(imgPath, 'jpg');
    diffImage = uint8(zeros(imageWidth, imageHeight, channels));
    
    diffValues = sum(abs(bgImage - image), 3);
    binaryDiff = zeros(imageWidth, imageHeight);
    for iColumn = 1 : imageWidth
        for iRow = 1 : imageHeight
            if diffValues(iColumn, iRow) >= diffThreshold
                % Foreign object detected.
               diffImage(iColumn, iRow, :) = image(iColumn, iRow, :);
               binaryDiff(iColumn, iRow) = 1;
            end
        end
    end
    
    % Remove noise.
    se = strel('line', 10, 90);
    binaryDiff = imdilate(binaryDiff, se);
    se = strel('line', 10, 90);
    binaryDiff = imdilate(binaryDiff, se);
    
    
    % Split in connected components.
    CC = bwconncomp(binaryDiff);
    display(CC.PixelIdxList);
%     numPixels = cellfun(@numel,CC.PixelIdxList);
%     [biggest,idx] = max(numPixels);
    
    % Plot the center of each component on the image.
    
    % Display the image.
    imshow(binaryDiff);
    
    % Wait a short time.
    pause(0.5);
% end