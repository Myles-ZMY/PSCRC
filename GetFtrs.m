%% Get Ftrs
ftrfilename=['Ftr_' ftrname '_' datasetname];
if exist([datapath  '/' ftrfilename '.mat'],'file')
    fprintf(['\nFtr Loading ...\n']);
    load([datapath '/'  ftrfilename '.mat']);
    fprintf(['Ftr Loaded.\n']);
else
    fprintf(['\nFtr Getting ...\n']);
    if ~exist('./data/VIPeR/VIPeR_feature_all_GOGyMthetaRGB.mat','file');
        fprintf(['Please firstly download GOG features to ./data/VIPeR/ ...\n']);
        return;
    end
    load('./data/VIPeR/VIPeR_feature_all_GOGyMthetaRGB.mat');
    Ftr_RGB=feature_all';
    load('./data/VIPeR/VIPeR_feature_all_GOGyMthetaLab.mat');
    Ftr_Lab=feature_all';
    load('./data/VIPeR/VIPeR_feature_all_GOGyMthetaHSV.mat');
    Ftr_HSV=feature_all';
    load('./data/VIPeR/VIPeR_feature_all_GOGyMthetanRnG.mat');
    Ftr_nRnG=feature_all';
    clear feature_all;
    Ftr0=[Ftr_RGB;Ftr_Lab;Ftr_HSV;Ftr_nRnG];
    Ftr=zeros(size(Ftr0,1),1264);
    Ftr(:,1:2:1264)=Ftr0(:,1:632);
    Ftr(:,2:2:1264)=Ftr0(:,633:1264);
    Ftr_GOG=Ftr;
    save('./data/VIPeR/Ftr_GOG_VIPeR.mat','Ftr_GOG');
    fprintf(['Ftr Gotten.\n']);
end

%% norm
Ftr_GOG = MeanRemove(Ftr_GOG);
Ftr_GOG= NormGoG(Ftr_GOG);
Ftr_GOG=1.2*NormMat(Ftr_GOG,2);