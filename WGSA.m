%%%%% Copyright 2021.04.05 Beijing %%%%
clc;
clear;
gray = double(imread('lena.jfif'));               %读入初始图,作为初始迭代分布振幅 
Amplitude = imresize(gray,[512,512]);             %适应调制器分辨率，可注释掉
Amplitude = Amplitude./(max(max(Amplitude)));     %归一化
phase = 2*pi*rand(512,512);                  %产生随机相位
g0_Fie = Amplitude.*exp(1i*phase);           %Fienup算法初始复振幅分布
g0_GS = Amplitude.*exp(1i*phase);            %GS算法初始复振幅分布
RMS_GS = zeros(500,1);                       %计算GS算法均方根误差
RMS_Fie = zeros(500,1);                   %计算Fienup算法均方根误差       



%fienup算法,对GS算法加入反馈调节量ger*k;
step_size = 0.1;   %设置反馈参量，范围为[0,1]，step_size=0时为GS算法
for n = 1:500     %设置最大迭代次数 
%    Fienup算法
   G0_Fie = ifft2(ifftshift(g0_Fie));            %逆傅立叶变换到频域
   G0_FieNew = 1*G0_Fie./abs(G0_Fie);           %取相位值,频域作全1幅值约束，相位全息图
   g0_FieNew = fft2(fftshift(G0_FieNew));      %作傅里叶变换返回空域
   g_er=abs(Amplitude) - fftshift(abs(g0_FieNew)./max(max(abs(g0_FieNew))));     %计算误差，确定收敛方向
   RMS_Fie(n)=sqrt(mean2((g_er.^2)));        %计算均方根误差
   g0_Fie=(abs(Amplitude)+g_er*step_size).*(g0_FieNew./abs(g0_FieNew)); %引入反馈调节
  
%  GS算法
   G0_GS = ifft2(ifftshift(g0_GS));          %逆傅立叶变换到频域
   G0_GSNew = 1*G0_GS./abs(G0_GS);          %取相位值,频域作全1幅值约束，相位全息图
   g0_GSNew = fft2(fftshift(G0_GSNew));      %作傅里叶变换返回空域
   g_er=abs(Amplitude)-  fftshift(abs(g0_GSNew)./max(max(abs(g0_GSNew))));              %计算误差
   RMS_GS(n)=sqrt(mean2((g_er.^2)));        %计算均方根误差
   g0_GS=abs(Amplitude).*(g0_GSNew./abs(g0_GSNew)); %引入反馈调节
end

figure(1)
subplot(321);imshow(mat2gray(gray));title('原图');
subplot(323);imshow(mat2gray(abs(G0_FieNew)));title('相位原件分布(Fie)');
subplot(325);imshow(mat2gray(abs(fftshift(g0_FieNew))));title('模拟衍射输出(Fie)');
subplot(322);imshow(mat2gray(abs(gray)));title('原图');
subplot(324);imshow(mat2gray(abs(G0_GSNew)));title('相位原件分布(GS)');
subplot(326);imshow(mat2gray(abs(fftshift(g0_GSNew))));title('模拟衍射输出(GS)');

figure(2)
subplot(121);plot(1:500,RMS_Fie);xlabel('循环次数');ylabel('RMS误差(Fie)');
subplot(122);plot(1:500,RMS_GS);xlabel('循环次数');ylabel('RMS误差(GS)');




