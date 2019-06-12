%    DP�ϳ�ͼƬȥ��������
%   ʵ�ֹ��ܣ�
%   1. ������ͼ��ȥ������ȥ��ͼƬд�뵽������
%   2. ��������ȥ��ͼ����ͼ֮���ƽ��PSNR��SSIM
clear;clc;close all;
% �������������
need_dehaze = 1;         % �Ƿ���Ҫȥ��
need_save_dehaze = 1;  % �Ƿ���Ҫ����ȥ����
clear_dir = 'D:\Projects\Dehaze\��������ȥ�����\RESIDE�ϳɲ��Լ�\clear\'; % ����ͼƬ�ļ���
haze_dir = 'D:\Projects\Dehaze\��������ȥ�����\RESIDE�ϳɲ��Լ�\haze\';  %�ϳ���ͼ�ļ���
dehazed_dir = 'D:\Projects\Dehaze\��������ȥ�����\cvpr09 defog(matlab)\RESIDE�ϳ�ͼȥ����\';        % ȥ��ͼ����Ŀ¼

filelist = dir(strcat(haze_dir,'*.jpg'));
file_num = length(filelist);            % �ļ�����
file_names = cell(1,file_num);      % �ļ���
for i = 1:file_num
    file_names{i} = filelist(i).name;
end

% ����clearͼ����ͼ
% ��clear
clear_imgs = cell(1,file_num);
for i = 1:file_num
    clear_imgs{i} = imread(strcat(clear_dir,file_names{i}));
end

% ��haze
haze_imgs = cell(1,file_num);
for i = 1:file_num
    haze_imgs{i} = imread(strcat(haze_dir,file_names{i}));
end

% ��hazeͼ�õ�ȥ��
dehazed_imgs = cell(1,file_num);
if need_dehaze
    for i = 1:file_num
        dehazed_imgs{i} = dehaze(haze_imgs{i});
    end
end

% ����dehazedͼ
if need_dehaze && need_save_dehaze
    for i = 1:file_num
        imwrite(dehazed_imgs{i},strcat(dehazed_dir,file_names{i}));
    end
end

% ����PSNRƽ��ֵ
total_psnr = 0;
for i = 1:file_num
    total_psnr = total_psnr + psnr(dehazed_imgs{i},clear_imgs{i});
end
PSNR = total_psnr/file_num

% ����SSIMƽ��ֵ
total_ssim = 0;
for i= 1:file_num
    total_ssim = total_ssim + ssim(dehazed_imgs{i},clear_imgs{i});
end
SSIM = total_ssim / file_num