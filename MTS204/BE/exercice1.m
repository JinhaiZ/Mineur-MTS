%%Exercice 1
%% question 1 & 2
clear all
masque=1/3*[0 1/2 0; 1/2 1 1/2; 0 1/2 0];

%1. Calculer la fonction de transfert de ce filtre 2D et reponse frequentielle
[H,f1,f2]=freqz2(masque,32,32);
figure;
mesh(f1,f2,abs(H));
surf(abs(H));
xlabel('Frequence');
ylabel('Frequence');
zlabel('Gain');
title('Reponse frequentielle du filtre');

%% question 3
% G()=F()*H()

%% question 4 
% un filtre passe bas. Il a pour effet de lisser l’information

%% question 5
%choisir une images
load trees ; I_original = ind2gray(X,map);
subplot(1,3,1);
imshow(mat2gray(I_original))
title('Image originale');
%% question 5
%choisir un type de bruit
I_bruite = double(imnoise(I_original,'gaussian',0,0.01));
%I_bruite = double(imnoise(I_original,'salt & pepper', 0.05));

subplot(1,3,2);
imshow(mat2gray(I_bruite))
title('Image bruitee');
%% question 6
%convolution par le masque total

%I_filtre=double(conv2(double(I_bruite),double(masque),'full'));
I_filtre=double(imfilter(double(I_bruite),double(masque),'symmetric','same'));
subplot(1,3,3);
imshow(mat2gray(I_filtre))
title('Image filtree');
