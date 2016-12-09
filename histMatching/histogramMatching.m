function [ImageOut,hist]=histogramMatching(ImageToMod,ImageTarget)
    %load images
    Is = imread(ImageToMod);
    It = imread(ImageTarget);
    %Cdf of all layers
    ItrCdf=HistCdfLayer(It,1);
    ItgCdf=HistCdfLayer(It,2);
    ItbCdf=HistCdfLayer(It,3);
    IsrCdf=HistCdfLayer(Is,1);
    IsgCdf=HistCdfLayer(Is,2);
    IsbCdf=HistCdfLayer(Is,3);
    %Equalized histogram
    [IsrEQ,IsrEQhist]=HistEqual(Is,1,IsrCdf);
    [IsgEQ,IsgEQhist]=HistEqual(Is,2,IsgCdf);
    [IsbEQ,IsbEQhist]=HistEqual(Is,3,IsbCdf);
    IsEQ = im2double(cat(3,IsrEQ,IsgEQ,IsbEQ));
    
    
    RnonEQ= histMatch(Is(:,:,1),IsrCdf,ItrCdf);
    GnonEQ= histMatch(Is(:,:,2),IsgCdf,ItgCdf);
    BnonEQ= histMatch(Is(:,:,3),IsbCdf,ItbCdf);
    FnonEQ = im2double(cat(3,RnonEQ,GnonEQ,BnonEQ));
   
    RFinal= histMatch(IsrEQ,IsrEQhist,ItrCdf);
    GFinal= histMatch(IsgEQ,IsgEQhist,ItgCdf);
    BFinal= histMatch(IsbEQ,IsbEQhist,ItgCdf);
    IFinal = im2double(cat(3,RFinal,GFinal,BFinal));
    
    subplot(541);imshow(Is);
    subplot(542);imhist(Is(:,:,1),64);
    subplot(543);imhist(Is(:,:,2),64);
    subplot(544);imhist(Is(:,:,3),64);
    
    subplot(545);imshow(IsEQ);
    subplot(546);imhist(IsEQ(:,:,1),64);
    subplot(547);imhist(IsEQ(:,:,1),64);
    subplot(548);imhist(IsEQ(:,:,1),64);
    
    subplot(549);imshow(FnonEQ);
    subplot(5,4,10);imhist(FnonEQ(:,:,1),64);
    subplot(5,4,11);imhist(FnonEQ(:,:,2),64);
    subplot(5,4,12);imhist(FnonEQ(:,:,3),64);
    
    subplot(5,4,13);imshow(IFinal);
    subplot(5,4,14);imhist(IFinal(:,:,1),64);
    subplot(5,4,15);imhist(IFinal(:,:,2),64);
    subplot(5,4,16);imhist(IFinal(:,:,3),64);
    
    subplot(5,4,17);imshow(It);
    subplot(5,4,18);imhist(It(:,:,1),64);
    subplot(5,4,19);imhist(It(:,:,2),64);
    subplot(5,4,20);imhist(It(:,:,3),64);
    
    
    
    function [imageMod, newhist] = HistEqual(image,layer,cdf)
        histeq = zeros(1,256);
        for i=1:256
            histeq(i)=round(255*cdf(i));
        end
        imageMod = zeros(size(image,1),size(image,2),'uint8');
        for i=1:size(image,1)
            for j=1:size(image,2);
            imageMod(i,j)=histeq(image(i,j,layer)+1);
            end
        end
        newhist = HistCdfLayer(imageMod,1);
    end
    
    function histCdf = HistCdfLayer(image, layer)
        %get layer
        Layer = image(:,:,layer);
        %get histogram of each layer from target image
        Layerhist = imhist(Layer); 
        %get total pixels
        total = sum(Layerhist);
        %get cdf of each layer
        histCdf = zeros(1,size(Layerhist,1));

        for i=1:size(Layerhist,1)
            if i==1
                histCdf(i)=Layerhist(i,1)/total;
            else
                histCdf(i)=Layerhist(i,1)/total+histCdf(i-1);
            end
        end
    end
    
    function [ImageFinalLayer] = histMatch(image,cdfimage,cdfDesired)
        ImageFinalLayer = zeros(size(image,1),size(image,2),'uint8');
        
        mapping = zeros(256,1);
        for i = 1:256
            for j = mapping(i)+1:256
                if (cdfDesired(j)-cdfimage(i))>=0
                    mapping(i)=j;
                    break;
                end
            end
        end
        
        for i = 1:size(image,1)
            for j= 1:size(image,2)
                ImageFinalLayer(i,j)=mapping(image(i,j)+1);
            end
        end
    end
end 










