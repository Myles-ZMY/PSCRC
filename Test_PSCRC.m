%% Test_PSCRC

%% Dict
Y_tr=[Y_tr_prb Y_tr_gly];
k=316;
D=Y_tr(:,1:k);

%% Param
lamda=0.3;
beta=5;

%% Pre-Compute
K=D'*D;
Kyp=D'*Y_te_prb;
Kyg=D'*Y_te_gly;
n=size(K,2);
P=K+(lamda+beta)*eye(n);
P=inv(P);
Q=eye(n)-beta^2*P^2;
Q=inv(Q);
A=Q*P;
B=beta*A*P;
Z_Ap=A*Kyp;
Z_Ag=A*Kyg;
Z_Bp=B*Kyp;
Z_Bg=B*Kyg;

%% Dist
Dist=zeros(size(Y_te_prb,2),size(Y_te_gly,2));
% PSCRC
for i=1:size(X_te_prb,2)
    for j=1:size(X_te_gly,2)
        zp=Z_Ap(:,i)+Z_Bg(:,j);
        zg=Z_Ag(:,j)+Z_Bp(:,i);
        Dist(i,j)=1-zp'*zg/(norm(zp)*norm(zg));
    end
end
