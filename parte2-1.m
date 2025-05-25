%Notas Prévias:
%Os shifts(fftshift e ifftshift) são feitos apenas nos plots, não nos
%sinais!

pkg load symbolic;

clc; clear; close all;
format short eng;

% Parâmetros
tau = 0.2E-6;

fs = 250E6;
ts = 1/fs;
N = 10000;

t = (-N/2:(N/2)-1)*ts;
f = (-N/2:N/2-1)*(fs/N);
w = 2*pi*f;

L = 250E-9;
C = 100E-12;

d1 = 50;
d2 = 100;


% Sinal de Entrada
vin = heaviside(t + tau/2) - heaviside(t - tau/2);
figure(1); plot(t, vin, 'o-'); title('Sinal de Entrada no Tempo'); grid on;
xlabel('t(s)'); ylabel('v_{in}(t)');
xlim([-2*tau 2*tau]);

% FFT - Sinal de Entrada na Frequência
Vin = fft(vin)*ts;
figure(2);
plot(w, fftshift(abs(Vin)), '-o'); grid on; title('Sinal de Entrada na Frequência');
xlabel('w(rad/s)'); ylabel('V_{in}(w)');
xlim([-79E6 79E6]);

% Parâmetros de atenuação
c1 = 0;
c2 = 0;
c3 = 3.6E-12;

alfa_w = c1 + (c2/sqrt(2*pi))*sqrt(1i*w) + (c3/(2*pi))*abs(w);
beta_w = w*sqrt(L*C);
gamma_w = alfa_w;

% Transferência
transfer_d1 = exp(-gamma_w*d1);
transfer_d2 = exp(-gamma_w*d2);

% Plot da função de transferência
figure(3);
plot(w, abs(transfer_d1), '-o'); hold on;
plot(w, abs(transfer_d2), '-o'); grid on;
title('Funções de Transferência');
xlim([-79E6 79E6]); ylim([0 1]);
legend('H(w) 50m','H(w) 100m');


% Sinal de saída na frequência
Vout1 = Vin .* transfer_d1;
Vout2 = Vin .* transfer_d2;
figure(4); plot(w, (abs(Vout1)), '-o'); title('V_{out}(w)'); hold on;
plot(w, (abs(Vout2)), 'o-'); grid on;
legend('V_{out}(w) 50m','V_{out}(w) 100m');
xlim([-79E6 79E6])

%Sinal de Saída no Tempo
vout1 = ifft(Vout1);
vout2 = ifft(Vout2);
figure(5); plot(t, vout1/tau, '-o'); title('v_{out}(t)'); hold on;
plot(t, vout2/tau, 'o-'); grid on;
legend('v_{out}(t) 50m','v_{out}(t) 100m');
xlim([-2*tau 2*tau]);
