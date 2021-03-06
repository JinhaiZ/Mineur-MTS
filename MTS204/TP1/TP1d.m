clear all;clc;
%% Question 1
[X,FS,NBITS] = wavread('FF_8KHZ.WAV');
N = length(X);
T = linspace(1,N,N)/FS;
figure();
plot(T,X);
axis([0,N/FS,-1,1])
xlabel('Temps second');
ylabel('Amplitude');
title('Signal de parole');

%% Question 2
T_trame = 20*10^-3; 
Nbr_trame = floor((N/FS)/T_trame);%Nbr_trame=298;
display = ['Nombre de trames a etudier ',num2str(Nbr_trame)];
disp(display);

%% Question 3
p = 10;
nb = T_trame*FS;%nb=160;
% former la matrice de Toeplitz
Toeplitz = zeros(p,p,Nbr_trame);
% calculer les coefficients de predition lineaire
a = zeros(p,Nbr_trame);
% touver la signal derreur de prediction
e = zeros(nb,Nbr_trame);
for i = 1:1:Nbr_trame
    trame = X(1+160*(i-1):160*i);
    % auto est autocorrelation
    auto = Autocorrelation(trame);
    % former la matrice de Toeplitz a partir d'autocorrelation
    Toeplitz(:,:,i) = toeplitz(auto(1:p));%Gamma(0)~Gamma(p-1)
    temp = auto(2:p+1);%Gamma(1)~Gamma(p)
    a(:,i) = -temp/Toeplitz(:,:,i);
    A = [1;a(:,i)];
    e(:,i) = filter(A,1,trame);
end;
% touver la signal derreur de prediction
e = reshape(e,1,nb*Nbr_trame);
figure();
T = (0:nb*Nbr_trame-1)/FS;
plot(T, e);
axis([0,N/FS,-1,1]);
xlabel('Temps second');
ylabel('Amplitude');
title('Signal d''Erreur de prediction');

%% Question 4
% l'ecart-type de l'erreur de prediction
Ecart_type = zeros(Nbr_trame,1);
for i = 0:Nbr_trame-1
    ind = i+1;
    Ecart_type(ind) = std(e(1+nb*i:nb*ind));
end
figure();
T = (0:Nbr_trame-1)*nb/FS;
stairs(T, Ecart_type);
axis([0,N/FS,0,0.06]);
xlabel('Temps second');
ylabel('Amplitude');
title('Ecart-type de l''erreur de prediction');

%% Question 5
% Generer un bruit blanc gaussien cente reduit
% mu = 0; sigma = Ecart_type(1);  
% Bruit = BruitBlanc(mu, Ecart_type, nb);

%% Question 6
for ind = 1:1:Nbr_trame
    Bruit_blanc = BruitBlanc(0, Ecart_type(ind), nb);
    A = [1;a(:,i)];
    Sigal_synthese(1+nb*(ind-1):nb*ind) = filter(1, A, Bruit_blanc);
end
figure();
T = (0:nb*Nbr_trame-1)/FS;
plot(T, Sigal_synthese)
axis([0,N/FS,-1,1]);
xlabel('Temps second');
ylabel('Amplitude');
title('Signal de synthese');

%% Question 7
Var_singal = var(X(1:Nbr_trame*nb));
Var_bruit = var(X(1:Nbr_trame*nb)-Sigal_synthese');
SNR = Var_singal/Var_bruit;
SNR_dB = 10*log10(SNR);
