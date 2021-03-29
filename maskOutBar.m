function i_barMasked = maskOutBar( i )
%this function takes RGB image and returnes the input image but the bar shapes
%are replaced with white color (essential to detect the legend)

mask=barMask(i);
se = strel('disk', 4);
mask=imdilate(mask, se);
mask=~mask;

i_barMasked=bsxfun(@times, i, cast(mask, 'like', i));
i_barMasked(~[mask, mask, mask])=255;

end

