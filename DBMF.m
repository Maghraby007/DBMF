%% image import
image=imread('Lenna.png');
image=rgb2gray(image);%reading the image
[row,col]=size(image); % detecting size of the image
DBMFPSNR=[];
DBMFSSIM=[];
subimage = uint8(zeros(row+2,col+2));%setting a filtered image
threshold=5;
 nd=0.3;
%for nd =0.1:0.1:1;
img_noise=imnoise(image,'salt & pepper',nd); % adding salt and pepper noise
subimage(2:row+1,2:col+1) = img_noise;
filtered_image=subimage(2:row+1,2:col+1);% adding a column of zeros to image
 %%  filtering cycle
for c=2:row
    for r=2:col 
       window=[subimage(c-1:c+1,r-1:r+1)];
        window=reshape(window,[1,9]);
        window=sort(window);
        if window(5)<=window(5)+threshold && window(5)>=window(5)-threshold
           filtered_image(c,r)=window(5);
        else 
            filtered_image(c,r)=subimage(c,r);
        end
    end
      end
%%  remove added zeroz and calculate PSNR & SSIM
 filtered_image=[filtered_image(1:row,1:col)];
 DBMFPSNR = [DBMFPSNR,psnr(filtered_image,image)];
 DBMFSSIM = [DBMFSSIM,ssim(filtered_image,image)*100];
 %% plot
 figure
subplot(2,2,1), imshow(image)
subplot(2,2,2), imshow(img_noise)
subplot(2,2,3), imshow(filtered_image)
% subplot(2,2,1), title ('original image')
% subplot(2,2,2) ,title ('noisy image')
% subplot(2,2,3) ,title ('noisy image after denoising')
% sgtitle('DBMF')
%end
%keep SMFSSIM SMFPSNR ADBMFSSIM ADBMFPSNR DBMFSSIM DBMFPSNR