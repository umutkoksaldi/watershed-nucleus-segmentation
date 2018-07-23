imgname = 'jw-1h 5_c5';
files = dir(sprintf('umut/cell_regions/%s/*.png', imgname));

for i = 1:length(files)
    rgb = imread(sprintf('umut/cell_regions/%s/%s', imgname,files(i).name));
    I = rgb2gray(rgb);
    I_eq = adapthisteq(I);
    bw = im2bw(I_eq, graythresh(I_eq));
    bw2 = imfill(bw,'holes');
    stats = regionprops(bw2, 'Eccentricity');
    if (stats(1).Eccentricity > 0.77) || (length(stats) > 1)
        figure, imshow(bw2), title(stats(1).Eccentricity)
        imwrite(rgb, sprintf('umut/cell_regions/clumped/%s/%s', imgname,files(i).name));
    end 
end

