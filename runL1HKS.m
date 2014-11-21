%% path
addpath('./dps/');
addpath('./CoSaMP_OMP');

%% normalize
Data = NMRow(Data);
N = size(Data,1);

%% calculate the Heat Kernel Signature
hts = HeatKernelSignature(Data,2);

%% sort "hts" and get the low 70% of data...
%% should find the knee point....but use 70% is fast.
[hts,sid] = sort(hts);

%% regular samples:
reg_ids = sid(1:floor(0.7*length(hts)));

%% DPS get required size dictionary.
m = size(Data,2);
reg_num = length(reg_ids); %% #samples of lower HTS values
level = floor(log2(reg_num/m))-1;
[R,~] = dps(Data(reg_ids),level);

%% get dictionary
ids = find(R==1);
dict_ids = reg_ids(ids);
dict = Data(dict_ids,:);
coh = Coherence(dict');
fprintf('Dictionary Coherence: %d\n',coh);

%debug dictonary
% folds_num = max(R);
% c = zeros(folds_num,1);
% for i = 1:folds_num
%     ids = find(R==i);
%     dict_ids = reg_ids(ids);
%     dict = Data(dict_ids,:);
%     c(i) = Coherence(dict');
% end

%%sparse coding;
non_dict_ids = 1:N;
non_dict_ids(dict_ids) = [];
G = L1GraphCoSaMPHeat(Data, dict_ids);

%% store to a sparse graph
[i,j,v] = find(G);
for k = 1:length(i)
    i(k) = non_dict_ids(i(k));
end
for k =1:length(j)
    j(k) = dict_ids(j(k));
end
W = sparse(i,j,v,N,N);


