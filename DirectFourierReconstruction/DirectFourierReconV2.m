function DirectFourierReconV2(imageFile, Ntheta)
I = im2double(imread(imageFile));%load image to double
subplot(221);
imshow(I);

% angles of radon to be calculated
theta = 0:Ntheta;
rt = radon(I,theta); % radon T using rtSpace angles;
subplot(222);
imshow(mat2gray(rt));

%fourier transform 
RTShift = ifftshift(fft(fftshift(rt)));
subplot(223);
imshow(mat2gray(log(abs(RTShift)+1)));

%define the polar coordinates
%center at 0
RTsize = size(rt,1);
singleAngle = 2*pi/RTsize; %the difference between each angle, this value 
%depends on the size of the image

t = (-RTsize)/2:(RTsize/2-1);  %coordinates span the size of polar coord
t = t*singleAngle;%all coordinates in radian unit

%label elements in the matrix RTzpShift with the corresponding theta and t
[THETA, T]=meshgrid(theta,t); %cartesian coord that currently holding rt data
[T_X,T_Y]=meshgrid(t,t); % polar coord that will be given to rt data 
%I still don't understand meshgrid function. From the research online, I
%know these codes are needed to create the polar system. I understand what
%polar coordinates are and their relation to cartesian coordinates
%I think what this is for creating a meshgrid with all the radian
%coordiates, ranging from - size/2 to size/2

[THETAp, Tp] = cart2pol(T_X,T_Y);%transform carrtesian coord to polar
Tp = Tp.*sign(THETAp); %make sure sign is correctly shown for each quadrant
THETAp = mod(THETAp*(180/pi),180); % get theta for each t
% reference :
% Direct Fourier Tomographic Reconstruction Image-to-Image Filter
% Dominique Zosso, Meritxell Bach Cuadra, Jean-Philippe Thiran 
% August 24, 2007

RT2D = interp2(THETA, T, RTShift,THETAp,Tp,'linear',0);% interpolate
%all point unable to match are given value 0;

Final_image=flipud(ifftshift(ifft2(fftshift(RT2D))));
% image is fliped due to the matlab assign y axis pointing downward.
Final_image=Final_image(135:775,135:775);%crop the image
subplot(224);
imshow(real(Final_image));





