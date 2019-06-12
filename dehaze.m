function y = dehaze(haze_img)
% ȥ����: ����������ͼ�������ȥ������ȥ����ͼƬ����
%   haze_img: ��ͼ����
%   y:         ȥ���ľ���

% ����ȥ�����
kenlRatio = .01;                % ��С���˲�ʱ�õĴ���ռ����ͼƬ�ı���
maxAtomsLight = 200;        % �޶����ȫ�ֹ�
img = haze_img;             % ԭͼ

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

% ��ͨ���ڶ�������С�������˲�
% �����˲�����
krnlsz = floor(max([3, w*kenlRatio, h*kenlRatio]));
dc2 = minfilt2(dc, [krnlsz,krnlsz]);
dc2(h,w)=0;     % �˲������һ��ͼ��λû���ˣ������ֶ����� 

% ���ƴ����⣨��ԭ�������е㲻һ����
A = min([maxAtomsLight, max(max(dc2))]);
% �õ�͸��ͼ
t = 255 - dc2;
t_d=double(t)/255;
img_d = double(img);

% ���뵼���˲����õ�����ϸ��͸��ͼ
r = krnlsz*4;
eps = 10^-6;
% filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
% t_d = filtered;

% �����µ�͸��ͼ���õ�ȥ��ͼ
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

y = uint8(J);
end