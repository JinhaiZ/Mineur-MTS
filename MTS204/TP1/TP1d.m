%% Question 1
[Y,FS,NBITS] = wavread('FF_8KHZ.WAV');
N = length(Y);
X = linspace(1,N,N)/FS;
plot(X,Y);
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
% calculer les coefficients de predition lineaire
Toeplitz = zeros(Nbr_trame,p,p);
a = zeros(Nbr_trame,p);
for i = 1:1:Nbr_trame
    trame = Y(1+160*(i-1):160*i);
    tau = Tau(trame);
    temp = tau(1:10);
    Toeplitz(i,:,:) = toeplitz(temp,temp);
    A = Toeplitz(i,:,:);
    a = inv(Toeplitz(i,:,:))*temp;
end;





