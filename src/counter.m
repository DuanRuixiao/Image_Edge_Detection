function [nom,pre_den,rec_den] = counter(image_generated, image_true)
% Count the number of pixels helping to compute precision and recall.

pre_den = sum(sum(image_generated));
rec_den = sum(sum(image_true));
nom = 0;

[M,N] = size(image_generated);
for ii = 1:M
    for jj = 1:N
        if (image_generated(ii,jj) && image_true(ii,jj))
            nom = nom + 1;
        end
    end
end

end