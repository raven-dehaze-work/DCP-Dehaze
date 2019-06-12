%    DP合成图片去雾主程序
%   实现功能：
%   1. 读入雾图，去雾，并将去雾图片写入到本地中
%   2. 计算所有去雾图与雾图之间的平均PSNR和SSIM
clear;clc;close all;
% 定义程序辅助参数
need_dehaze = 1;         % 是否需要去雾
need_save_dehaze = 1;  % 是否需要保存去雾结果
clear_dir = 'D:\Projects\Dehaze\其他论文去雾代码\RESIDE合成测试集\clear\'; % 清晰图片文件夹
haze_dir = 'D:\Projects\Dehaze\其他论文去雾代码\RESIDE合成测试集\haze\';  %合成雾图文件夹
dehazed_dir = 'D:\Projects\Dehaze\其他论文去雾代码\cvpr09 defog(matlab)\RESIDE合成图去雾结果\';        % 去雾图保存目录

filelist = dir(strcat(haze_dir,'*.jpg'));
file_num = length(filelist);            % 文件数量
file_names = cell(1,file_num);      % 文件名
for i = 1:file_num
    file_names{i} = filelist(i).name;
end

% 读入clear图和雾图
% 读clear
clear_imgs = cell(1,file_num);
for i = 1:file_num
    clear_imgs{i} = imread(strcat(clear_dir,file_names{i}));
end

% 读haze
haze_imgs = cell(1,file_num);
for i = 1:file_num
    haze_imgs{i} = imread(strcat(haze_dir,file_names{i}));
end

% 用haze图得到去雾
dehazed_imgs = cell(1,file_num);
if need_dehaze
    for i = 1:file_num
        dehazed_imgs{i} = dehaze(haze_imgs{i});
    end
end

% 保存dehazed图
if need_dehaze && need_save_dehaze
    for i = 1:file_num
        imwrite(dehazed_imgs{i},strcat(dehazed_dir,file_names{i}));
    end
end

% 计算PSNR平均值
total_psnr = 0;
for i = 1:file_num
    total_psnr = total_psnr + psnr(dehazed_imgs{i},clear_imgs{i});
end
PSNR = total_psnr/file_num

% 计算SSIM平均值
total_ssim = 0;
for i= 1:file_num
    total_ssim = total_ssim + ssim(dehazed_imgs{i},clear_imgs{i});
end
SSIM = total_ssim / file_num