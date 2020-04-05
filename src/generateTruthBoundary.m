close all;
clc;
clearvars;

cd ..\inputs\ground_truth\train;

ids = dir('*.mat');

for ii = 1:size(ids)
    cd ..\..\..\inputs\ground_truth\train;
    id = ids(ii).name;
    load(id);
    
    true_boundary = false(size(groundTruth{1,1}.Boundaries));
    [~, N] = size(groundTruth);
    for jj = 1:N
        true_boundary = or(true_boundary, groundTruth{1,jj}.Boundaries);
    end
    
    cd ..\..\..\outputs\true_boundaries\train;
    save(id, 'true_boundary');
end