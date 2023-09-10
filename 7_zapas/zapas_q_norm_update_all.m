%скрипт для обучения нейросети для запаса
clear
%%
% load zapas
t_z = readmatrix('Zapas_data.xlsx');
%%
% t_z(:,1) = sin(t_z(:,1)/24*2*pi); % замена дней на синус дней
% t_z(:, end+1) = sin((1:numel(t_z(:,1)))/numel(t_z(:,1))*2*pi);%добавили строку, означающую месяц и взяли сиинус
% теперь в "х" последняя строка - синус месяца
%%
t_z(:,[1]) = []; % удаляем ненужные столбцы на входе. Было 1-часы, 2-ВК, 3-ВК-2, 4-Запас сумма
% стало 1-ВК, 2-ВК-2, 3-Запас сумма
%%
t_z1 = t_z; % создаем вспомогательную переменную, равную t1, чтобы потом посмотреть на графике выбросы
for i= 1:width(t_z1) 
    t_z1(:,i) = filloutliers(t_z1(:,i),"previous","movmean",50);
end
%% рисуем выбросы
% figure
% plot(t_z(:,1)-t_z1(:,1));
% title("ВК выбросы");
% %%
% figure
% plot(t_z(:,2)-t_z1(:,2));
% title("ВК-1 выбросы");
% %%
% figure
% plot(t_z(:,3)-t_z1(:,3));
% title("Запас сумма выбросы");
%%
figure
plot(t_z);
%%
t_z = t_z1; % снова присваиваем массив, в котором теперь удалены выбросы
%% нормируем данные, считаем матожидание и ско
for i = 1:width(t_z) % 
    m(i) = mean(t_z(1:end-1,i));
    s(i) = std(t_z(1:end-1,i));
end
%% нормируем данные
% t1(:,i) = sin(t1(:,i)/24*2*pi)
for i= 1:width(t_z) 
    t_z(:,i) = (t_z(:,i)- m(i))./s(i);
end
%% проверка нормирования, m1 = 0, s1 = 1
for i= 1:width(t_z) % 
    m1(i) = mean(t_z(1:end-1,i));
    s1(i) = std(t_z(1:end-1,i));
end
%% формируем строку ответов, это расход
y = t_z(:,3);
y_train = y(1:3500); % обучающая выборка для выходного параметра
y_test = y(3501:end);% тестовая выборка для выходного параметра
%% подали выходную переменную саму на себя, сдвинув на 1 шаг
t_z(1:end-1 ,3) = t_z(2:end,3); %% формируем обучающую и тестовую выборки
x_train = t_z(1:3500,:);% обучающая выборка для входного параметра
%%
plot(x_train);
title("x train");
figure
plot(y_train);
title("y train");
%%
plot(x_train(:, 1));
title("ВК");
figure;
plot(x_train(:, 2));
title("ВК-1");
figure;
plot(x_train(:, 3));
title("Запас сумма");
%%
x_train = x_train';
y_train = y_train';
%%
x_test = t_z(3501:end,:);% тестовая выборка
%%
x_test = x_test';
y_test = y_test';
%%
layer = [sequenceInputLayer(3),lstmLayer(128),fullyConnectedLayer(1), regressionLayer];
%%
ops = trainingOptions("adam","Plots","training-progress",'MaxEpochs',100, "ValidationData", {x_test, y_test}, ...
    "InitialLearnRate", 0.01, "LearnRateSchedule", "piecewise", "LearnRateDropPeriod", 40, "LearnRateDropFactor", 0.3);
%%
net = trainNetwork(x_train, y_train, layer, ops);
%%
save net_zapas net;
%%
y_pred = predict(net,x_test);
difference = y_pred - y_test;
%%
rmse_before = sqrt(mean((difference).^2)); % Calculate the root-mean-square error (RMSE).
%%
figure
subplot(2,1,1)
plot(y_test)
hold on
plot(y_pred,'.-')
hold off
legend(["Observed before" "Predicted_before"])
ylabel("Cases")
title("Forecast for test before")
%%
subplot(2,1,2)
stem(y_pred - y_test)
xlabel("Month")
ylabel("Error")
title("RMSE before = " + rmse_before)
%%
net = resetState(net);% Сброс состояния сети предотвращает влияние предыдущих прогнозов на прогнозы новых данных. 
net = predictAndUpdateState(net,x_train); % затем инициализируйте состояние сети, предсказав обучающие данные.
%% Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step. 
y_pred = [];
for k = 1:length(x_test)
    [net,y_pred(:,k)] = predictAndUpdateState(net,x_test(:,k));
end
%%
% figure 
difference1 = y_pred - y_test;
%%
rmse1 = sqrt(mean((difference1).^2)); % Calculate the root-mean-square error (RMSE).
%%
figure
subplot(2,1,1)
plot(y_test)
hold on
plot(y_pred,'*')
hold off
legend(["Observed" "Predicted"])
ylabel("Cases")
title("Forecast with Updates")
%%
subplot(2,1,2)
stem(y_pred - y_test)
xlabel("Month")
ylabel("Error")
title("RMSE = " + rmse1)