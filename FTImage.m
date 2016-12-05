function FTcenteredImage = FTImage(FTImage)
nrow = size(FTImage,1);
ncol = size(FTImage,2);

% get magnitude 
magFTimage = zeros(nrow,ncol);
for i = 1:nrow
    for j = 1:ncol
            magFTimage(i,j)=sqrt((real(FTImage(i,j)))^2+(imag(FTImage(i,j)))^2);    
    end
end

%log transformation

for i = 1:nrow
    for j = 1:ncol
        magFTimage(i,j) = log(magFTimage(i,j) + 1);
    end
end

min = 100000;
max = 0;
for i = 1:nrow
    for j = 1:ncol
        if(min>magFTimage(i,j))
            min = magFTimage(i,j);
        end
        if(max<magFTimage(i,j))
            max=magFTimage(i,j);
        end
    end
end

FTcenteredImage = uint8(zeros(nrow, ncol));
for i = 1:nrow
    for j = 1:ncol
        FTcenteredImage(i,j) = (magFTimage(i,j)-min)/(max-min)*255;
    end
end

imshow(FTcenteredImage);