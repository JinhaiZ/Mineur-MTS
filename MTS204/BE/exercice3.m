%%Exercice 3
%% question I
masque=[-1 0 1; -2 0 2; -1 0 1];
pause 
%1. Calculer la fonction de transfert de ce filtre 2D et reponse frequentielle
% [H,Fx,Fy] = freqz2(h,Nx,Ny)
[H,f1,f2]=freqz2(masque,32,32);
figure();
mesh(f1,f2,abs(H));
surf(f1,f2,abs(H));
xlabel('Frequence');
ylabel('Frequence');
title('Reponse frequentielle du masque H')'

pause
masque1=[1;
         2;
         1];
[H1,f1,f2]=freqz2([1 2 1],32,32);
figure();
mesh(f1,f2,abs(H1));
surf(f1,f2,abs(H1));
xlabel('Frequence');
ylabel('Frequence');
title('Reponse frequentielle du masque H1 (vertical)');


ff1 = -pi:(2*pi)/256:pi;
[HH1,ff1]=freqz([1 2 1],1,ff1,'whole');
figure();
plot(ff1/pi,abs(HH1));
xlabel('Frequence');
ylabel('Frequence');
title('Reponse frequentielle du masque H1 (vertical)');

pause
masque2=[-1 0 1 ];
[H2,f1,f2]=freqz2(masque2,32,32);
figure();
mesh(f1,f2,abs(H2));
surf(f1,f2,abs(H2));
xlabel('Frequence'); 
ylabel('Frequence');
title('Reponse frequentielle du masque H2 (horizontal)');

ff1 = -pi:(2*pi)/256:pi;
[HH1,ff1]=freqz([-1 0 1],1,ff1,'whole');
figure(); 
plot(ff1/pi,abs(HH1));
xlabel('Frequence');
ylabel('Frequence');
title('Reponse frequentielle du masque H2 (horizontal)')
pause

%verification de la commutativitï¿? de la convolution
masquebis=conv2(masque1,masque2,'full')
masqueter=conv2(masque2,masque1,'full')
%% question II
%% question 1
%verifier que le masque de la question I est separable
I=[0 0 0 0 0 5 5 5 5 5 5;
   0 0 0 0 0 5 5 5 5 5 5;
   0 0 0 0 0 5 5 5 5 5 5;
   0 0 0 0 0 5 5 5 5 5 5; 
   0 0 0 0 0 5 5 5 5 5 5; 
   0 0 0 0 0 5 5 5 5 5 5; 
   0 0 0 0 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 0 0 0 0];
figure();
subplot(2,3,1);
imshow(mat2gray(I));
title('Image orignal');
% vérification de masques1 puis masque2 est équivalent ? masque 2 puis
% masque 1
% Convolution de I par le masque1 passe-bas
subplot(2,3,2);
imshow(mat2gray(image1));
image1=conv2(I,masque1,'valid');
title('Image orignal par le masque1 passe-bas');

% puis par le masque2 passe-haut
subplot(2,3,3);
imshow(mat2gray(image2));
image2=conv2(image1,masque2,'valid');
title('Image orignal par le masque2 passe-haut');


% Convolution de I par le masque2 passe-haut
subplot(2,3,5);
imshow(mat2gray(image2prim));
image2prim=conv2(I,masque2,'valid');
title('Image orignal par le masque2 passe-haut');
% puis par le masque1 passe-bas
subplot(2,3,6);
imshow(mat2gray(image1prim));
image1prim=conv2(image2prim,masque1,'valid');
title('Image orignal par le masque1 passe-bas');
%% question 2
% Que realise ce filtre 2D?
% utilisation direct de masque
%convolution par le masque total : extraction du contour vertical
figure();
subplot(2,3,1);
imshow(mat2gray(I));
title('Image orignal');

masque=[-1 0 1; -2 0 2; -1 0 1];
image2bis=conv2(I,masque,'valid');
subplot(2,3,2);
imshow(mat2gray(image2bis));
title('Extraction du contour vertical');

%convolution par le masque total : extraction du contour horizontal
masque';
image2bis=conv2(I,masque','valid');
subplot(2,3,3);
imshow(mat2gray(image2bis));
title('Extraction du contour horizontal');

I=[5 5 5 5 5 5 5 5 5 5 5;
   5 5 5 5 5 5 5 5 5 5 0;
   5 5 5 5 5 5 5 5 5 0 0;
   5 5 5 5 5 5 5 5 0 0 0; 
   5 5 5 5 5 5 5 0 0 0 0; 
   5 5 5 5 5 5 0 0 0 0 0; 
   5 5 5 5 5 0 0 0 0 0 0;
   5 5 5 5 0 0 0 0 0 0 0;
   5 5 5 0 0 0 0 0 0 0 0;
   5 5 0 0 0 0 0 0 0 0 0;
   5 0 0 0 0 0 0 0 0 0 0]

% utilisation direct de masque
%convolution par le masque total : extraction du contour vertical
subplot(2,3,4);
imshow(mat2gray(I));
title('Image orignal');

masque;
image2bis=conv2(I,masque,'valid');
subplot(2,3,5);
imshow(mat2gray(image2bis));
title('Extraction du contour vertical');

%convolution par le masque total : extraction du contour horizontal
masque';
image2bis=conv2(I,masque','valid');
subplot(2,3,6);
imshow(mat2gray(image2bis));
title('Extraction du contour horizontal');
%%

% application du masque a une image reelle

figure();
load trees;  I = ind2gray(X,map);

%I = imread('cameraman.tif');
%I = imread('coins.png');
%I = imread('testpat1.png');
%I = imread('westconcordorthophoto.png');

imshow(mat2gray(I))
pause

%convolution par le masque total (contours verticaux)

image1=conv2(I,masque,'same');
figure();
colorbar
imshow(image1,[min(min(image1)) max(max(image1))])
colorbar;
pause

%convolution par le masque total (contours horizontaux)

image2=conv2(I,masque','same');
figure();
colorbar;
imshow(image2, [min(min(image2)) max(max(image2))])
colorbar;
%pause

%visualisation de tous les contours
%image3 = ?
%figure(7)
%imshow(image3, [min(min(image3)) max(max(image3))])
%colorbar;