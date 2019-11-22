clear all; close all;
layer1=mat2gray(imread('X256.bmp'));
layer2=mat2gray(imread('H256.bmp'));

layer1=double(layer1);
layer2=double(layer2);

layer1=layer1./max(max(layer1));
layer2=layer2./max(max(layer2));

avg1layer1=mean(mean(layer1));
avg1layer2=mean(mean(layer2));

%figure;imshow(abs(layer1));
%figure;imshow(abs(layer2));

%PH=rand([1024,1024]);
layer1r=layer1;
layer2r=layer2;


d1 = zeros(1024);
d2 = zeros(1024);

f1 = zeros(1024);

for x=1:1024
    for y=1:1024
        d1(x,y)=exp(-1j*0.0001*(x^2+y^2));
    end
end

for x=1:1024
    for y=1:1024
        d2(x,y)=exp(-1j*0.0002*(x^2+y^2));
    end
end





for x=1:1024
    for y=1:1024
        f1(x,y)=exp(1j*0.0001*(x^2+y^2));
    end
end


for n=1:20 %number of iterations to optimise the phase hologram
    layer1H=fftshift(ifft2(fftshift(layer1r))); % ifft back to hologram
    Rlayer1=fftshift(fft2(fftshift(exp(1i.*angle(layer1H)))));
    avg2layer1=mean(mean(abs(Rlayer1)));
    Rlayer1=(Rlayer1./avg2layer1).*avg1layer1;
    layer1r=layer1.*exp(1j*angle(Rlayer1));
end


for n=1:20 %number of iterations to optimise the phase hologram
    layer2H=fftshift(ifft2(fftshift(layer2r))); % ifft back to hologram
    Rlayer2=fftshift(fft2(fftshift(exp(1i.*angle(layer2H)))));
    avg2layer2=mean(mean(abs(Rlayer2)));
    Rlayer2=(Rlayer2./avg2layer2).*avg1layer2;
    layer2r=layer2.*exp(1j*angle(Rlayer2));
end


layer1H=fftshift(ifft2(fftshift(layer1r))).*d1;
Rlayer1=fftshift(fft2(fftshift(exp(1i.*angle(layer1H)))));

layer2H=fftshift(ifft2(fftshift(layer2r))).*d2; 
Rlayer2=fftshift(fft2(fftshift(exp(1i.*angle(layer2H)))));


sub1 = fftshift(fft2(fftshift(f1.*(layer1H))));
sub2 = fftshift(fft2(fftshift(f1.*(layer2H))));

total = abs(sub1)+abs(sub2);

figure;imshow(total);
title('Reconstructed image')



