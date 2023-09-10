%скрипт для обучения нейросети для запаса
% clear
%%
load zapas_chet_h % формирование массива для КВ_1
%%
t_ch_h(:,[2:5,8:30,32,38,41,43])=[];% остались только те, что в формуле,1 - Твоздуха, 6 - Рвых Шакяй = Рвх_Шакяй_Красн, 7 - Твых Шакяй = Твх_Шакяй Красн, 
% 31 - Рвых Шакяй Красн, 33 - Рвх Красн-140, 34 - Твх Красн-140, 35 - Рвых_Красн - 140, 36,37 - плотности, 39,40 - молярные массы, 42 - запас на ВК1
%%
t_z_kv1 = t_ch_h;
%%
t_z_kv_outl = t_z_kv1; % создаем вспомогательную переменную, чтобы потом посмотреть на графике выбросы
for i= 1:width(t_z_kv_outl) 
    t_z_kv_outl(:,i) = filloutliers(t_z_kv_outl(:,i),"previous","movmean",50);
end
%% рисуем выбросы
% figure
% plot(t_z_kv1(:,1)-t_z_kv_outl(:,1));
% title("");
% %%
% figure
% plot(t_z_kv1(:,2)-t_z_kv_outl(:,2));
% title("");
% %%
% figure
% plot(t_z_kv1(:,3)-t_z_kv_outl(:,3));
% title("");
% %%
% figure
% plot(t_z_kv1);
%%
t_z_kv1 = t_z_kv_outl; % снова присваиваем массив, в котором теперь удалены выбросы
%% нормируем данные, считаем матожидание и ско
for i = 1:width(t_z_kv1) % 
    m(i) = mean(t_z_kv1(1:end-1,i));
    s(i) = std(t_z_kv1(1:end-1,i));
end
%% нормируем данные
for i= 1:width(t_z_kv1) 
    t_z_kv1(:,i) = (t_z_kv1(:,i)- m(i))./s(i);
end
%% проверка нормирования, m1 = 0, s1 = 1
for i= 1:width(t_z_kv1) % 
    m1(i) = mean(t_z_kv1(1:end-1,i));
    s1(i) = std(t_z_kv1(1:end-1,i));
end
%% формируем строку ответов, это расход
y = t_z_kv1(:,12);
y_train = y(1:3500); % обучающая выборка для выходного параметра
y_test = y(3501:end);% тестовая выборка для выходного параметра
%% подали выходную переменную саму на себя, сдвинув на 1 шаг
t_z_kv1(1:end-1 ,12) = t_z_kv1(2:end,12); %% формируем обучающую и тестовую выборки
x_train = t_z_kv1(1:3500,:);% обучающая выборка для входного параметра
%%
plot(x_train');
title("x train");
%%
% figure
% plot(y_train');
% title("y train");
% 
% plot(x_train(:, 1)');
% title("");
% figure;
% plot(x_train(:, 2)');
% title("");
% figure;
% plot(x_train(:, 3)');
% title("");
%%
x_train = x_train';
y_train = y_train';
%%
x_test = t_z_kv1(3501:end,:);% тестовая выборка
%%
x_test = x_test';
y_test = y_test';
%%
layer = [sequenceInputLayer(12),lstmLayer(128),fullyConnectedLayer(1), regressionLayer];
%%
ops = trainingOptions("adam","Plots","training-progress",'MaxEpochs',100, "ValidationData", {x_test, y_test}, ...
    "InitialLearnRate", 0.01, "LearnRateSchedule", "piecewise", "LearnRateDropPeriod", 40, "LearnRateDropFactor", 0.3);
%%
net = trainNetwork(x_train, y_train, layer, ops);
%%
save net_zapas_kv_1 net;
%%
y_pred = predict(net,x_test);
difference = y_pred - y_test;
%%
rmse_before = sqrt(mean((difference).^2)); % Calculate the root-mean-square error (RMSE).
%%
% figure
% subplot(2,1,1)
% plot(y_test)
% hold on
% plot(y_pred,'.-')
% hold off
% legend(["Observed before" "Predicted_before"])
% ylabel("Cases")
% title("Forecast for test before")
% %%
% subplot(2,1,2)
% stem(y_pred - y_test)
% xlabel("Month")
% ylabel("Error")
% title("RMSE before = " + rmse_before)
%%
net = resetState(net);% Сброс состояния сети предотвращает влияние предыдущих прогнозов на прогнозы новых данных. 
net = predictAndUpdateState(net,x_train); % затем инициализируйте состояние сети, предсказав обучающие данные.
%% Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step. 
y_pred = [];
for k = 1:length(x_test)
    [net,y_pred(:,k)] = predictAndUpdateState(net,x_test(:,k));
end
%%
save net_zapas_kv_1 net;
%%
difference1 = y_pred - y_test;
%%
rmse1 = sqrt(mean((difference1).^2)); % Calculate the root-mean-square error (RMSE).
%%
% figure
% subplot(2,1,1)
% plot(y_test)
% hold on
% plot(y_pred,'*')
% hold off
% legend(["Observed" "Predicted"])
% ylabel("Cases")
% title("Forecast with Updates")
% %%
% subplot(2,1,2)
% stem(y_pred - y_test)
% xlabel("Month")
% ylabel("Error")
% title("RMSE = " + rmse1)