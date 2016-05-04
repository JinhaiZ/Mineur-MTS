%% TP 1 Premiere partie
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
%% Canal de transmission
SNR=input('RSB en dB: ');
longueur=length(signal_emis);
bruit_r=(10^(-SNR/20))*randn(longueur,1);
bruit_i=(10^(-SNR/20))*randn(longueur,1);
bruit=bruit_r+j*bruit_i;
%-> canal
if (type_canal==1)
    signal_bruite=signal_emis+bruit;
end,
%-> rapport signal sur bruit d'entree
SNR_entree =  10*log10(var(signal_emis)/var(signal_bruite));
%% Filtre adapte de reception
gr=fliplr(ge);
signal_filtre=filter(gr,1,signal_emis);
bruit_filtre=filter(gr,1,bruit);
signal_adapte=filter(gr,1,signal_bruite);
%-> rapport signal sur bruit de sortie
%% Recepteur 1
figure();
plot(t,ge);
hold on;
t_conv=-2*Tmax:T/nech:Tmax*2;
h = conv(ge,gr);
plot(t_conv,h,'r');
title('ge(t) et h(t)'),xlabel('temps'),ylabel('Amplitude');
legend('ge(t)','h(t)');
figure();
stem(h(1:8:end));
title('h(nt)'),xlabel('temps'),ylabel('Amplitude');
%% Recepteur 2
Alpha = [0.2,0.5,0.8,0.99];
Color = ['r','g','b','y'];
figure();
for k=1:4
    GE=rrcosf(Alpha(k),T,nech,Tmax); 
    GR=fliplr(GE);
    H = conv(GE,GR);
    plot(t_conv,H,Color(k));
    hold on;
end
title('h(t)'),xlabel('temps'),ylabel('Amplitude');
legend('a=0.2','a=0.5','a=0.8','a=0.99');
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
%% Recepteur 3
RSB = [0 5 10 30 100];

for K=1:5
    bruit_r=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit_i=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit=bruit_r+j*bruit_i;
    if (type_canal==1)
        signal_bruite=signal_emis+bruit;
    end,
    signal_adapte=filter(gr,1,signal_bruite);
    figure()
    te=0:T/nech:Tmax-T/nech;
    for k=2:1500
        plot(te,real(signal_adapte(k*length(te)+1:(k+1)*length(te))))
        hold on;
    end
    grid
    xlabel('t/T')
    ylabel('Partie Reelle')
    Title = ['Diagramme de l''oeil en sortie du filtre adapte avec RSB=' int2str(RSB(K))];
    title(Title);
    hold off
end
%% Recepteur 4

%% Echantillonnage aux instants de decision
delta_t_0=nech+1;
while delta_t_0>=nech+1 |delta_t_0<=-(nech+1)
    delta_t_0=input('Delta t0 sur l''instant d''echantillonnage (multiple de T/nech): ');
end

% ->instant de decision
t0=delta_t_0;

dk_dec=signal_adapte(length(ge)+t0:nech:length(signal_adapte));
dk_dec=(sign(real(dk_dec))+j*sign(imag(dk_dec)));
dk=dk(1:length(dk_dec));

erreur=(sum(abs(real(dk)-real(dk_dec)))+sum(abs(imag(dk)-imag(dk_dec))))/2;
teb=erreur/(2*length(dk))


%% Reconstruction de l'image

X(1:2:2*length(dk_dec))=(real(dk_dec)+1)/2;
X(2:2:2*length(dk_dec))=(imag(dk_dec)+1)/2;
X_p=zeros(1,l_z*Q);
X_p(1:length(X))=X;
%% Mise sous forme matricielle
z2=reshape(X_p,length(X_p)/Q,Q);
num=2.^(Q-1:-1:0);
z_quantifie=num*z2';
image_dec=reshape(z_quantifie,taille_i_l, taille_i_c);
figure(4)
colormap('gray')
imagesc(image_dec)
title('Image reconstruite');
