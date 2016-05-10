%% TP 1 Deuxieme partie
%% Simulation d'une chaine de com simplifiee
clear all;
close all;
nech=8;
T=1;
type_canal=1; % canal 1 : gaussien ?bande illimmitée, canal 2 : canal sélectif en fréquence
alpha=0.5;

y=imread('lena.jpg');
[ taille_i_l taille_i_c]=size(y);
%% Conversion decimale -> binaire
Q=8;
Y=reshape(y,256*256,1);
z=double(dec2bin(Y,Q))-48;%% dec2bin convertit en string binaire!!!
%% et double('1')=49 et double('0')=48
Y=z(:);
[l_z c_z]=size(z);
dk=((2*Y(1:2:length(Y))-1)+i*(2*Y(2:2:length(Y))-1));
N_symb=length(dk);

%% donnees 4-PSK avec nech echantillons par temps symbole T
TAB=zeros(N_symb*nech,1);
TAB(1:nech:length(TAB))=dk;

%% filtrage d'emission
Tmax=6*T;
t=-Tmax:T/nech:Tmax;
ge=rrcosf(alpha,T,nech,Tmax); 
signal_emis=filter(ge,1,TAB);
theta=pi/4;
signal_emis=signal_emis*exp(i*theta);

% generation de gr et etude de h=(ge * gr) 
%->
%% Canal de transmission
SNR=input('RSB en dB: ');
longueur=length(signal_emis);
bruit_r=(10^(-SNR/20))*randn(longueur,1);
bruit_i=(10^(-SNR/20))*randn(longueur,1);
bruit=bruit_r+j*bruit_i;
%-> canal

signal_bruite=signal_emis+bruit;

%-> rapport signal sur bruit d'entree

%% Filtre adapte de reception
gr=fliplr(ge);
signal_filtre=filter(gr,1,signal_emis);
bruit_filtre=filter(gr,1,bruit);
signal_adapte=filter(gr,1,signal_bruite);
%-> rapport signal sur bruit de sortie
%% affichage de la constellation en sortie
    plot(real(signal_adapte),imag(signal_adapte),'x');
    grid;
    axis([-2 2 -2 2]);
    xlabel('Re(signal_adapte)');
    ylabel('Im(signal_adapte)');
    title('Constellation en sortie avec RSB=100dB theta=pi/4');
    hold off
%% Diagramme de l'oeil
figure(3)
te=0:T/nech:Tmax-T/nech;
for k=2:1500
    plot(te,real(signal_adapte(k*length(te)+1:(k+1)*length(te))))
    hold on;
end
grid
xlabel('t/T')
ylabel('Partie Reelle')
title('Diagramme de l''oeil en sortie du filtre adapte')
hold off
%% Echantillonnage aux instants de decision
% ->instant de decision
t0=0;

dk_dec=signal_adapte(length(ge)+t0:nech:length(signal_adapte));
dk_dec=(sign(real(dk_dec))+j*sign(imag(dk_dec)));
dk=dk(1:length(dk_dec));

erreur=(sum(abs(real(dk)-real(dk_dec)))+sum(abs(imag(dk)-imag(dk_dec))))/2;
teb=erreur/(2*length(dk))