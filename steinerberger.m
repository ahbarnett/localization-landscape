% Animation of Lu-Steinerberger "Krylov" landscape function in "alpha",
% for sparse (banded) random matrix.
% https://arxiv.org/abs/1709.03364
% Barnett 2/12/20. Post-localization-of-waves-workshop @ SF. MATLAB.
clear

n = 1e3;       % matrix size (can easily do 1e5 in a few seconds...)
alpha = 100;   % really, the max alpha
halfbw = 2;    % bandwidth is twice this plus 1
A = spdiags(randn(n,2*halfbw+1),[-halfbw:halfbw],n,n);  % band-diag random mat
A = A+A';      % Hermitian
[V,D] = eigs(A,6);    % sparse eigsolve of extremal vecs (actually Lanczos)
Vplot = V + ones(n,1)*log(abs(diag(D)))';   % eigvecs shifted up by log|eigval|
               % (why? since reflects the limit of f_k/k for each efunc)

p = 10;        % # rand vecs in Lu version
R = randn(n,p);
figure(1); set(gcf,'position',[100 300 1000 300]);   % animate...
v = VideoWriter('landscape.avi'); open(v);           % file output too
for k=1:alpha  % k is iteration, not element...
  clf; plot(1:n,Vplot,'-'); hold on;     % eigvecs in colors
  plot(1:n,log(sum(R.^2,2))/k/2,'k.-','markersize',10);  % f_k scaled by 1/k
  title(sprintf('k=%d',k)); axis([1 n 1.4 2.6]); drawnow; %pause(0.04);
  writeVideo(v,getframe(gcf));
  R = A*R;     % do the work
end
close(v);

%u = (A+10*speye(n))\ones(n,1); % Mayboroda landscape: solve (A+cI)u=[1,1,..]^T
%plot(1:n,2.0 + u,'r--');  % show it, guess some vertical scaling. Not sure...
