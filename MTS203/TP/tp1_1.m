%% TP 1 Premiere partie
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
figure();
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
figure();
for K=1:5
    bruit_r=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit_i=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit=bruit_r+j*bruit_i;
    if (type_canal==1)
        signal_bruite=signal_emis+bruit;
    end,
    signal_adapte=filter(gr,1,signal_bruite);
    subplot(2,3,K);
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
disp(['Signal a bruit a l''entree du filtre ' num2str(SNR_entree) 'dB']);
disp(['Signal a bruit en sortie du filtre ' num2str(SNR_sortie) 'dB']);

%% Recepteur 5 affichage de la constellation en sortie
RSB = [5 10 20 30];
for K=1:4
    bruit_r=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit_i=(10^(-RSB(K)/20))*randn(longueur,1);
    bruit=bruit_r+j*bruit_i;
    signal_bruite=signal_emis+bruit;
    signal_adapte=filter(gr,1,signal_bruite);
    subplot(2,2,K);
    plot(real(signal_adapte),imag(signal_adapte),'x');
    grid;
    axis([-2 2 -2 2]);
    xlabel('Re(signal_adapte)');
    ylabel('Im(signal_adapte)');
    Title = ['Constellation en sortie avec RSB=' int2str(RSB(K))];
    title(Title);
    hold off
end
N_symb=length(signal_adapte);
%% Effet du facteur de retombee
% signal emis
Alpha = [0.2 0.5 0.8 0.9];
figure();
for K = 1:4
ge=rrcosf(Alpha(K),T,nech,Tmax); 
signal_emis=filter(ge,1,TAB);
% canal de transmission
SNR=30;
longueur=length(signal_emis);
bruit_r=(10^(-SNR/20))*randn(longueur,1);
bruit_i=(10^(-SNR/20))*randn(longueur,1);
bruit=bruit_r+j*bruit_i;

signal_bruite=signal_emis+bruit;
% Signal recu
gr=fliplr(ge);
signal_adapte=filter(gr,1,signal_bruite);


te=0:T/nech:Tmax-T/nech;
subplot(2,2,K);
for k=2:1500
    plot(te,real(signal_adapte(k*length(te)+1:(k+1)*length(te))))
    hold on;
end
grid
xlabel('t/T')
ylabel('Partie Reelle')
Title = ['Diagramme de l''oeil en sortie du filtre adapte avec alpha=' num2str(Alpha(K))];
title(Title);
hold off
end
%% Echantillonnage aux instants de decision
%delta_t_0=nech+1;
%while delta_t_0>=nech+1 |delta_t_0<=-(nech+1)
%    delta_t_0=input('Delta t0 sur l''instant d''echantillonnage (multiple de T/nech): ');
%end

% ->instant de decision
%t0=delta_t_0;
t0 = 0;
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
