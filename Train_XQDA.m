%% XQDA metric and subspace learning
[W, M] = XQDA(X_tr_gly', X_tr_prb', tr_Pid_G, tr_Pid_P);

%% The approximated XQDA subspace
Mh=M^(1/2);
Mh=real(Mh);
W=W*Mh;
Y_tr_gly=W'*X_tr_gly;
Y_tr_prb=W'*X_tr_prb;
Y_te_gly=W'*X_te_gly;
Y_te_prb=W'*X_te_prb;

%% Norm
Y_tr_gly=NormMat(Y_tr_gly,2);
Y_tr_prb=NormMat(Y_tr_prb,2);
Y_te_gly=NormMat(Y_te_gly,2);
Y_te_prb=NormMat(Y_te_prb,2);