%im = imread('shadow2.jpg');
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
shadow_mask = shadow_ratio>0.005;
figure, imshow(shadow_mask, []); 

shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;

% NOTE: Depending on the shadow size that you want to consider,
% you can change the area size threshold
shadow_mask = bwareaopen(shadow_mask, 100);
[x,y] = find(imdilate(shadow_mask,strel('diamond',3))-shadow_mask);

figure, imshow(im); hold on,
plot(y,x,'.b'), title('Shadow Boundaries');