%Q1 load image 
I = zeros(641);
temp = im2double(imread('1.png'));
I(1:640,1:640)=temp;

subplot(241);
imshow(I);

%Q2
%rt at theta 30
rt30 = radon(I,30);
subplot(242);
plot(rt30);

T30 = fftshift(fft(rt30));
T30LA = log(abs(T30)+1);
subplot(243);
plot(T30LA);

iT30 = ifft(ifftshift(T30));
subplot(244);
plot(iT30);

%FT image 
F = ifftshift(fft2(fftshift(I)));
FLA = log(abs(F)+1);
subplot(245);
imshow(mat2gray(FLA));%show FT



for i =-320:320
    for j =-320:320
        polar(i+321,j+321) = cart2pol(i,j);
    end
end
polar = imrotate(polar,90);
Ft30m = zeros(641);
Ft30 = zeros(1,909);
Ft30m(321,321) = F(321,321);
Ft30(455) = F(321,321);
for i=1:641
    for j = 1:641
        if abs(polar(i,j)-pi/6)<0.007|| abs(polar(i,j)-(-5*pi/6))<0.007
            Ft30m(i,j)=F(i,j);
            Ft30(i+134)=F(i,j);
        end
    end
end

interpol = interp1(Ft30,1:1:909);

subplot(246);
plot(log(abs(interpol(interpol~=0))+1));
      
iFt30IP = (ifft(fftshift(interpol)));
iFt30 = (ifft(fftshift(Ft30)));

subplot(247);
plot(real(iFt30));

subplot(248);
plot(real(iFt30IP));









