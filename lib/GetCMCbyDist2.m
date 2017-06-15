function [CMN,CMR,sortpos]=GetCMCbyDist2(Dist_PG,Pid_Prb,Pid_Gly,ds,mode,fuseM)
Dist_GP=Dist_PG';
[numpic_Gly,numpic_Prb]=size(Dist_GP);
if length(Pid_Prb)~=numpic_Prb || length(Pid_Gly)~=numpic_Gly
    fprintf('Error: num of pics not right\n ');
    return;
end
if ds==1
    Dist_GP=-Dist_GP;
end
if ~exist('fuseM','var')
    fuseM='MPD';
end;
%% a common case
% G\P 2  3  3  4  6  2  7
% 1
% 2
% 2
% 5
% 3
% 5
% 6
%%
%Gly persons (sort)
minPid_Gly=min(Pid_Gly);
maxPid_Gly=max(Pid_Gly);
person_Gly=[];
tmpDist=[];
tmpPid_Gly=[];
for i=minPid_Gly:maxPid_Gly
    idx=(Pid_Gly==i);
    sortpos=sum(idx);
    if sortpos >0
        person_Gly=[person_Gly i];
        tmpDist=[tmpDist ;Dist_GP(idx,:)];
        tmpPid_Gly=[tmpPid_Gly repmat(i,[1,sortpos])];
    end
end
numperson_Gly=length(person_Gly);
Dist_GP=tmpDist;
Pid_Gly=tmpPid_Gly;

%Prb persons (sort & pick)
%Probe set must be included in the Gallery set for Re-Id task
%(Or else unincluded probe imgs may belong to a new person)
minPid_Prb=min(Pid_Prb);
maxPid_Prb=max(Pid_Prb);
person_Prb=[];
tmpDist=[];
Dist_OutGly=[];
tmpPid_Prb=[];
for i=minPid_Prb:maxPid_Prb
    idx=(Pid_Prb==i);
    sortpos=sum(idx);
    if sortpos >0
        inGly=0;
        for j=1:numperson_Gly
            if i==person_Gly(j)
                inGly=1;
                break;
            end
        end
        if inGly==1
            person_Prb=[person_Prb i];
            tmpDist=[tmpDist Dist_GP(:,idx)];
            tmpPid_Prb=[tmpPid_Prb repmat(i,[1,sortpos])];
        else
            Dist_OutGly=[Dist_OutGly Dist_GP(idx,:)];% Probe subset out of the gallery set
        end
    end
end
numperson_Prb=length(person_Prb);
Dist_GP=tmpDist;
Pid_Prb=tmpPid_Prb;
if ~isempty(Dist_OutGly)
    fprintf('Warning: Probe set contain imgs out of the Gallery set,Discarded from the probe set.');% error('This is not a closed-set re-id experiment.');
end
%% SvsS
if strcmp(mode,'SvsS')==1
    if numperson_Gly~=numpic_Gly
        fprintf('Error: SvsS - num of persons not right\n ');
        return;
    end;
    label_Gly=Pid_Gly;
    label_Prb=Pid_Prb;
end
%% MvsS
if strcmp(mode,'MvsS')==1
    if numperson_Gly>numpic_Gly
        fprintf('Error: MvsS - num of persons not right\n ');
        return;
    end;    

    %get set dist
        Dist_GP_New=[];
    for i=1:numperson_Gly
        %k_Gly= person_Gly(i);
        idx_Gly=(Pid_Gly==person_Gly(i));
        %num_Gly=sum(idx_Gly);
        for j=1:length(Pid_Prb)
            Dist_GiPj=Dist_GP(idx_Gly,j);
            Dist_GP_New(i,j)=Dist_Set(Dist_GiPj,fuseM);
        end
    end
    Dist_GP=Dist_GP_New;
    label_Gly=person_Gly;
    label_Prb=Pid_Prb;
end;
%% MvsM
if strcmp(mode,'MvsM')==1
    if numperson_Gly>numpic_Gly
        fprintf('Error: MvsM - num of persons not right\n ');
        return;
    end;
    % Get set dist
        Dist_GP_New=[];
    for i=1:numperson_Gly
        %k_Gly= person_Gly(i);
        idx_Gly=(Pid_Gly==person_Gly(i));
        %num_Gly=sum(idx_Gly);
        for j=1:numperson_Prb
            %k_Prb=person_Prb(j);
            idx_Prb=(Pid_Prb==person_Prb(j));
            %num_Prb=sum(idx_Prb);
            Dist_GiPj=Dist_GP(idx_Gly,idx_Prb);
            Dist_GP_New(i,j)=Dist_Set(Dist_GiPj,fuseM);
        end
    end
    
    Dist_GP=Dist_GP_New;
    label_Gly=person_Gly;
    label_Prb=person_Prb;
end;
%%
num_Prb=length(label_Prb);
num_Gly=length(label_Gly);
% Dist_GP([1,3,5],2)=Dist_GP(2,2);
[sortDist,sortidx]=sort(Dist_GP,'ascend');

% for the same dist: rank back
for i=1:num_Prb
    id=find(label_Gly==label_Prb(i));
    j=find(sortidx(:,i)==id);
    while j<num_Gly & sortDist(j+1,i)==sortDist(j,i)
        tmp=sortidx(j,i);
        sortidx(j,i)=sortidx(j+1,i);
        sortidx(j+1,i)=tmp;
        j=j+1;
    end
end

%CMR
for r=1:num_Gly
   MN(r)=sum(label_Gly(sortidx(r,:))==label_Prb);
end

CMN(1)=MN(1);
for r=2:size(sortidx,1)
    CMN(r)=CMN(r-1)+MN(r);    
end;
CMR=100*CMN/num_Prb;


