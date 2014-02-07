function [diffImage, binaryDiffImage] = sub_background(image1, image2, ...
                                            diffThreshold)
    %Given two images and a threshold, this function attempts to subtract 
    %common pixels from both images, returning the difference image in RGB 
    %format and in binary format.
    %
    %image1 is usually a background image and image2 is the one containing
    %objects you are after.
    %
    %Both images must be of the same size.
   
    %Find image dimensions
    [height, width, depth] = size(image1);
    
    %Find the difference in values between the two images
    diffValues = sum(abs(image1 - image2), 3);
    
	%Matrix to hold resulting background subtracted image
    diffImage = uint8(zeros(height, width, 3));
    binaryDiffImage = zeros(height, width);
    
    %Populate difference matrices
    for iColumn = 1 : width
        for iRow = 1 : height
            
            %If value greater than threshold, that means a non-background
            %object was detected.
            if diffValues(iRow, iColumn) >= diffThreshold
               %Store results in both unit8 format and binary format
               diffImage(iRow, iColumn, :) = ...
                    image2(iRow, iColumn, :);
               binaryDiffImage(iRow, iColumn) = 1;
            end
        end
    end  
end