clear;clc;close all;
% ����ȥ�����
kenlRatio = .01;                % ��С���˲�ʱ�õĴ���ռ����ͼƬ�ı���
maxAtomsLight = 200;        % �޶����ȫ�ֹ�
% dehaze_weight = 0.9;        % ȥ��Ȩ��
image_name =  'D:/Projects/Dehaze/���ݼ���/HSTS/synthetic/synthetic/0586.jpg';
img=imread(image_name);
subplot(1,2,1);imshow(uint8(img)), title('src');
% ��ȡͼ����
sz=size(img);
w=sz(2);
h=sz(1);

% ��ȡ��ͨ��
% ��ͨ����һ������ȡ��С��RGB�����õ���ͨ��ͼ 
dc = zeros(h,w);
for y=1:h
    for x=1:w
        dc(y,x) = min(img(y,x,:));
    end
end
% subplot(2,4,2);imshow(uint8(dc)), title('Min(R,G,B)');
% ��ͨ���ڶ�������С�������˲�
% �����˲�����
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]));
dc2 = minfilt2(dc, [krnlsz,krnlsz]);
dc2(h,w)=0;     % �˲������һ����λû���ˣ������ֶ����� 
% subplot(2,4,3);imshow(uint8(dc2)), title('After filter : Dark Channel');

% ���ƴ����⣨��ԭ�������е㲻һ����
A = min([maxAtomsLight, max(max(dc2))]);
% �õ�͸��ͼ
t = 255 - dc2;
% subplot(2,4,4);imshow(uint8(t)),title('transsimion map');
t_d=double(t)/255;

% �������t���õ��ˣ�����ԭͼ
% J = zeros(h,w,3);
img_d = double(img);
% J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
% J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
% J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
% subplot(2,4,5);imshow(uint8(J)), title('J: dehazed image');

% ���뵼���˲����õ�����ϸ��͸��ͼ
r = krnlsz*4;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
t_d = filtered;
% subplot(2,4,6);imshow(t_d,[]),title('filtered t');

% �����µ�͸��ͼ���õ�ȥ��ͼ
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
subplot(1,2,2);imshow(uint8(J)), title('J : Dehaze Image, after guilded filter');
% д��ȥ��Ч��ͼ
% imwrite
