function DirectFourierRecon(imageFile, Ntheta)

I = im2double(imread(imageFile));
 
thetaDegree = 180/Ntheta; %(180/NumberOfTheta = degree; e.g. Ntheta = 6 -> 30degree)
theta = linspace(0,Ntheta-1,Ntheta); % angles of radon to be calculated

rt = radon(I,theta); % radon T using rtSpace angles;
[rtSize, rtTheta] = size(rt); % get the dimension
nextPowerOf2 = 2^nextpow2(rtSize); % find the next power of two for 0 padding

%zeropad rt
start = ceil((nextPowerOf2-rtSize)/2);
ends = nextPowerOf2-start;
rtZP = zeros(nextPowerOf2,rtTheta);
rtZP(start:ends,:)=rt(:,:);% copy original rt into zeropadded matrix
%fourier transform 

RTzpShift = ifftshift(fft(fftshift(rtZP)));
%Fourier axis
RTsize = size(RTzpShift,1);
d_omega = 2*pi/(RTsize);
t = [0:(RTsize/2-1),(-RTsize/2):-1] * (d_omega); %???
t = fftshift(t); % fourier transform t to frequency domain

%label elements in the matrix RTzpShift with the corresponding theta and t
[THETA, T]=meshgrid(theta, t);

%define the matrix coordinates
%center at 0
x = linspace(-RTsize/2,RTsize/2,RTsize);
t_x = x * (2*pi/RTsize);
y = linspace(-RTsize/2,RTsize/2,RTsize);
t_y = y * (2*pi/RTsize);

[T_X, T_Y] = meshgrid(t_x,t_y);
[THETAp, Tp] = cart2pol(T_X,T_Y);
Tp = Tp.*sign(THETAp);
THETAp = mod(THETAp * (180/pi),180);


RT2D = interp2(THETA, T, RTzpShift,THETAp,Tp,'linear',0);

Final_image=flipud(ifftshift(ifft2(fftshift(RT2D))));
imshow(real(Final_image));
