function result_image = adjustBrightness(image, beta)
%ADJUSTBRIGHTNESS Adjust brightness of a given rgb image according to
%chosen beta parameter

    double_image = double(image);
    
    %Initialize matrix that will transform our image
    result_image = uint8(double_image + beta);
end