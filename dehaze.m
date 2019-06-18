function y = dehaze(haze_img)
% 去雾函数: 根据输入雾图矩阵进行去雾，返回去雾后的图片矩阵
%   haze_img: 雾图矩阵
%   y:         去雾后的矩阵

% 定义去雾参数
mint = 0.05;     % 限定最小透射率
maxA = 240;     % 限定A的最大值
kenlRatio = .01;                % 最小化滤波时用的窗口占整幅图片的比例
img = haze_img;             % 原图

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

% 暗通道第二步：最小化窗口滤波
% 定义滤波窗口
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]));
dc2 = minfilt2(dc, [krnlsz,krnlsz]);
dc2(h,w)=0;     % 滤波后，最后一个图像单位没有了，这里手动补齐 

% 估计大气光
A = min(maxA,get_airlight(haze_img,dc2));
% 得到透射图
t = 1 - dc2./A;
t_d=double(t);
img_d = double(img);

% 加入导向滤波，得到更精细的透射图
r = krnlsz*4;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
t_d = filtered;

% 根据新的透射图，得到去雾图
t_d(t_d < mint) = mint;
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

y = uint8(J);

% 显示对比图
subplot(1,2,1);
imshow(haze_img);
subplot(1,2,2)
imshow(y);

end

function A = get_airlight(hazeimg,darkchannel)
% 根据雾图及对应暗通道图获取大气光
% hazeimg 雾图
% darkchannel hazeimg的暗通道图
ratio = 0.01;       % 取暗通道大小的前0.1% 
% 求解前0.1%的暗通道索引位置
sorted_dc = sort(darkchannel(:),'descend');
[h,w] = size(sorted_dc);
tmp_idx = round(h*w*ratio);
tmp_idx_value = sorted_dc(tmp_idx);
idx = darkchannel >= tmp_idx_value;
% 寻找这些位置上最亮的点最为A
A = double(max(hazeimg(idx)));
end