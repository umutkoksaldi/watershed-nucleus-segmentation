files = dir('umut/cell_regions/clumped/*');
for k = 1:length(files)
    images = dir(sprintf('umut/cell_regions/clumped/%s/*.png', files(k).name));
    for j = 1:length(images)
        im_name = images(j).name;
        image = imread(sprintf('umut/cell_regions/clumped/%s/%s', files(k).name ,im_name));
        %figure, imshow(image), title('original image');
        I = rgb2gray(image);
        I_eq = adapthisteq(I);
        bw = im2bw(I_eq, graythresh(I_eq));
        bw2 = imfill(bw,'holes');
        bw2_perim = bwperim(bw2);
        overlay1 = imoverlay(I_eq, bw2_perim, [.3 1 .3]);
        max = 0;
        for i=1:50
            mask_em = imextendedmax(I_eq, i);
            mask_em = bwareaopen(mask_em, 100);
            mask_em = imclose(mask_em, ones(6,6));
            mask_em = imfill(mask_em, 'holes');
            CC = bwconncomp(mask_em, 8);
            if CC.NumObjects > max
                max = CC.NumObjects;
            end
        end
        
        if max == 1
            continue;
        end
        
        if max == 2
            for i=1:50
                mask_em = imextendedmax(I_eq, i);
                mask_em = bwareaopen(mask_em, 100);
                mask_em = imclose(mask_em, ones(6,6));
                mask_em = imfill(mask_em, 'holes');
                CC = bwconncomp(mask_em, 8);
                if CC.NumObjects == 2
                    break;
                end
            end
        end  
        
        if max >= 3
            for i=1:50
                mask_em = imextendedmax(I_eq, i);
                mask_em = bwareaopen(mask_em, 100);
                mask_em = imclose(mask_em, ones(6,6));
                mask_em = imfill(mask_em, 'holes');
                CC = bwconncomp(mask_em, 8);
                if CC.NumObjects == 3
                    break;
                end
            end
        end  
        
        overlay2 = imoverlay(I_eq, bw2_perim | mask_em, [.3 1 .3]);
        %figure, imshow(overlay2), title('overlay2')
        
        I_eq_c = imcomplement(I_eq);
        I_mod = imimposemin(I_eq_c, ~bw2 | mask_em);
        %figure, imshow(I_mod), title('Imposedmin')
        
        L = watershed(I_mod);
        labeled = label2rgb(L);
        labeled = rgb2gray(labeled);
        labeled(labeled < 255) = 0;
        labeled(labeled == 255) = 1;
        labeled = logical(labeled(:,:,1));
        %figure, imshow(label2rgb(L)), title('Labeled image')
        imwrite(imoverlay(image, labeled), sprintf('umut/cell_regions/clumped/segmented/%s/%s', files(k).name, strrep(images(j).name, '.png', '-segmented.png')));
        disp(im_name)
    end
end

