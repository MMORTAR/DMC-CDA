clear;
clc;
cD=importdata('chr_diseasematrix.csv');
circsim=importdata('seqsimilarity.csv'); 
dissim=csvread('dissimilarity.csv',1);

%FFCV
A=cD';%cc*dd
[row,column]=size(A);%dd*cc
[score_ori]=zeros(row,column);
[result]= MY_MAIN(A',circsim,dissim);
score_ori = result;

index_1 = find(1 == A);
index_0 = find(0 == A);

pp = length(index_1)
tauc=zeros(1,100);

for id=1:100
    rand('seed',id);
    indices = crossvalind('Kfold', pp, 5);
    for i=1:5
        index_i=find(i == indices);
        A(index_1(index_i)) = 0;
        posIndices= find(A==1);
        [result1]=MY_MAIN(A',circsim,dissim);
        score_ori(index_1(index_i))=result1(index_1(index_i));
        A=cD';%dd*cc
    end
    A=cD';
    pre_label_score = score_ori(:);%dd*cc
    label_y = A(:);%dd*cc
    [auc]=roc(pre_label_score,label_y,'red')
    tauc(1,id)=auc;
end
me=mean(tauc)
st=std(tauc)
    
    