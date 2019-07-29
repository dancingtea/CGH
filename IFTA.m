clear all; close all;
RGB=imread('bridge.jpg');
I=mat2gray(rgb2gray(RGB));
%rgb2gray converts RGB image to 8-bits bitmap
%mat2gray coverts to grayscale [0,1]
I=double(I);
imwrite(I,'graybridge.bmp')
figure;imshow(abs(I));
title('Original Image');
figure;
axis([0,101,0,1]);
xlabel('Number of Iterations')
ylabel('RMSE')
hold on
PH=rand([1024,1024]); % 1024*2014 random phase matrix
I1=I.*exp(1i*2*pi*PH);
for n=1:100 %number of iterations to optimise the phase hologram
    H=fftshift(ifft2(fftshift(I1))); % ifft back to hologram
    I2=fftshift(fft2(fftshift(exp(1i.*angle(H)))));
    rmse=(mean(mean((mat2gray(abs(I2))-I))).^2)^0.5;
    plot(n,rmse,'*',Linespace);
    pause(0.1)
    I1=I.*exp(1j*angle(I2));
end
hold off
figure;imshow(mat2gray(abs(I2)));
title('Reconstructed Image') 
   

