a=imread('BS.jpg');
b=imread('BS-2.jpg');
subplot(2,2,1);imshow(a);title('BackGround'); % display both images together
subplot(2,2,2);imshow(b);title('Current Frame');
[Background_hsv]=round(rgb2hsv(a));  % converting both images from RGB to HSV - Hue Saturation Values
[CurrentFrame_hsv]=round(rgb2hsv(b));
Out = bitxor(Background_hsv,CurrentFrame_hsv);
Out=rgb2gray(Out); % HSV to Gray conversion
[rows columns]=size(Out); % reading rows and column of image
for i=1:rows % convert it into binary image
for j=1:columns

if Out(i,j) >0

BinaryImage(i,j)=1;

else

BinaryImage(i,j)=0;

end

end
end
FilteredImage=medfilt2(BinaryImage,[5 5]); %Apply Median filter to remove Noise
[L num]=bwlabel(FilteredImage); %Boundary Label the Filtered Image

STATS=regionprops(L,'all');
cc=[];
removed=0;
for i=1:num %Remove the noisy regions
dd=STATS(i).Area;

if (dd < 500)

L(L==i)=0;
removed = removed + 1;
num=num-1;

else

end

end

[L2 num2]=bwlabel(L);
[B,L,N,A] = bwboundaries(L2);
subplot(2,2,3),  imshow(L2);title('BackGround Detected');
subplot(2,2,4),  imshow(L2);title('Blob Detected');

hold on;
for k=1:length(B),

if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);

for l=find(A(:,k))'
boundary = B{l};
plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
end

end

end

im = imread('shadow1.jpg');
figure, imshow(im);

% NOTE: You might need different median filter size for your test image.
r = medfilt2(double(im(:,:,1)), [3,3]); 
g = medfilt2(double(im(:,:,2)), [3,3]);
b = medfilt2(double(im(:,:,3)), [3,3]);


shadow_ratio = ((4/pi).*atan(((b-g))./(b+g))); %% Calculate Shadow Ratio:
figure, imshow(shadow_ratio, []); colormap(jet); colorbar;

% NOTE: You might need a different threshold value for your test image.
% You can also consider using automatic threshold estimation methods.
shadow_mask = shadow_ratio>0.2;
figure, imshow(shadow_mask, []); 

shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;

% NOTE: Depending on the shadow size that you want to consider,
% you can change the area size threshold
shadow_mask = bwareaopen(shadow_mask, 100);
[x,y] = find(imdilate(shadow_mask,strel('disk',2))-shadow_mask);

figure, imshow(im); hold on,
plot(y,x,'.b'), title('Shadow Boundaries');


a = imread('illum1.jpg');
% Convert the image to gray level image
b= rgb2gray(a);
imshow(b);
% Apply adaptive histogram eqaulization to enahnce the contrast of the
% image
c=adapthisteq(b);
imshow(c);
% Illumination Correction
MN=size(c);
background = imopen(c,strel('rectangle',MN));
imshow(background);
I2 = imsubtract(c,background);
imshow(I2);
I3= imadjust(I2);
imshow(I3);
% Convert to binary image
level = graythresh(b);
imshow(level);
d=im2bw(I3,level);
bw = bwareaopen(d, 50);
imshow(bw);