function DirectFourierReconV2(imageFile, Ntheta)
I = im2double(imread(imageFile));%load image to double
subplot(231);
imshow(I);

% angles of radon to be calculated
theta = 0:Ntheta;
rt = radon(I,theta); % radon T using theta angles;
subplot(232);
imshow(mat2gray(rt));

%fourier transform 
RTShift = ifftshift(fft(fftshift(rt)));
subplot(233);
imshow(mat2gray(log(abs(RTShift)+1)));
subplot(234);
imshow(mat2gray(log(abs(ifftshift(fft2(fftshift(I))))+1)));

%define the polar coordinates
%center at 0
RTsize = size(rt,1);
singleAngle = 2*pi/RTsize; %the difference between each angle, this value 
%depends on the size of the image

t = (-RTsize)/2:(RTsize/2-1);  %coordinates span the size of polar coord
t = t*singleAngle;%all coordinates in radian unit

%label elements in the matrix RTShift with the corresponding theta and t
[THETA, T]=meshgrid(theta,t); %cartesian coord that currently holding rt data
[T_X,T_Y]=meshgrid(t,t); % polar coord that will be given to rt data 
%creating a meshgrid with all the radian coordinates, ranging from - size/2 to size/2
[THETAp, Tp] = cart2pol(T_X,T_Y);%transform cartesian coord to polar
Tp = Tp.*sign(THETAp); %make sure sign is correctly shown for each quadrant
THETAp = mod(THETAp*(180/pi),180); % get theta for each t 
% reference :
% Direct Fourier Tomographic Reconstruction Image-to-Image Filter
% Dominique Zosso, Meritxell Bach Cuadra, Jean-Philippe Thiran 
% August 24, 2007

RT2D = interp2(THETA, T, RTShift,THETAp,Tp,'linear',0);% interpolate
%all point unable to match are given value 0;
subplot(235)
imshow(mat2gray(log(abs(RT2D)+1)));
Final_image=flipud(ifftshift(ifft2(fftshift(RT2D))));
% image is fliped due to the matlab assign y axis pointing downward.
Final_image=Final_image(135:775,135:775);%crop the image
subplot(236);
imshow(real(Final_image));





