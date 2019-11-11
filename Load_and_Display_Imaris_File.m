% Pull metadata from Imaris file into Matlab struct

%Change desired resolution level here. 0 is full resolution, the higher the
%number the lower the resolution (7 max).
RESOLUTION_LEVEL = '0';

resLevelString = sprintf('/DataSet/ResolutionLevel %s/TimePoint 0/Channel 0/' , RESOLUTION_LEVEL);
info = h5info('Camk2-MORF3-D1Tom-D2GFP_TGME02-1_30x_Str_01A.ims', resLevelString);

% Must get the actual XYZ sizes from data to remove padding from images
imageSizeX = [info.Attributes(1).Value{:}];
imageSizeY = [info.Attributes(2).Value{:}];
imageSizeZ = [info.Attributes(3).Value{:}];
imageSizeX = str2double(imageSizeX);
imageSizeY = str2double(imageSizeY);
imageSizeZ = str2double(imageSizeZ);

% Load raw data in here.
resLevelStringData = strcat(resLevelString, 'Data'); %Change URI to access raw data
raw_data = h5read('Camk2-MORF3-D1Tom-D2GFP_TGME02-1_30x_Str_01A.ims', resLevelStringData);

data = raw_data(1:imageSizeX, 1:imageSizeY, 1:imageSizeZ);

% Display data through iteration of slices
for indexZ = 1:imageSizeZ
    MZ = data(1:imageSizeX,1:imageSizeY,indexZ);
    imshow(MZ, [0 1000]);
    pause(0.2);
end

% Call SegmentFunction for soma detection
