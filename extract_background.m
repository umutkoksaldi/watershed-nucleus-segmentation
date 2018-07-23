
addpath('background_seg');
files = dir('umut/macrophage_images/*.png');
for i = 1:length(files)
    mask = extract_background(sprintf('umut/Lmatfiles/%s',strrep(files(i).name,'.png','-L.mat')),false,100,0,1500,4);
    overlay = segmentOverlay(imread(sprintf('umut/macrophage_images/%s',files(i).name)),mask,0,1,[255 0 0]);
    save(sprintf('umut/back_ext_res/%s',strrep(files(i).name,'.png','-mask.mat')),'mask');
    imwrite(overlay,sprintf('umut/back_ext_res/%s',files(i).name));
    clear mask;
end

%{
image = imread('umut\macrophage_images\jw-1h 1_c5.png');
I = rgb2gray(image);
I_eq = adapthisteq(I);
bw = im2bw(I_eq, graythresh(I_eq));
bw2 = imfill(bw,'holes');
bw2_perim = bwperim(bw2);
overlay1 = imoverlay(I_eq, bw2_perim, [.3 1 .3]);
imshow(overlay1);
%}