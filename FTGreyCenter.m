function FTImage =  FTGreyCenter(imageFile)
rawImage = imread(imageFile);
if(ndims(rawImage)==3)
    grayImage = rgb2gray(rawImage);
else
    grayImage = rawImage;
end

%pad the image with 0s , size 2N x 2N
nrow = size(grayImage, 1);
ncol = size(grayImage, 2);
paddedImage = zeros(nrow*2 , ncol*2);
for i=1:nrow
    for j=1:ncol
        paddedImage(i,j) = grayImage(i,j);
    end
end

%center FT 
centerGrayImage = zeros(nrow*2,ncol*2);
for i=1:nrow
    for j = 1:ncol
        centerGrayImage(i,j) = paddedImage(i,j)*(-1)^(i+j);
    end
end
%DFT
FTImage=fft2(centerGrayImage);









