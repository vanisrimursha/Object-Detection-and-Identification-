%a = imread('illum1.jpg');
a=imread('shadow1.jpg');
% Convert the image to gray level image
b= rgb2gray(a);
figure,imshow(b);
% Apply adaptive histogram eqaulization to enahnce the contrast of the
% image
c=adapthisteq(b);
imshow(c);
% Illumination Correction
MN=size(c);
background = imopen(c,strel('rectangle',MN));
imshow(background);
I2 = imsubtract(c,background);
figure,imshow(I2);
I3= imadjust(I2);
imshow(I3);
% Convert to binary image
level = graythresh(b);
imshow(level);
d=im2bw(I3,level);
bw = bwareaopen(d, 50);
figure,imshow(bw);