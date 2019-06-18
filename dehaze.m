function y = dehaze(haze_img)
% ȥ����: ����������ͼ�������ȥ������ȥ����ͼƬ����
%   haze_img: ��ͼ����
%   y:         ȥ���ľ���

% ����ȥ�����
mint = 0.05;     % �޶���С͸����
maxA = 240;     % �޶�A�����ֵ
kenlRatio = .01;                % ��С���˲�ʱ�õĴ���ռ����ͼƬ�ı���
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

% ���ƴ�����
A = min(maxA,get_airlight(haze_img,dc2));
% �õ�͸��ͼ
t = 1 - dc2./A;
t_d=double(t);
img_d = double(img);

% ���뵼���˲����õ�����ϸ��͸��ͼ
r = krnlsz*4;
eps = 10^-6;
filtered = guidedfilter(double(rgb2gray(img))/255, t_d, r, eps);
t_d = filtered;

% �����µ�͸��ͼ���õ�ȥ��ͼ
t_d(t_d < mint) = mint;
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

y = uint8(J);

% ��ʾ�Ա�ͼ
subplot(1,2,1);
imshow(haze_img);
subplot(1,2,2)
imshow(y);

end

function A = get_airlight(hazeimg,darkchannel)
% ������ͼ����Ӧ��ͨ��ͼ��ȡ������
% hazeimg ��ͼ
% darkchannel hazeimg�İ�ͨ��ͼ
ratio = 0.01;       % ȡ��ͨ����С��ǰ0.1% 
% ���ǰ0.1%�İ�ͨ������λ��
sorted_dc = sort(darkchannel(:),'descend');
[h,w] = size(sorted_dc);
tmp_idx = round(h*w*ratio);
tmp_idx_value = sorted_dc(tmp_idx);
idx = darkchannel >= tmp_idx_value;
% Ѱ����Щλ���������ĵ���ΪA
A = double(max(hazeimg(idx)));
end