function ProcessedImage = IFTimage(processedFTimage)

reverseFTimage = real(ifft2(processedFTimage));
nrow = size(reverseFTimage,1);
ncol = size(reverseFTimage,2);

ProcessedImage=uint8(zeros(nrow/2,ncol/2));
for i = 1:nrow/2
    for j = 1:ncol/2
        ProcessedImage(i,j) = reverseFTimage(i,j)*(-1)^(i+j);
    end
end

imshow(ProcessedImage);