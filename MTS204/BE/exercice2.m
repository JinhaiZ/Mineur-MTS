%%Exercice 1
%% question1
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