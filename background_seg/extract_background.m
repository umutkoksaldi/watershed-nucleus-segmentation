function mask = extract_background(imgname,figFlag,numOfBins,minSigma,minArea,neighSize)
% imgname: filtered L channel of La*b* color space
% numOfBins: 100
% minSigma: 0
% minArea: min area size, 1500
% neighSize: neighbourhood 4 or 8, 4

addpath('utils/');

load(imgname);

tic

T = minimum_error_thresholding(I,numOfBins,minSigma);
T = T*1

mask = (I>T);

if figFlag
    figure; hist(I(:),numOfBins); title(sprintf('%f',T));
%     pause;
end

if figFlag
    figure, imshow(I), hold on;
    himage = imshow(mask);
    set(himage, 'AlphaData', 0.3);
    title('Overlayed mask');
%     pause;
end

mask = sizethre(mask,minArea,'down',neighSize);

if figFlag
    figure, imshow(I), hold on;
    himage = imshow(mask);
    set(himage, 'AlphaData', 0.3);
    title('Overlayed mask after filtering');
    %      pause;
end
 
toc
 
end