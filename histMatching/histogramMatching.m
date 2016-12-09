function [ImageOut,hist]=histogramMatching(ImageToMod,ImageTarget)
    %load images
    Is = imread(ImageToMod);
    It = imread(ImageTarget);
   
    ItrCdf=HistCdfLayer(It,1);
    ItgCdf=HistCdfLayer(It,2);
    ItbCdf=HistCdfLayer(It,3);
    [IsrEQ, ~]=HistEqual(Is,1,HistCdfLayer(Is,1));
    [IsgEQ, ~]=HistEqual(Is,2,HistCdfLayer(Is,2));
    [IsbEQ, ~]=HistEqual(Is,3,HistCdfLayer(Is,3));
    IsEQ = im2double(cat(3,IsrEQ,IsgEQ,IsbEQ));
    
    
    [RnonEQ, ~]= histMatch(Is(:,:,1),ItrCdf);
    [GnonEQ, ~]= histMatch(Is(:,:,2),ItgCdf);
    [BnonEQ, ~]= histMatch(Is(:,:,3),ItbCdf);
    FnonEQ = im2double(cat(3,RnonEQ,GnonEQ,BnonEQ));
    
    [RFinal, ~]= histMatch(IsrEQ,ItrCdf);
    [GFinal, ~]= histMatch(IsgEQ,ItgCdf);
    [BFinal, ~]= histMatch(IsbEQ,ItgCdf);
    IFinal = im2double(cat(3,RFinal,GFinal,BFinal));
    
    subplot(541);imshow(Is);
    subplot(542);imhist(Is(:,:,1),32);
    subplot(543);imhist(Is(:,:,2),32);
    subplot(544);imhist(Is(:,:,3),32);
    
    subplot(545);imshow(IsEQ);
    subplot(546);imhist(IsEQ(:,:,1),32);
    subplot(547);imhist(IsEQ(:,:,1),32);
    subplot(548);imhist(IsEQ(:,:,1),32);
    
    subplot(549);imshow(FnonEQ);
    subplot(5,4,10);imhist(FnonEQ(:,:,1),32);
    subplot(5,4,11);imhist(FnonEQ(:,:,2),32);
    subplot(5,4,12);imhist(FnonEQ(:,:,3),32);
    
    subplot(5,4,13);imshow(IFinal);
    subplot(5,4,14);imhist(IFinal(:,:,1),32);
    subplot(5,4,15);imhist(IFinal(:,:,2),32);
    subplot(5,4,16);imhist(IFinal(:,:,3),32);
    
    subplot(5,4,17);imshow(It);
    subplot(5,4,18);imhist(It(:,:,1),32);
    subplot(5,4,19);imhist(It(:,:,2),32);
    subplot(5,4,20);imhist(It(:,:,3),32);
    
    Image = cat(3,IsrEQ,IsgEQ,IsbEQ);
    %imshow(im2double(Image));
  
    
    
    function [imageMod,histeq] = HistEqual(image,layer,cdf)
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
    
    function [ImageFinalLayer, newHist] = histMatch(imageEQ,cdfTarget)
        ImageFinalLayer = zeros(size(imageEQ,1),size(imageEQ,2),'uint8');
        for i=1:size(imageEQ,1)
            for j=1:size(imageEQ,2)
                ImageFinalLayer(i,j) = round(cdfTarget(imageEQ(i,j)+1)*255);
            end
        end
        newHist = imhist(ImageFinalLayer);
    end
end











