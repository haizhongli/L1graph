clear
T = 1000; % Number of trials
M = 128; % Signal size
NN = M:16:512; % Range of parameter N
KK = [64,96];  % Range of parameter K 

n = 1;
for N = NN    
    k = 1;
    for K = KK    
        IT = K;       
        Phi = randn(M,N);
        rec = 0;
        rec_na = 0;
        sigma = 1e-10;
        
        %%% Canonical Non-negative OMP
        tic;
        parfor i = 1:T
            x = zeros(N,1);
            r = randperm(N);
            s = r(1:K);
            x(s) = ones(K,1);
            y = Phi*x;
            xhat = nnomp_canon(Phi,y,K);
            rec = rec + (norm(x-xhat) <= sigma);    
        end
        exrec(k,n) = rec/T;
        exrec_time(k,n) = toc/T;
        

        %%% Fast Non-negativity OMP
        tic
        parfor i = 1:T
            x = zeros(N,1);
            r = randperm(N);
            s = r(1:K);
            x(s) = ones(K,1);
            y = Phi*x;
            xhat_na = fnnomp(Phi,y,K,0);        
            rec_na = rec_na + (norm(x-xhat_na) <= sigma);
        end
        exrec_na(k,n) = rec_na/T;
        exrec_na_time(k,n) = toc/T;
        k = k+1;
    end
    n = n+1;
end

le = ['b+';'ro';'bx';'r^'];
figure(1)
clf

for k = 1:length(KK)
    semilogy(NN,exrec_time(k,:),le(2*(k-1)+1,:),'LineWidth',2)    
    hold on
    semilogy(NN,exrec_na_time(k,:),le(2*(k),:),'LineWidth',2)
end
title('Computational Time (Sec)')
legend(['Canonical NNOMP, K = ',num2str(KK(1))],['Non-Negativity Aware OMP, K = ',num2str(KK(1))],['Canonical NNOMP, K = ',num2str(KK(2))],['Non-Negativity Aware OMP, K = ',num2str(KK(2))])
box on
grid on
xlabel('Coefficient Vector Dimension (N)')