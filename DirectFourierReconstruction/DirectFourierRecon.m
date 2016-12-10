function DirectFourierRecon(imageFile, Ntheta)
I = im2double(imread(imageFile));%load image to double
subplot(231);
imshow(I);

% angles of radon to be calculated
theta = 0:Ntheta;
rt = radon(I,theta); % radon T using rtSpace angles;
[rtSize, rtTheta] = size(rt); % get the dimension
nextPowerOf2 = 2^nextpow2(rtSize); % find the next power of two for 0 padding
%zeropad rt
start = ceil((nextPowerOf2-rtSize)/2);
ends = nextPowerOf2-start;
rtZP = zeros(nextPowerOf2,rtTheta);
rtZP(start:ends,:)=rt(:,:);% copy original rt into zeropadded matrix
subplot(232);
imshow(mat2gray(rtZP));

%fourier transform 
RTzpShift = ifftshift(fft(fftshift(rtZP)));%padded
RTShift = ifftshift(fft(fftshift(rt)));%unpadded
subplot(233);
imshow(mat2gray(log(abs(RTzpShift)+1)));
subplot(234);
imshow(mat2gray(log(abs(RTShift)+1)));

%define the polar coordinates
%center at 0
RTsize = nextPowerOf2;
RTsizeUP = 909;

singleAngle = 2*pi/RTsize;
singleAngleUP = 2*pi/RTsizeUP;

t= -RTsize/2:(RTsize/2-1);
t= t*singleAngle; %all coordinates in radian unit
tUP = (-RTsizeUP)/2:(RTsizeUP/2-1);
tUP = tUP*singleAngleUP;

%label elements in the matrix RTzpShift with the corresponding theta and t
[THETA, T]=meshgrid(theta, t);
[THETAUP, TUP]=meshgrid(theta,tUP);
[T_X, T_Y] = meshgrid(t,t);
[T_XUP,T_YUP]=meshgrid(tUP,tUP);
%I still don't understand meshgrid function. From the research online, I
%know these codes are needed to create the polar system. I understand what
%polar coordinates are and their relation to cartesian coordinates
%I think what this is for creating a meshgrid with all the radian
%coordiates, ranging from - size/2 to size/2
[THETAp, Tp] = cart2pol(T_X,T_Y);%transform carrtesian coord to polar
Tp = Tp.*sign(THETAp); 
THETAp = mod(THETAp*(180/pi),180); % get the angle for 

[THETApUP, TpUP] = cart2pol(T_XUP,T_YUP);%transform carrtesian coord to polar
TpUP = TpUP.*sign(THETApUP); 
THETApUP = mod(THETApUP*(180/pi),180); % get the angle for 
% reference :
% Direct Fourier Tomographic Reconstruction Image-to-Image Filter
% Dominique Zosso, Meritxell Bach Cuadra, Jean-Philippe Thiran 
% August 24, 2007

RT2D = interp2(THETA, T, RTzpShift,THETAp,Tp,'linear',0);
Final_image=flipud(ifftshift(ifft2(fftshift(RT2D))));
subplot(235);
imshow(real(Final_image));

RT2DUP = interp2(THETAUP, TUP, RTShift,THETApUP,TpUP,'linear',0);


Final_imageUP=flipud(ifftshift(ifft2(fftshift(RT2DUP))));

subplot(236);
imshow(real(Final_imageUP));





