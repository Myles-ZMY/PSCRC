function nFtr_GOG=NormGoG(Ftr_GOG)
d=7567; % RGB,Lab,HSV.nRnG
nFtr_GOG=[NormMat(Ftr_GOG(1:d,:),2); NormMat(Ftr_GOG(d+1:2*d,:),2); ...
NormMat(Ftr_GOG(2*d+1:3*d,:),2); NormMat(Ftr_GOG(3*d+1:end,:),2)];
end