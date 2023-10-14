clear
%%
load x_9
load temper
load data_zelenograds
load data_Kaliningrad_1
load data_Kaliningrad_2
load data_sovetsk %соединенный
load dataGIS
load data_tec2
%% конкатенируем температуру и Х
for i = 1:4
    x{i} = [t1';x{i}]; %'
end
%%
x{5} = [t1(1:idx_1,2)';x{5}]; %
x{5} = [t1(1:idx_1,1)';x{5}]; %
x{6} = [t1(idx_2:end,2)';x{6}]; %
x{6} = [t1(idx_2:end,1)';x{6}]; %
x{7} = [t1(1:idx_3,2)';x{7}]; %
x{7} = [t1(1:idx_3,1)';x{7}]; %
x{8} = [t1(idx_4:end,2)';x{8}]; %
x{8} = [t1(idx_4:end,1)';x{8}]; %
x{9} = [t1(1:idx_3_1,2)';x{9}]; %
x{9} = [t1(1:idx_3_1,1)';x{9}]; %
x{10} = [t1(idx_3_2+1:idx_3_3,2)';x{10}]; %
x{10} = [t1(idx_3_2+1:idx_3_3,1)';x{10}]; %
x{11} = [t1(idx_3_4+1:idx_3_5,2)';x{11}]; %
x{11} = [t1(idx_3_4+1:idx_3_5,1)';x{11}]; %
x{12} = [t1(idx_3_6:end,2)';x{12}]; %
x{12} = [t1(idx_3_6:end,1)';x{12}]; %
x{13} = [t1(1:idx_5_1,2)';x{13}]; %
x{13} = [t1(1:idx_5_1,1)';x{13}]; %
x{14} = [t1(idx_5_2:end,2)';x{14}]; %
x{14} = [t1(idx_5_2:end,1)';x{14}]; %
x{15} = [t1(1:idx_8_1,2)';x{15}]; %
x{15} = [t1(1:idx_8_1,1)';x{15}]; %
x{16} = [t1(idx_8_2:end,2)';x{16}]; %
x{16} = [t1(idx_8_2:end,1)';x{16}]; %
%% можно удалить какие-то переменные на входе
for i = 1:numel(x)-2 % для грс
    x{i}([4,6],:) = []; % удаляем переменные на входе. 1 - Часы, 2 - Т возд, 3-Рвх, 4 - Рвых, 5 - Твых, 6 - Q Расход
end
%%
for i = numel(x)-1:numel(x) % для гис
    x{i}([2,3],:) = []; % удаляем переменные на входе. 1 - Часы, 2 - Т возд, 3-Рвх, 4 - Рвых, 5 - Твых, 6 - Q Расход
end
%%
x{17} = [t1,t9]';
%%
for i = 1:numel(x)
    x{i}(1,:) = sin(x{i}(1,:)/24*2*pi);% замена дней на синус дней
    x{i}(end+1,:) = sin((1:numel(x{i}(1,:)))/numel(x{i}(1,:))*2*pi);%добавили строку, означающую месяц и взяли сиинус
end

%% формируем строку ответов, это расход
for i = 1:numel(x)
     y{i} = x{i}(5,1:end);
end
%% подали выходную переменную саму на себя, сдвинув на 1 шаг
for i = 1:numel(x)
    x{i}(5,1:end-1) = x{i}(5,2:end);
    %было x{i} = [x{i}(:,2:end)];
end
%% формируем обучающую и тестовую выборки, сначала берем первые 3 ячейки целиком,потому что в 4-й будем отделять часть данных для тестовой выборки
x_train = x(1:16);% обучающая выборка для входного параметра, первые 3 ГРС
y_train = y(1:16); % обучающая выборка для выходного параметра, первые 3 ГРС
%%
N_split = 8000;
x_train{17} = x{17}(:,1:N_split);% обучающая выборка для входного параметра, часть из 4 ГРС
y_train{17} = y{17}(1:N_split); % обучающая выборка для выходного параметра, часть из 4 ГРС

x_test = x{17}(:,N_split+1:end);
y_test = y{17}(N_split+1:end); 
%% Получаем параметры нормировки
m = zeros(4,numel(x_train)); s = m;
for i=1:numel(x_train)% число ячеек - грс в массиве х
    %for j = 2:5  % число нормируемых входных  переменных в каждой грс в массиве x_train
    m(:,i) = mean(x_train{i}(2:5,:),2);
    s(:,i) = std(x_train{i, 1}(2:5,:),[],2);
    %end
end
%% Нормировка x_train
for i=1:numel(x_train)% число ячеек - грс в массиве х
    for j = 2:5 % число нормируемых строк-входных  переменных в каждой грс в массиве х
    x_train{i, 1}(j,1:end) = (x_train{i, 1}(j,1:end) - m(j))./s(j);
    end
end
%% Нормировка x_test
for j = 2:5 % число нормируемых строк-входных  переменных в каждой грс в массиве х
    x_test(j,1:end) = (x_test(j,1:end) - m(j))./s(j);
end
%% Параметры для y
for i=1:numel(y_train)% число ячеек - грс в массиве х
    m_y(i) = mean(y_train{i});
    s_y(i) = std(y_train{i});
end
%% Нормировка y_train
% for i=1:numel(y_train)% число ячеек - грс в массиве х
%     y_train{i} = (y_train{i}-m_y(i))/s_y(i);
% end
% %% Нормировка y_test
% y_test = (y_test-m_y(17))/s_y(17);
%% Валидация: случайным образом из 16 временных рядов: 
n_split = 0.8; % 80% данных на обучение и 20% на валидацию
rng(1) % генератор случайных чисел - для повторяемости
n = randi([1,16]); % генерируем случайное число между 1 и 16 
n_val = numel(y_train{n}); % количество элементов в train
n_train = round(n_val*n_split);

x_val = x_train{n}(:,n_train+1:end);
x_train{n} = x_train{n}(:,1:n_train);

y_val = y_train{n}(n_train+1:end);
y_train{n} = y_train{n}(:,1:n_train);
%%
figure
plot(x_train{1}');
title("Краснонаменск x-train");
legend("Часы", "Т возд", "Рвх", "Твх", "Расход - 1 час", "Номер ГРС"," ", " "," "," ", " ", " ", " ", "синус месяца");
% figure
% plot(x_train{10}');
% title("Калиниград 2 x train");
% legend("Часы", "Т возд", "Рвх", "Твх", "Расход - 1 час", " ", "Номер ГРС"," "," "," ", " ", " ", " ", "синус месяца");
% figure
% plot(x_train{11}');
% title("Калиниград 2 x train");
% legend("Часы", "Т возд", "Рвх", "Твх", "Расход - 1 час", " ", "Номер ГРС"," "," "," ", " ", " ",  " ","синус месяца");
figure
plot(x_train{17}');
title("ТЭЦ x train");
legend("Часы", "Т возд", "Рвх", "Твх", "Расход - 1 час", " ", "Номер ГРС"," "," "," ", " ", " ", " ", "синус месяца");
%%
x_train = x_train';
y_train = y_train';
% %%
% x_test = x{17}(:,8001:end);% тестовая выборка, вторая часть из 4 ГРС
% y_test = y{17}(8001:end);% тестовая выборка для выходного параметра
%%
plot(x_test');
title("ТЭЦ x test");
legend("Часы", "Т возд", "Рвх", "Твх", "Расход - 1 час", " ", " "," "," ", " ", " "," ", "Номер ГРС", "синус месяца");
%%
plot(y_test);
title("ТЭЦ y test");
%%
layer = [sequenceInputLayer(16), lstmLayer(128),fullyConnectedLayer(1), regressionLayer];
% load net_gts_all.mat
%%
ops = trainingOptions("adam","Plots","training-progress",'MaxEpochs',250, "ValidationData", {x_val, y_val}, ...
    "InitialLearnRate", 0.01, "LearnRateSchedule", "piecewise", "LearnRateDropPeriod", 100, "LearnRateDropFactor", 0.3,'MiniBatchSize', 1);
%%
net = trainNetwork(x_train, y_train, layer, ops);
%%
save net_gts_all net;
%%
y_pred = predict(net,x_test);
% plot(y_pred)
% hold on
% plot(y_test)
% title("Forecast with test before")
% %%
% figure 
difference = y_pred - y_test;
% plot(difference);
% title("Difference for test before")
%%
% y_pred_all = predict(net,x);
% figure 
% plot(y_pred_all{end});
% hold on
% plot(y{end});
% title("Forecast all before")
%%
rmse_before = sqrt(mean((difference).^2))/m_y(17); % Calculate the root-mean-square error (RMSE).
%%
figure
subplot(2,1,1)
plot(y_test)
hold on
plot(y_pred,'.-')
hold off
legend(["ТЭЦ Observed before" "ТЭЦ Predicted before"])
ylabel("Cases")
title("ТЭЦ Forecast for test before")
%%
subplot(2,1,2)
stem(y_pred - y_test)
xlabel("Month")
ylabel("Error")
title("RMSE before = " + rmse_before)
%%
net = resetState(net);% Сброс состояния сети предотвращает влияние предыдущих прогнозов на прогнозы новых данных. 
net = predictAndUpdateState(net,x_train,'MiniBatchSize', 1); % затем инициализируйте состояние сети, предсказав обучающие данные.
%% Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step. 
y_pred = [];
for k = 1:length(x_test)
    [net,y_pred(:,k)] = predictAndUpdateState(net,x_test(:,k),'MiniBatchSize', 1);
end
%% 
% y_pred = predict(net,x_test);
% figure
% plot(y_pred)
% hold on
% plot(y_test)
%%
% figure 
difference = y_pred - y_test;
% plot(difference);
%%
% y_pred_all = predict(net,x);
% figure 
% plot(y_pred_all{end});
% hold on
% plot(y{end});
%%
rmse = sqrt(mean((difference).^2))/m_y(17); % Calculate the root-mean-square error (RMSE).
%%
figure
subplot(2,1,1)
plot(y_test)
hold on
plot(y_pred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("Cases")
title("Forecast with Updates")
%%
subplot(2,1,2)
stem(y_pred - y_test)
xlabel("Month")
ylabel("Error")
title("RMSE = " + rmse)