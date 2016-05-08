%% Simulation d'une chaine de com simplifiee
clear all;
close all;
nech=8;
T=1;
type_canal=1; % canal 1 : gaussien ?bande illimmite, canal 2 : canal seectif en frequence
alpha=2;
while (alpha>=1 |alpha<=0)
    alpha=input('Valeur du coefficient de roll off du filtrage de Nyquist (0<alpha<1): ');
end

y=imread('lena.jpg');
[ taille_i_l, taille_i_c]=size(y);
figure(1);
clf;
colormap('gray')
imagesc(y);
title('Image originale');
%% Conversion decimale -> binaire
Q=8;
 Y=reshape(y,256*256,1);
z=double(dec2bin(Y,Q))-48;%% dec2bin convertit en string binaire!!!
%% et double('1')=49 et double('0')=48
Y=z(:);
[l_z c_z]=size(z);
dk=((2*Y(1:2:length(Y))-1)+i*(2*Y(2:2:length(Y))-1));

%% affichage de la constellation de depart
figure(2);
clf;
plot(real(dk),imag(dk),'x');
grid;
axis([-2 2 -2 2]);
xlabel('Re(d_k)');
ylabel('Im(d_k)');
title('Constellation émise');
N_symb=length(dk);

%% donnees 4-PSK avec nech echantillons par temps symbole T
TAB=zeros(N_symb*nech,1);
TAB(1:nech:length(TAB))=dk;

%% filtrage d'emission
Tmax=6*T;
t=-Tmax:T/nech:Tmax;
ge=rrcosf(alpha,T,nech,Tmax); 
signal_emis=filter(ge,1,TAB);

% generation de gr et etude de h=(ge * gr) 
%->
%% Canal de transmission (canal a trajets multiples)
SNR=20;
longueur=length([signal_emis;zeros(17*nech,1)]);
bruit_r=(10^(-SNR/20))*randn(longueur,1);
bruit_i=(10^(-SNR/20))*randn(longueur,1);
bruit=bruit_r+j*bruit_i;
%-> canal
%if (type_canal==1)
    signal_bruite=[signal_emis;zeros(17*nech,1)]+bruit;
%end,
%-> rapport signal sur bruit d'entree
%SNR_entree =  10*log10(var(signal_bruite-bruit)/var(bruit));

%retard = [2*nech, 12*nech, 17*nech];
signal_1 = [zeros(2*nech,1);signal_emis;zeros(15*nech,1)];
signal_2 = [zeros(12*nech,1);signal_emis;zeros(5*nech,1)];
signal_3 = [zeros(17*nech,1);signal_emis];
att = [0.8*exp(j*pi/4), 0.3*exp(j*pi*3/2), 0.2*exp(j*pi/16)];
signal_multiple = signal_bruite + att(1)*signal_1 + att(2)*signal_2 + att(3)*signal_3;
%% Filtre adapte de reception
gr=fliplr(ge);
signal_adapte=filter(gr,1,signal_multiple);

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
title('Diagramme de l''oeil en sortie du filtre adapte avec canal a trajets multiple')
hold off