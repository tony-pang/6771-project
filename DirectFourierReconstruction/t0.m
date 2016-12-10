%Q1 load image 
I = zeros(641);
temp = im2double(imread('1.png'));
I(1:640,1:640)=temp;

subplot(241);
imshow(I);

%2
%rt at theta 30
rt0 = radon(I,0);
subplot(242);
plot(rt0);

T0 = fftshift(fft(rt0));
subplot(243);
plot(log(abs(T0)+1));

iT0 = ifft(ifftshift(T0));
subplot(244);
plot(iT0);

%FT image 
F = fftshift(fft2(I));
FLA = log(abs(F)+1);
subplot(245);
imshow(mat2gray(FLA));%show FT

Ft0=F(321,:);

subplot(246);
plot(log(abs(Ft0)+1));
      
iFt0 = ifft(ifftshift(Ft0));

subplot(247);
plot(real(iFt0));









