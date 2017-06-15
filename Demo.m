%% %Init
clc;
clear all;
addpath(genpath(fullfile('./lib')));

%% %Param
datasetname='VIPeR'; % 'VIPeR'
ftrname='GOG'; %
metricname='PSCRC'; % 'PSCRC' 'L2'(Baseline)
% metricname='L2'; % Uncomment this line to test the baseline L2 metric
datapath=['.\data\' datasetname];

%% %Ftr
GetFtrs;
if ~exist('Ftr_GOG','var')
    return;
else
    X=Ftr_GOG;
end

%% %CV
fprintf(['\n... Cross Validation ...\n']);
load([datapath  '/CVIdx_' datasetname '.mat']);
CVIdx=CVIdx_VIPeR.SvsS_SDALF_PaGb;
numFolds=size(CVIdx.Test_Gly_picidx,1);
CMR_all=[]; Time_all=[];
time_CV0 = tic;
for r=1:numFolds
    fprintf('\nFold %d: \n', r);
    %% Tr/Te Split
    tr_glyidx=CVIdx.Train_Gly_picidx(r,:);    tr_Pid_G=CVIdx.Train_Gly_picidx_Pid(r,:);
    tr_prbidx=CVIdx.Train_Prb_picidx(r,:);    tr_Pid_P=CVIdx.Train_Prb_picidx_Pid(r,:);
    te_glyidx=CVIdx.Test_Gly_picidx(r,:);    te_Pid_G=CVIdx.Test_Gly_picidx_Pid(r,:);
    te_prbidx=CVIdx.Test_Prb_picidx(r,:);    te_Pid_P=CVIdx.Test_Prb_picidx_Pid(r,:);
    X_tr_prb=X(:,tr_prbidx);
    X_tr_gly=X(:,tr_glyidx);
    X_te_prb=X(:,te_prbidx);
    X_te_gly=X(:,te_glyidx);
    
    %% Train
    time_train0 =  tic;
    Train_XQDA;
    time_train = toc(time_train0);
    fprintf('Training time: %.2g s. \n', time_train);
    
    %% Test
    time_test0 = tic;
    if strcmp(metricname,'PSCRC')==1
        Test_PSCRC;
    elseif strcmp(metricname,'L2')==1
        Dist=pdist2(Y_te_prb',Y_te_gly','euclidean');
    end
    time_test = toc(time_test0);
    fprintf('Testing time: %.2g s.\n', time_test);
    
    %% CMC
    [CMN,CMR]=GetCMCbyDist2(Dist,te_Pid_P,te_Pid_G,0,'SvsS','MPD');
    fprintf('R1-5-10-20: %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%\n', CMR([1,5,10,20])');
    CMR_all=[CMR_all;CMR]; Time_all=[Time_all;time_test];
end

%% Stat
CMR_ave=mean(CMR_all,1); Time_ave=mean(Time_all,1);
fprintf('\nAverage Test time: %.2g s\n', Time_ave);
fprintf('Average CMC over %d folds: \n', size(CMR_all,1));
fprintf('R1-5-10-20: %5.2f%%, %5.2f%%, %5.2f%%, %5.2f%%\n', CMR_ave([1,5,10,20])');
