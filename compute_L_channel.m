files = dir('umut/macrophage_images/*.png');
disp(length(files))
for i = 1:length(files)
    tic
    disp(files(i).name)
    RGB = imread(sprintf('umut/macrophage_images/%s',files(i).name));
    XYZ = xyz2double(applycform(RGB,makecform('srgb2xyz')));
    LAB = lab2double(applycform(XYZ,makecform('xyz2lab')))/100;
    toc
    I = LAB(:,:,1);
    save(sprintf('umut/Lmatfiles/%s',strrep(files(i).name,'.png','-L.mat')),'I');
end
