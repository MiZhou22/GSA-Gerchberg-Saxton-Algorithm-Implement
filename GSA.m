clc; clear all; close all;
% based on franuhofer diffraction

img = im2double((imread("lena.jpg")));
img_a = sqrt(img);
disp(class(img));
disp(size(img));
 
% 从slm平面开始
slm_a = 1;
slm_p = rand()*2*pi;
slm_c = img_a.*exp(1i*slm_p);

tic
for i = 1:1000
    % In the image plane, we use the target amplitude
    img_c = fft2(slm_c);
    img_c = img_c./abs(img_c).*img_a; 
    
    % In the slm plane, we use constant amplitude 1 (or gaussian beam
    % amplitude)
    slm_c = ifft2(img_c);
    slm_c = slm_c./abs(slm_c);
    
%     % show the orignal target image intensity and its frequency domain
%     figure(1);
%     subplot(2, 3, 1);
%     imshow(img);
%     title("目标图像");
%     subplot(2, 3, 2);
%     imshow(log(1+abs(fftshift(fft2(img)))), []);
%     title("目标图像幅频");
%     subplot(2, 3, 3);
%     imshow(angle(fftshift(fft2(img))));
%     title("目标图像相频");
% 
%     % show the reconstruction image intensity and its frequency domain
%     subplot(2, 3, 4);
    reconstruction = power(abs(fft2(slm_c)), 2);
%     imshow(reconstruction./max(max(reconstruction)));
%     title("重建图像");
%     subplot(2, 3, 5);
%     imshow(log(1+abs(fftshift(fft2(reconstruction)))), []);
%     title("重建图像幅频");
%     subplot(2, 3, 6);
%     imshow(angle(fftshift(fft2(reconstruction))));
%     title("重建图像相频");
    
    % SSIM > 0.95, then exit the iteration
    if(ssim(img, reconstruction./max(max(reconstruction))) > 0.9995)
       disp("Iteration:"+i);
       break; 
    end
end

% show the orignal target image intensity and its frequency domain
figure(1);
subplot(2, 3, 1);
imshow(img);
title("目标图像");
subplot(2, 3, 2);
imshow(log(1+abs(fftshift(fft2(img)))), []);
title("目标图像幅频");
subplot(2, 3, 3);
imshow(angle(fftshift(fft2(img))));
title("目标图像相频");

% show the reconstruction image intensity and its frequency domain
subplot(2, 3, 4);
reconstruction = power(abs(fft2(slm_c)), 2);
imshow(reconstruction./max(max(reconstruction)));
title("重建图像");
subplot(2, 3, 5);
imshow(log(1+abs(fftshift(fft2(reconstruction)))), []);
title("重建图像幅频");
subplot(2, 3, 6);
imshow(angle(fftshift(fft2(reconstruction))));
title("重建图像相频");

disp(ssim(img, reconstruction./max(max(reconstruction))));
toc



