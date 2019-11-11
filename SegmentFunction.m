%==========================================
% FileName: SegmentFunction.m
% Designer: Zhe
% Modified: 11/05/2019
% Describe: Segmentation from the 3D neural microscopy image.
%=================================================================

% Binarization threshold: MAX(Constant(124), Local(mean+3*sigma))
binData = zeros(imageSizeX-192,imageSizeY-192,imageSizeZ);
denoiseData = zeros(imageSizeX-192,imageSizeY-192,imageSizeZ);
for t = 1:imageSizeZ
    for j = 1:64:(imageSizeY-192)-64*2
        for i = 1:64:(imageSizeX-192)-64*2
            %denoise_data = conv2(squeeze(data(:,:,t)), ones(3)/9, 'same');
            ROI = squeeze(data(i:i+192,j:j+192,t));
            avrROI = round(mean(ROI,'all'));
            stdROI = round(std(single(ROI),1,'all'));
            binData(i+64:i+128,j+64:j+128,t) = data(i+92+64:i+92+128,j+92+64:j+92+128,t) >= max(124, (avrROI + stdROI * 3));
        end
    end
end

% Display binarized data through iteration of slices
for indexZ = 1:imageSizeZ
    MZ = binData(1:imageSizeX,1:imageSizeY,indexZ);
    imshow(MZ, []);
    pause(0.2);
end

% Morphological operations to enhance the image
H1 = ones(5);
openData = imopen(binData, H1);
H2 = fspecial('disk',20)>0;
closeData = imclose(openData, H2);

% Build the structure element for soma detection
se = zeros(41,41,5);
for i = 1:5
    se(:,:,i) = H2;
end

% Soma detection
openResult = imopen(closeData, se);

% Display detection result through iteration of slices
for indexZ = 1:imageSizeZ
    MZ = openResult(:,:,indexZ);
    imshow(MZ, []);
    pause(0.2);
end
