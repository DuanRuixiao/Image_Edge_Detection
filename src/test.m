clc;
close all;
clearvars;

cd ..\inputs\images\test;

ids = dir('*.jpg');

nom_canny = 0; nom_LoG = 0; nom_sobel = 0; nom_prewitt = 0; nom_roberts = 0;
pre_den_canny = 0; pre_den_LoG = 0; pre_den_sobel = 0; pre_den_prewitt = 0; pre_den_roberts = 0;
rec_den_canny = 0; rec_den_LoG = 0; rec_den_sobel = 0; rec_den_prewitt = 0; rec_den_roberts = 0;
for ii = 1:length(ids)
    id = ids(ii).name;
    cd ..\..\..\inputs\images\test;
    I_original = imread(id);
    I = rgb2gray(I_original);
    operator = 'prewitt';   % 'sobel' or 'prewitt'
    gaussian_sigma = 1.5;
    BW_canny = cannyEdgeDetectorWD(I,operator,gaussian_sigma);
    BW_LoG = logEdgeDetectionWD(I,gaussian_sigma);
    BW_sobel = sobelEdgeDetectorWD(I);
    BW_prewitt = prewittEdgeDetectorWD(I);
    BW_roberts = robertsEdgeDetectorWD(I);

    cd ..\..\..\outputs\true_boundaries\test;
    id = erase(id, '.jpg');
    load([id '.mat']);
    
    [nom,pre_den,rec_den] = counter(BW_canny,true_boundary);
    nom_canny = nom_canny + nom;
    pre_den_canny = pre_den_canny + pre_den;
    rec_den_canny = rec_den_canny + rec_den;

    [nom,pre_den,rec_den] = counter(BW_LoG,true_boundary);
    nom_LoG = nom_LoG + nom;
    pre_den_LoG = pre_den_LoG + pre_den;
    rec_den_LoG = rec_den_LoG + rec_den;

    [nom,pre_den,rec_den] = counter(BW_sobel,true_boundary);
    nom_sobel = nom_sobel + nom;
    pre_den_sobel = pre_den_sobel + pre_den;
    rec_den_sobel = rec_den_sobel + rec_den;

    [nom,pre_den,rec_den] = counter(BW_prewitt,true_boundary);
    nom_prewitt = nom_prewitt + nom;
    pre_den_prewitt = pre_den_prewitt + pre_den;
    rec_den_prewitt = rec_den_prewitt + rec_den;

    [nom,pre_den,rec_den] = counter(BW_roberts,true_boundary);
    nom_roberts = nom_roberts + nom;
    pre_den_roberts = pre_den_roberts + pre_den;
    rec_den_roberts = rec_den_roberts + rec_den;
end

precision_canny = nom_canny / pre_den_canny;
recall_canny = nom_canny / rec_den_canny;

precision_LoG = nom_LoG / pre_den_LoG;
recall_LoG = nom_LoG / rec_den_LoG;

precision_sobel = nom_sobel / pre_den_sobel;
recall_sobel = nom_sobel / rec_den_sobel;

precision_prewitt = nom_prewitt / pre_den_prewitt;
recall_prewitt = nom_prewitt / rec_den_prewitt;

precision_roberts = nom_roberts / pre_den_roberts;
recall_roberts = nom_roberts / rec_den_roberts;

figure(1);
scatter(recall_canny,precision_canny,'k','filled');
hold on;
scatter(recall_LoG,precision_LoG,'b','filled');
hold on;
scatter(recall_sobel,precision_sobel,'r','filled');
hold on;
scatter(recall_prewitt,precision_prewitt,'y','filled');
hold on;
scatter(recall_roberts,precision_roberts,'g','filled');
legend('Canny','LoG','Sobel','Prewitt','Roberts');
xlabel('Recall','fontsize',15);
ylabel('Precision','fontsize',15);

F_canny = 2 * precision_canny * recall_canny / (precision_canny + recall_canny);
F_LoG = 2 * precision_LoG * recall_LoG / (precision_LoG + recall_LoG);
F_sobel = 2 * precision_sobel * recall_sobel / (precision_sobel + recall_sobel);
F_prewitt = 2 * precision_prewitt * recall_prewitt / (precision_prewitt + recall_prewitt);
F_roberts = 2 * precision_roberts * recall_roberts / (precision_roberts + recall_roberts);

cd ..\..\..\outputs\test_images\specified_thresholds;
saveas(figure(1),'Test_PR_Curve.png');

cd ..\..\..\codes;