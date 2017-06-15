function nM=NormMat(M,l)
[m,n]=size(M);
switch l
    case 1
        nM=M./repmat(sum(abs(M)),[m 1]);
    case 2
        nM=normc(M);
    otherwise
        nM=zeros(m,n);
        for j=1:n
            nM(:,j)=norm(M(:,j),l);
        end
        nM=repmat(nM,[m,1]);
        nM=M./nM;
end

        

