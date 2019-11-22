clear all; close all;

RGB=imread('bridge.jpg','jpg');
I=rgb2gray(RGB);
I=double(I);
I=I./max(max(I));
avg1=mean(mean(I));
figure;imshow(mat2gray(I));
%rgb2gray converts RGB image to 8-bits bitmap
%mat2gray coverts to grayscale [0,1]
%imwrite(I,'graybridge.bmp')
%figure;imshow(abs(I));
title('Original Image');
figure;
N=20;  %number of iterations to optimise the phase hologram
rmse = zeros (N,1);
n = zeros (N,1);
axis([0,N+1,0,1]);
xlabel('Number of iterations')
ylabel('RMSE')
hold on; 
PH=rand([1024,1024]); % 1024*2014 random phase matrix
I1=I;
I3=I.*exp(1i*2*pi*PH);
for k=1:N
    H=fftshift(ifft2(fftshift(I1))); % ifft back to hologram
    I2=fftshift(fft2(fftshift(exp(1i.*angle(H)))));
    avg2=mean(mean(abs(I2)));
    I2=(I2./avg2).*avg1;
    rmse(k,1)=(mean(mean((abs(I2)-I).^2)))^0.5;
    n(k,1)=k;
    I1=I.*exp(1j*angle(I2));
end
plot(n,rmse,'Color',[0.8500 0.3250 0.0980]); 
hold on; 
for k=1:N
    H=fftshift(ifft2(fftshift(I3))); % ifft back to hologram
    I2=fftshift(fft2(fftshift(exp(1i.*angle(H)))));
    avg2=mean(mean(abs(I2)));
    I2=(I2./avg2).*avg1;
    rmse(k,1)=(mean(mean((abs(I2)-I).^2)))^0.5;
    n(k,1)=k;
    I3=I.*exp(1j*angle(I2));
end


plot(n,rmse,'Color',[0 0.4470 0.7410]);      %[0.8500 0.3250 0.0980] [0 0.4470 0.7410]
I2=I2./max(max(abs(I2)));
figure;imshow(abs(I2));
title('Reconstructed image')
figure;imshow(mat2gray(angle(H)));
title('Hologram')
 