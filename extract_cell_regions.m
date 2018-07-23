function extract_cell_regions(imgname)
imgdirname = 'umut';
resdirname = 'umut/cell_regions';
addpath('utils');
RGB = imread(sprintf('%s/macrophage_images/%s',imgdirname,imgname));
load(sprintf('%s/Lmatfiles/%s',imgdirname,strrep(imgname,'.png','-L.mat')));
load(sprintf('%s/back_ext_res/%s',imgdirname,strrep(imgname,'.png','-mask.mat')));
mask = connComp(mask);

newdirname = strrep(imgname,'.png','');
mkdir(sprintf('%s/%s',resdirname,newdirname));

save(sprintf('%s/%s/%s',resdirname,newdirname,strrep(imgname,'.png','-maskComp.mat')),'mask');

for i = 1:max(mask(:))
    [retRGB retmask retI] = get_single_cell_region(RGB,mask,I,i);
    imwrite(retRGB,sprintf('%s/%s/%s-%d.png',resdirname,newdirname,strrep(imgname,'.png',''),i));
    %     imwrite(retmask,sprintf('%s/%s-%d_mask.tif',resdirname,strrep(imgname,'.tif',''),i));
    %     imwrite(retI,sprintf('%s/%s-%d_I.tif',resdirname,strrep(imgname,'.tif',''),i));
    save(sprintf('%s/%s/%s-%d.mat',resdirname,newdirname,strrep(imgname,'.png',''),i),'retRGB','retmask','retI');
end

end

function [retRGB2 retmask retI2] = get_single_cell_region(RGB,mask,I,compno)
compmask = (mask == compno);
retRGB = uint8(zeros(size(RGB)));
for i = 1:3
    retRGB(:,:,i) = RGB(:,:,i).*uint8(compmask);
end
retI = I.*double(compmask);
[rowstart rowend colstart colend] = boundingbox(compmask,10);
retRGB2 = retRGB(rowstart:rowend,colstart:colend,:);
retmask = compmask(rowstart:rowend,colstart:colend);
retI2 = retI(rowstart:rowend,colstart:colend);
end

function [rowstart rowend colstart colend] = boundingbox(compmask,dif)
[row,col] = find(compmask);
if ((min(row)-dif)<1)
    rowstart = 1;
else
    rowstart = min(row)-dif;
end

if ((min(col)-dif)<1)
    colstart = 1;
else
    colstart = min(col)-dif;
end

if ((max(row)+dif)>size(compmask,1))
    rowend = size(compmask,1);
else
    rowend = max(row)+dif;
end

if ((max(col)+dif)>size(compmask,2))
    colend = size(compmask,2);
else
    colend = max(col)+dif;
end
end