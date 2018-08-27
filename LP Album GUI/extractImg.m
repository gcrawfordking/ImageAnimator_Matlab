function [ retImg ] = extractImg( img )
% basic image extraction algorithm... removes the largest object from
% image... the remainder is colored key color (0, 255, 0);

% filter, make binary, then extract largest image
tempImg = imgaussfilt(img, 2.0);
tempImg = im2bw(tempImg);
tempImg = imcomplement(tempImg);
tempImg = bwareafilt(tempImg, 1, 'largest');

% close
se = strel('disk',30);
tempImg = imclose(tempImg, se);
tempImg = uint8(tempImg);
retImg = img;


% apply binary mask to RGB image
for i = 1:3
    retImg(:, :, i) = retImg(:, :, i) .* tempImg;
end


end

