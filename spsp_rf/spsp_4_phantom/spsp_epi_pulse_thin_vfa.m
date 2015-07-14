%RF pulse for Hurd C13 phantom at 3T
% Choose #6 to replicate the results

close all, clc
ss_opt([]);
ss_globals;

% 0.5 ppm = gamma_C13 * 30000 * 0.5e-6
%
freqs = [163 166.5 173 178.5 185];
freqs = freqs*3*10.705;
freqs = freqs - min(freqs); 


df = 0.5e-6 * 30000 * 1070;
lacf = 165; pyrhf = 40; alaf = -45; pyrf = -230;
lacf = freqs(5); pyrhf = freqs(4); alaf = freqs(3); pyrf = freqs(2);
% lacf = freqs(5) - freqs(3);
% pyrf = freqs(2) - freqs(3);

fspec = [pyrf-lacf-df pyrhf-lacf+df ...
    -2*df 2*df...
    alaf-pyrf-df lacf-pyrf+df];
fspec = [pyrf-lacf-df -pyrf ...
    -2*df 2*df...
    pyrf lacf-pyrf+df];
% fspec = [pyrf-lacf-df pyrhf-lacf+df ...
%     -2*df 2*df...
%     -(pyrhf-lacf+df) lacf-pyrf+df];


% fspec = [-498 -321 -2*df df 321 498];
a_angs = [0 pi/2 0];
d = [.01 .05 .01];

ang = max(a_angs);
fctr = 500;

z_thk = 1; %cm
z_tb = 3.;  %tbw
ss_type = 'EP Whole';

ptype = 'ex';
z_ftype='ls';
z_d1 = 0.01;
z_d2 = 0.01;

ss_opt([]);				% Reset all options
opt = ss_opt({'Nucleus', 'Carbon', ...
	      'Max Duration', 20e-3, ...
	      'Num Lobe Iters', 15, ...
	      'Max B1', 1.6, ...
	      'Num Fs Test', 100, ...
	      'Verse Fraction', 0.8, ...
	      'SLR', 0, ...
	      'B1 Verse', 0, ...
	      'Min Order', 0,...
	      'Spect Correct', 0,...
          'Max Grad',5,...
          'Max Slew',20});

[g,rf,fs] = ...
    ss_design(z_thk, z_tb, [z_d1 z_d2], fspec, a_angs, d, ptype, ...
	      z_ftype, [], ss_type, fctr, 0);

% fplot = [0 lacf-pyrf pyrhf-pyrf alaf-pyrf pyrhf-lacf alaf-lacf pyrf-lacf];
fplot = freqs;
[f,z,m] = ss_plot(g, rf, SS_TS, ptype, z_thk*2, 2.5*[min(fspec) max(fspec)], SS_GAMMA, fplot);
      
return
ss_save(g,rf,ang,z_thk, [], 'GE', fspec, a_angs);

%% Variable flip angle

gscale_fcn = scale_vfa_gradient_spsp(rf, g, vfa_const_amp(5, pi/2));

%g = scale_vfa_gradient(rf, N, Nisodelay);
clear gscale Mxy Mz

N = 5;
flips = vfa_const_amp(N, pi/2);

Nrf = length(rf);


for n = 1:N
        rf_all(1:Nrf,n) = 2*pi*SS_GAMMA*SS_TS * rf * flips(n)/(pi/2); % small-tip
end
gscale(1) = 2*pi*SS_GAMMA*SS_TS;

Nsim = 501;
x = linspace(-2*z_thk, 2*z_thk, Nsim);
fsim = 0;

% just simulate on-resonance slice profile
[a b] = abr(rf_all(1:Nrf,1),gscale(1)*g(1:end).', x,fsim);

Mxy(1:Nsim,1) = 2*conj(a).*b;
Mz(1:Nsim,1) = 1 - 2*conj(b).*b;

S1 = abs(sum(Mxy(1:Nsim,1)))/Nsim;

figure(99)
subplot(211), cplot(x, Mxy);
subplot(212), plot(x, Mz);

for n = 2:N
    gscale(n) = gscale(n-1);
    glim = [gscale(n-1), 10*gscale(n-1)];
    [a b] = abr(rf_all(1:Nrf,n),gscale(n)*g, x,fsim);
    Mxy(1:Nsim,n) = 2*conj(a).*b  .* Mz(1:Nsim, n-1);
    Snew = abs(sum(Mxy(1:Nsim,n)))/Nsim;
    while abs(S1 - Snew) > S1*1e-3
        if Snew > S1
            % shrink slice
            gold = gscale(n);
            gscale(n) = mean(glim);
            glim(1) = gold;
        else
            % slice too thin
            gold = gscale(n);
            gscale(n) = mean(glim);
            glim(2) = gold;
        end
        [a b] = abr(rf_all(1:Nrf,n),gscale(n)*g, x,fsim);
        Mxy(1:Nsim,n) = 2*conj(a).*b  .* Mz(1:Nsim, n-1);
        Snew = abs(sum(Mxy(1:Nsim,n)))/Nsim;
        
    end
    Mz(1:Nsim,n) = ( 1 - 2*conj(b).*b ) .* Mz(1:Nsim,n-1);
end


% widen initial RF pulse to saturate Mz with desired FWHM
gscale = gscale/gscale(end) *2*pi*SS_GAMMA*SS_TS;

%gscale = 2*pi*SS_GAMMA*SS_TS * ones(1,5);

[a b] = abr(rf_all(1:Nrf,1),gscale(1)*g, x,fsim);
Mxy(1:Nsim,1) = 2*conj(a).*b;
Mz(1:Nsim,1) = 1 - 2*conj(b).*b;
S(1) = abs(sum(Mxy(1:Nsim,1)))/Nsim;

for n = 2:N
        [a b] = abr(rf_all(1:Nrf,n),gscale(n)*g, x,fsim);
        Mxy(1:Nsim,n) = 2*conj(a).*b  .* Mz(1:Nsim, n-1);
    Mz(1:Nsim,n) = ( 1 - 2*conj(b).*b ) .* Mz(1:Nsim,n-1);
        S(n) = abs(sum(Mxy(1:Nsim,n)))/Nsim;
end

figure(99)
%subplot(211), plot(x, real(Mxy), x, imag(Mxy),'--');
subplot(211), plot(x, abs(Mxy));ylabel('M_{XY}')
subplot(212), plot(x, Mz); ylabel('M_Z'), xlabel('Position')
%pause

gscale_out = gscale/gscale(end)
return

%%
%outdir = [root_fname '/']; out_fname = root_fname;
%system(['mkdir ' outdir]);
currentdir = pwd;

  system(sprintf('ssh ese2 ''cd %s; mv %s%03d.rho %s%03d-nohd.rho; xlatebin -o %s%03d.rho %s%03d-nohd.rho'' ', currentdir, root_fname,k, root_fname,k, root_fname,k, root_fname,k));
  system(sprintf('ssh ese2 ''cd %s; mv %s%03d.pha %s%03d-nohd.pha; xlatebin -o %s%03d.pha %s%03d-nohd.pha'' ', currentdir, root_fname,k, root_fname,k, root_fname,k, root_fname,k));
    system(sprintf('ssh ese2 ''cd %s; mv %s%03d.grd %s%03d-nohd.grd; xlatebin -o %s%03d.grd %s%03d-nohd.grd'' ', currentdir, root_fname,k, root_fname,k, root_fname,k, root_fname,k));




