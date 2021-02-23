function [M_recovery]= MY_MAIN(cD,circsim,dissim)

[ncp_m,ncp_d] = NCP(circsim,dissim,cD);%cinum*dinum

dd = size(dissim,1);
cc = size(circsim,1); 

[Wcc,Wdd]=gkl(cc,dd,cD);


Wdc = ncp_d';%dinum*cinum
Wcd = ncp_m';%cinum*dinum


alpha = 1;
beta = 10;
K = 10;%KNN
tol1 = 2*1e-3;
tol2 = 1*1e-5;
maxiter = 300;
[dd,cc] = size(Wdc);


P_TMat = Wdc;
P_TMat_new =P_TMat;
T1 = [Wcc; P_TMat_new];
[t1, t2] = size(T1);
trIndex1 = double(T1 ~= 0);
[W1, iter1] = BNNR(alpha, beta, T1, trIndex1, tol1, tol2, maxiter, 0, 1);
M_ResultMat1 = W1((t1-dd+1):t1, 1:cc);%dinum*cinum


P_TMat = Wcd;
P_TMat_new = P_TMat;
T2 = [P_TMat_new, Wdd];
[t_1, t_2] = size(T2);
trIndex2 = double(T2 ~= 0);
[W2, iter2] = BNNR(alpha, beta, T2, trIndex2, tol1, tol2, maxiter, 0, 1);
M_ResultMat2 = W2(1:dd, 1:cc);


M_recovery = 0.7*M_ResultMat1 + 0.3*M_ResultMat2;
end

