
function AD  = CompAD(data)
%
% Nonlinear ICA based on local metric (inverse covariance)
% and the "natural" extension AA^T.
%
% Input:
% - data - M (no. of samples) by N (dimension) matrix of samples
% - GorL: type of scaling
% - Sigma: scaling parameter
%
% Output:
% - Sim - affinity matrix.

[nrow,ncol]=size(data);
COV=zeros(ncol,ncol,nrow);
inv_c=zeros(ncol,ncol,nrow);

for i = 1 : ncol
    for j = 1 : ncol
        for k = 1 : nrow
            Z1 = (data(:,i)-data(k,i));
            Z2 = (data(:,j)-data(k,j));
            COV(i,j,k)  = (sum(Z1 .* Z2)/(nrow));
            %COV(i,j,k) = (sum(Z1 .* Z2))./((sum(Z1.^2)*sum(Z2.^2)).^0.5); %% better
        end
    end
end

for k = 1:nrow
    inv_c(:,:,k)=inv(COV(:,:,k)+1*eye(ncol)); %0.01 best
    %inv_c(:,:,k)=(COV(:,:,k))^(-1);
    %inv_c(:,:,k)= inv((COV(:,:,k).^(ones(N,N)-eye(N)))+eye(N));%^(-1);
%     [U, S, V]= svd(COV(:,:,k));
%     s= diag(S); L= sum(s> 1e-9); % simple thresholding based decision
%     inv_c(:,:,k) = (U(:, 1: L)* diag(1./ s(1: L))* V(:, 1: L)')';
end

% 
% Local distance
% 
AD = zeros(nrow, nrow);
%h = waitbar(0, 'Please wait');
for i = 1:nrow
    %waitbar(i/M, h);
    for j = 1:nrow
         AD(i,j) = (((data(i,:) - data(j,:)) * inv_c(:,:,i) * (data(i,:) - data(j,:))')+((data(i,:) - data(j,:)) * inv_c(:,:,j) * (data(i,:) - data(j,:))'));
    end
end
%close(h);
AD=AD-diag(diag(AD));
%Dis=Dis./2;
AD=(AD).^(1/2);
%Dis=max(Dis,Dis');


