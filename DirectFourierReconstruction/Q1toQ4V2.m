%Q1 load image 
I = im2double(imread('1.png'));

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

theta = 0:179;
rt = radon(I,theta);
RT = ifftshift(fft(fftshift(rt)));
RTsize = size(rt,1);
singleAngle = 2*pi/RTsize;

t = (-RTsize)/2:(RTsize/2-1);  %coordinates span the size of polar coord
t = t*singleAngle;%all coordinates in radian unit
%label elements in the matrix RTzpShift with the corresponding theta and t
[THETA, T]=meshgrid(theta,t); %cartesian coord that currently holding F data
[T_X,T_Y]=meshgrid(t,t); % polar coord that will be given to rt data 
[THETAp, Tp] = cart2pol(T_X,T_Y);%transform carrtesian coord to polar
Tp = Tp.*sign(THETAp); %make sure sign is correctly shown for each quadrant
THETAp = mod(THETAp*(180/pi),180); % get theta for each t

RT2D = interp2(THETA, T, F,THETAp,Tp,'linear',0);% interpolate


subplot(246);
plot(log(abs(interpol(interpol~=0))+1));
      
iFt30IP = (ifft(fftshift(interpol)));
iFt30 = (ifft(fftshift(Ft30)));

subplot(247);
plot(real(iFt30));

subplot(248);
plot(real(iFt30IP));









