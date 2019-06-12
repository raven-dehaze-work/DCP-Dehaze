clear;clc;close all;
% 定义去雾参数
kenlRatio = .01;                % 最小化滤波时用的窗口占整幅图片的比例
maxAtomsLight = 200;        % 限定最大全局光
% dehaze_weight = 0.9;        % 去雾权重
image_name =  'D:/Projects/Dehaze/数据集合/HSTS/synthetic/synthetic/0586.jpg';
img=imread(image_name);
subplot(1,2,1);imshow(uint8(img)), title('src');
% 获取图像宽高
sz=size(img);
w=sz(2);
h=sz(1);

% 获取暗通道
% 暗通道第一步：获取最小化RGB分量得到的通道图 
dc = zeros(h,w);
for y=1:h
    for x=1:w
        dc(y,x) = min(img(y,x,:));
    end
end
% subplot(2,4,2);imshow(uint8(dc)), title('Min(R,G,B)');
% 暗通道第二补：最小化窗口滤波
% 定义滤波窗口
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]));
dc2 = minfilt2(dc, [krnlsz,krnlsz]);
dc2(h,w)=0;     % 滤波后，最后一个单位没有了，这里手动补齐 
% subplot(2,4,3);imshow(uint8(dc2)), title('After filter : Dark Channel');

% 估计大气光（和原论文中有点不一样）
A = min([maxAtomsLight, max(max(dc2))]);
% 得到透射图
t = 255 - dc2;
% subplot(2,4,4);imshow(uint8(t)),title('transsimion map');
t_d=double(t)/255;

% 大气光和t都得到了，反推原图
% J = zeros(h,w,3);
img_d = double(img);
% J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
% J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
% J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
% subplot(2,4,5);imshow(uint8(J)), title('J: dehazed image');

% 加入导向滤波，得到更精细的透射图
r = krnlsz*4;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
t_d = filtered;
% subplot(2,4,6);imshow(t_d,[]),title('filtered t');

% 根据新的透射图，得到去雾图
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
subplot(1,2,2);imshow(uint8(J)), title('J : Dehaze Image, after guilded filter');
% 写入去雾效果图
% imwrite
