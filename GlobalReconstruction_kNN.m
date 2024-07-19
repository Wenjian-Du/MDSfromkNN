%% Load data
close all
clear
load 1KSphereUniformSampled
%[pt, ptnormal, trg]=ReadObjShape('kitten.obj');
%% Generate complete distance matrix
num_pt=size(pt,1);
warning off
Dist=double(zeros(num_pt,num_pt));
for index_1=1:num_pt
    Dist(index_1,:)=sqrt(sum((bsxfun(@minus,pt(index_1,:),pt)).^2,2));
end
DistSqu=Dist.*Dist;
%% Generate incomplete initial distance matrix
NNnumber=10;                   %Initial k
Weight=zeros(num_pt);          %known distance position in distance matrix
[temp,I]=mink(DistSqu,NNnumber);
J=1:num_pt;
J=repmat(J,NNnumber,1);
temp_1=zeros(NNnumber,num_pt); 
for i=1:NNnumber
    for j=1:num_pt
        Weight(I(i,j),J(i,j))=1;
    end
end
for i=1:num_pt
    for j=i+1:num_pt
        if Weight(i,j)==0
            Weight(i,j)=Weight(j,i);
        else
            Weight(j,i)=Weight(i,j);
        end
    end  
end
%% Reconstruct cooedinates
stopk=20; %Determine how much knn distance information we extend
[DistSqu_Recon,Weight_Recon]=LinearReconstruct(DistSqu,Weight,NNnumber,stopk);%Distance extension
Dist_Recon=sqrt(DistSqu_Recon);      %Extended distance matrix
mu_1=10; %Parameter for stable SDP
mu_2=5;  %Parameter for stable SDP
admmit=10000; %Iterations of ADMM, different surfaces and k require different numbers of iterations
rgradit=40000;%Iterations of RGrad
tic;
[GCor,ipm]=ADMMRGrad(Dist_Recon,Weight_Recon,mu_1,mu_2,admmit,rgradit);%
toc;
%% Compute relative error
Y=double(ones(num_pt));
for i=1:num_pt
    for j=1:num_pt
        if(i==j)
            Y(i,j)=1-1/(num_pt);
        else
            Y(i,j)=-1/(num_pt);
        end
    end
end
DistanceSqu=Dist.*Dist;
Dist_1=double(zeros(num_pt,num_pt));
for index_1=1:num_pt
    Dist_1(index_1,:)=sqrt(sum((bsxfun(@minus,GCor(index_1,:),GCor)).^2,2));
end
DistanceSqu_1=Dist_1.*Dist_1;
IPM_Truth=-1/2*Y*DistanceSqu*Y;
IPM_Recon=-1/2*Y*DistanceSqu_1*Y;
relativeerr=norm(IPM_Truth-IPM_Recon,'fro')/norm(IPM_Truth,'fro');
%% Show the reconstructed surface
figure
ViewMesh(GCor,trg);