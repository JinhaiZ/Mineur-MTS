%%Exercice 2
%% question 1
clear all;
I=[50 45 40 40 27;
   10 18 42 36 18;
   25 35 41 38 10;
   95 128 100 25 35;
   100 125 136 20 32;
   110 130 145 130 22;];

V1 = [35 41 38 128 100 25 125 136 20];
V2 = [18 42 36 35 41 38 100];
V3 = [10 35 32 38 25 20 100];
V4 = [130 145 130 125 136 20 100];
V5 = [25 95 100 35 128 125 100];
V6 = [100 25 136 20 32 130 22];
V7 = [128 100 100 125 136 110 130];
V8 = [100 25 41 38 10 36 18];
V9 = [128 100 25 35 41 10 18];

mean_std = zeros(9,2);
mean_std(1,:) = [mean(V1),std(V1)];
mean_std(2,:) = [mean(V2),std(V2)];
mean_std(3,:) = [mean(V3),std(V3)];
mean_std(4,:) = [mean(V4),std(V4)];
mean_std(5,:) = [mean(V5),std(V5)];
mean_std(6,:) = [mean(V6),std(V6)];
mean_std(7,:) = [mean(V7),std(V7)];
mean_std(8,:) = [mean(V8),std(V8)];
mean_std(9,:) = [mean(V9),std(V9)];

%% question 2
[val, ind] = min(mean_std(:,2));
val = mean_std(ind,1);

%% question 3
% Analyser la pertinence de ce filtre par rapport a la topologie 
%locale du point de coordonnees (4,3).

%% question 4
% Lancer le programme nagao2 pour voir l’effet du filtre de Nagao sur une image.

%% question 5
%PSNR = 10*log10(d^2/EQM);
%% question 6
I1 = imread('cameraman.tif');
subplot(2,2,1);
imshow(mat2gray(I1));
title('Image originale')

% Bruitage de l'image
noise_mean = 0;
noise_var = 0.010;
Image = imnoise(I1,'gaussian',noise_mean,noise_var);
%Image = double(imnoise(I1,'salt & pepper', 0.05));

subplot(2,2,2);
imshow(mat2gray(Image));
title('Image bruitee par un bruit gaussien,M=0,V=0.01')

% Filtrage de Nagao
[m,n] = size(Image);
% Afin de pouvoir appliquer les fenetres sur les pixels des bords de l'image,
% on recopie par symetrie(miroir) les deux lignes et colonnes de chaque bord
% Image3 sera l'image sur laquelle on travaillera
Image2 = zeros(m,n+4);

Image2(:,[1 2]) = Image(:,[2 1]);
Image2(:,3:n+2) = Image(:,1:n);
Image2(:,[n+3 n+4]) = Image(:,[n n-1]);


Image3 = zeros(m+4,n+4);

Image3([1 2],:) = Image2([2 1],:);
Image3(3:m+2,:) = Image2(1:m,:);
Image3([m+3 m+4],:) = Image2([m m-1],:);

Imfin = zeros(m,n);

% On boucle sur chaque pixel de l'image originale
for k = 3:m+2
	for l = 3:n+2

% Creation des 9 fenetres autour du pixel considere ; chaque colonne
% de la matrice M contient les pixels d'une fenetre.
% A est la matrice 5x5 autour du pixel considere
		M = zeros(9,9);
		A = Image3((k-2):(k+2),(l-2):(l+2));

		M(:,1) = [A(1:5,1); A(2:4,2); A(3,3)];
		M(:,2) = [A(1,1:5), A(2,2:4), A(3,3)]';
		M(:,3) = [A(1:5,5); A(2:4,4); A(3,3)];
		M(:,4) = [A(5,1:5), A(4,2:4), A(3,3)]';
		M(:,5) = [A(1:3,1); A(1:3,2); A(1:3,3)];
		M(:,6) = [A(1:3,3); A(1:3,4); A(1:3,5)];
		M(:,7) = [A(3:5,1); A(3:5,2); A(3:5,3)];
		M(:,8) = [A(3:5,3); A(3:5,4); A(3:5,5)];
		M(:,9) = [A(2:4,2); A(2:4,3); A(2:4,4)];

% Le vecteur sigma contient les ecarts-type de chaque colonne de M
		sigma = std(M);

% On cherche a recuperer l'indice de la colonne qui a le plus petit ecart-type
		[minstd, minindice] = min(sigma);

% On remplace le pixel de Imfin (correspondant aux memes indices que le pixel de
% l'image de base) par la moyenne des pixels de le colonne de M qui a le plus
% petit ecart-type
		Imfin(k-2,l-2) = mean(M(:,minindice));
        
	end;
end;

subplot(2,2,3);
imshow(mat2gray(Imfin));
title('Image bruitee puis filtree par Nagao');

EQM = 1/(m*n)*sum(sum((Imfin - im2double(I1)).^2));
% une image où les composantes d'un pixel sont codées sur 8 bits, d=256
d = 256;
PSNR = 10*log10(d^2/EQM);

% Comparaison au filtrage par convolution

masque=1/25*[1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];
I_filtre=imfilter(double(Image),double(masque),'symmetric','same');

subplot(2,2,4);
imshow(mat2gray(I_filtre));
title('Image bruitee puis filtree par convolution')

EQM_filtre = 1/(m*n)*sum(sum((I_filtre - im2double(I1)).^2));
% une image où les composantes d'un pixel sont codées sur 8 bits, d=256
d_filtre = 256;
PSNR_filtre = 10*log10(d_filtre^2/EQM_filtre);
