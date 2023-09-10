%скрипт для обучения нейросети для предсказаний
clear
%%
D_1 = readtable('Разметка с КС длительность.xls');
D_2 = readtable('Разметка с КС длительность.xls');
%%
Q = D{:,4};
%%
n = 1:numel(Q);
p = polyfit(n,Q,9);
Q_model = polyval(p,n);
Q_new = Q - Q_model';
%%
% plot(Q);
% hold on
% plot(Q_new);
%%
P_in = D{:,1};
n1 = 1:numel(P_in);
p1 = polyfit(n1,P_in,9);
P_in_model = polyval(p1,n1);
P_in_new = P_in - P_in_model';
%%
% plot(P_in);
% hold on
% plot(P_in_new);
%%
P_out = D{:,2};
n2 = 1:numel(P_out);
p2 = polyfit(n2,P_out,1);
P_out_model = polyval(p2,n2);
P_out_new = P_out  - P_out_model';
%%
% plot(P_out );
% hold on
% plot(P_out_new);
%%
T_out = D{:,3};
n3 = 1:numel(T_out);
p3 = polyfit(n3,T_out,9);
T_out_model = polyval(p3,n3);
T_out_new = T_out  - T_out_model';
%%
% plot(T_out );
% hold on
% plot(T_out_new);
%%
P_ks = D{:,5};
n5 = 1:numel(P_ks);
p5 = polyfit(n5,P_ks,6);
P_ks_model = polyval(p5,n5);
P_ks_new = P_ks - P_ks_model';
%%
% plot(P_ks);
% hold on
% plot(P_ks_new);
%%
Y = categorical(D{:,end});
X = D{:,1:end-1};
%%
X(:,1) = P_in_new;
X(:,2) = P_out_new;
X(:,3) = T_out_new;
X(:,4) = Q_new;
X(:,5) = P_ks_new;
%% нормируем данные, считаем матожидание и ско
for i = 1:5 % 
    m(i) = mean(X(1:end-1,i));
    s(i) = std(X(1:end-1,i));
end
%% нормируем данные
for i= 1:5 
    X(:,i) = (X(:,i)- m(i))./s(i);
end
%% проверка нормирования, m1 = 0, s1 = 1
for i= 1:5 % 
    m1(i) = mean(X(1:end-1,i));
    s1(i) = std(X(1:end-1,i));
end
%% формируем обучающую и тестовую выборки
N = size(Y); % сколько всего данных
N_train = round(N * 0.8);
N_test = N-N_train;
x_train = X(1:N_train,:)';
y_train = Y(1:N_train)';
x_test = X(N_train+1:end,:)';
y_test = Y(N_train+1:end)';
%%
classes = ["0" "1" "2" "3"];
%%
YY = D{:,end};
%%
W_1 = sum(YY)/size(YY,1); % процентное соотношение единиц (аномалий)
%  ввести веса для каждого класса, обратную этой величине в строке 95
W_2 = 
%%
classWeights = [1-W 1-W W W];
clayer = classificationLayer( ...
    'Classes',classes, ...
    'ClassWeights',classWeights);
%%
layer = [sequenceInputLayer(9), lstmLayer(128),fullyConnectedLayer(4), softmaxLayer, clayer];
%%
ops = trainingOptions("adam","Plots","training-progress",'MaxEpochs',100, "ValidationData", {x_test, y_test}, ...
    "InitialLearnRate", 0.01, "LearnRateSchedule", "piecewise", "LearnRateDropPeriod", 40, "LearnRateDropFactor", 0.3);
%%
net = trainNetwork(x_train, y_train, layer, ops);
%%
% save net_anomaly net;
%%
y_pred = predict(net,x_test);
figure
plot(y_pred');
%%
y_pred_train = predict(net,x_train);
hold off
plot(y_pred_train');
%%
o = zeros(size(y_test));
o(y_pred(2,:)>0.5) = 1; % 
cm1 = confusionchart(y_test, categorical(o));
%%
figure
yyaxis left
plot(D{N_train+1:end,4});
%%
yyaxis right
plot(y_pred(2,:));
hold on
plot(double(y_test)-1,'k');
%%
% как предсказывать заранее?
% confusionmat(y_test,y_pred_test);
% cm = confusionchart(y_test, y_pred);
% regression - как соединить с предыдущей lstm?
% как автоматически размечать уровни, программно, иметь возможность менять уровни?
% как детектировать 3 уровня, большое, маленькое, среднее отклонение?
% как соединить 3 критерия - величина, длительность, скорость?
% как можно объяснить? как вывести в соответствие другие входные параметры?
% как соединить с anfis?
% imbalance levels - как вывести на экран?