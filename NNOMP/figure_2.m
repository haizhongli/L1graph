clear
N = 256; % Dictionary size
T = 1000; % Number of trials

MM = [64,128]; % Range of parameter M
KK = 2:2:48; % Range of parameter K
m = 1;
for M = MM
    k = 1;
    for K = KK    
        IT = K;
        Phi = randn(M,N);
        Phi = columnNormalise(Phi);    
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
        exrec(k,m) = rec/T;
        exrec_time(k,m) = toc/T;
        

        %%% Fast Non-negativity OMP
        
        tic;
        parfor i = 1:T
            x = zeros(N,1);
            r = randperm(N);
            s = r(1:K);
            x(s) = ones(K,1);
            y = Phi*x;
            xhat_na = fnnomp(Phi,y,K,0);        
            rec_na = rec_na + (norm(x-xhat_na) <= sigma);
        end
        exrec_na(k,m) = rec_na/T;
        exrec_na_time(k,m) = toc/T;
        k = k+1;
    end
    m = m+1;
end

le = ['b+';'ro';'bx';'r^'];
figure(1)
clf
subplot(211)
hold on 
for m = 1:length(MM)
    plot(KK,exrec(:,m),le(2*(m-1)+1,:),'LineWidth',2)    
    plot(KK,exrec_na(:,m),le(2*m,:),'LineWidth',2)
end
title('Average Exact Recovery')
legend(['Canonical NNOMP, M = ',num2str(MM(1))],['Non-Negativity Aware OMP, M = ',num2str(MM(1))],['Canonical NNOMP, M = ',num2str(MM(2))],['Non-Negativity Aware OMP, M = ',num2str(MM(2))])
box on


subplot(212)
for m = 1:length(MM)
     semilogy(KK,exrec_time(:,m),le(2*(m-1)+1,:),'LineWidth',2)
     hold on
     semilogy(KK,exrec_na_time(:,m),le(2*m,:),'LineWidth',2)    
end
title('Computational Time (Sec)')
legend(['Canonical NNOMP, M = ',num2str(MM(1))],['Non-Negativity Aware OMP, M = ',num2str(MM(1))],['Canonical NNOMP, M = ',num2str(MM(2))],['Non-Negativity Aware OMP, M = ',num2str(MM(2))])
xlabel('Sparsity')
grid on