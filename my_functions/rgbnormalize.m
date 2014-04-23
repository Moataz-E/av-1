function output = rgbnormalize(image_uint)
%RGBNORMALIZE Given an image, this function returns the an rgb normalized 
%version of the image.
 
   image = double(image_uint);
   [H,W,D] = size(image);
   
   %Temporary holder initialized to zeros
   temp = zeros(H,W,D);
   
   %Loop going through every pixel in the image
   for i=1:H
       for j=1:W
           
           %Find average of all colours for
           %that pixel
           csum = image(i,j,1) + image(i,j,2) + image(i,j,3);
           
           temp(i,j,1) = (image(i,j,1) / csum);
           temp(i,j,2) = (image(i,j,2) / csum);
           temp(i,j,3) = (image(i,j,3) / csum);
       end
   end
   output = uint8(temp .* 255);
end