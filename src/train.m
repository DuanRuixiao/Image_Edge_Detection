clc;
close all;
clearvars;

tic;

cd ..\inputs\images\train;

ids = dir('*.jpg');

thresholds = linspace(10,700,200);
thresholds_LoG = linspace(0,30,200);
for jj = 1:length(thresholds)
    threshold = thresholds(jj);
    threshold_LoG = thresholds_LoG(jj);
    nom_LoG = 0; nom_sobel = 0; nom_prewitt = 0; nom_roberts = 0;
    pre_den_LoG = 0; pre_den_sobel = 0; pre_den_prewitt = 0; pre_den_roberts = 0;
    rec_den_LoG = 0; rec_den_sobel = 0; rec_den_prewitt = 0; rec_den_roberts = 0;
    for ii = 1:length(ids)
        id = ids(ii).name;
        cd ..\..\..\inputs\images\train;
        I = rgb2gray(imread(id));
        gaussian_sigma = 1.5;
        BW_LoG = logEdgeDetectionWD(I,gaussian_sigma,threshold_LoG);
        BW_sobel = sobelEdgeDetectorWD(I,threshold);
        BW_prewitt = prewittEdgeDetectorWD(I,threshold);
        BW_roberts = robertsEdgeDetectorWD(I,threshold);

        cd ..\..\..\outputs\true_boundaries\train;
        id = erase(id, '.jpg');
        load([id '.mat']);
        
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
    
    precision_LoG(jj) = nom_LoG / pre_den_LoG;
    recall_LoG(jj) = nom_LoG / rec_den_LoG;
    
    precision_sobel(jj) = nom_sobel / pre_den_sobel;
    recall_sobel(jj) = nom_sobel / rec_den_sobel;
    
    precision_prewitt(jj) = nom_prewitt / pre_den_prewitt;
    recall_prewitt(jj) = nom_prewitt / rec_den_prewitt;
    
    precision_roberts(jj) = nom_roberts / pre_den_roberts;
    recall_roberts(jj) = nom_roberts / rec_den_roberts;
end

F_LoG = 2 * precision_LoG .* recall_LoG ./ (precision_LoG + recall_LoG);
[~,ind] = max(F_LoG);
threshold_LoG = thresholds_LoG(ind);

F_sobel = 2 * precision_sobel .* recall_sobel ./ (precision_sobel + recall_sobel);
[~,ind] = max(F_sobel);
threshold_sobel = thresholds(ind);

F_prewitt = 2 * precision_prewitt .* recall_prewitt ./ (precision_prewitt + recall_prewitt);
[~,ind] = max(F_prewitt);
threshold_prewitt = thresholds(ind);

F_roberts = 2 * precision_roberts .* recall_roberts ./ (precision_roberts + recall_roberts);
[~,ind] = max(F_roberts);
threshold_roberts = thresholds(ind);

figure(1);
plot(recall_LoG,precision_LoG,'b','linewidth',2);
hold on;
plot(recall_sobel,precision_sobel,'r','linewidth',2);
hold on;
plot(recall_prewitt,precision_prewitt,'y','linewidth',2);
hold on;
plot(recall_roberts,precision_roberts,'g','linewidth',2);

legend('LoG','Sobel','Prewitt','Roberts');
xlabel('Recall','fontsize',15);
ylabel('Precision','fontsize',15);

cd ..\..\..\outputs\train_images;
saveas(figure(1),'Train_PR_Curve.png');

cd ..\..\codes;

toc;
% running time: 2390 seconds.