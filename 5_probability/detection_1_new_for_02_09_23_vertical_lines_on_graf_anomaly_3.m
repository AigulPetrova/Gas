%скрипт для обучения нейросети для ГРС
% clear
%%
load data
load temper
%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "Лист1";
opts.DataRange = "A1:A8760";

% Specify column names and types
opts.VariableNames = "VarName1";
opts.VariableTypes = "char";

% Specify variable properties
opts = setvaropts(opts, "VarName1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName1", "EmptyFieldRule", "auto");

% Import the data
Date1 = readtable("C:\Users\user\MATLAB Drive\1Exponenta\24.06 predictions\Date2.xlsx", opts, "UseExcel", false);

% Convert to output type
Date1 = table2cell(Date1);
numIdx = cellfun(@(x) ~isnan(str2double(x)), Date1);
Date1(numIdx) = cellfun(@(x) {str2double(x)}, Date1(numIdx));

% Clear temporary variables
clear numIdx opts
%% нормируем данные, считаем матожидание и ско
for i=1:numel(x)% число ячеек - грс в массиве х
    for j = 1:3 % число строк-входных  переменных в каждой грс в массиве х
    m(i,j) = mean(x{i, 1}(j,1:end-1));
    s(i,j) = std(x{i, 1}(j,1:end-1));
    end
end
%% нормируем данные
for i=1:numel(x)
    for j = 1:3 % число строк-входных  переменных в каждой грс в массиве х
    x{i, 1}(j,:) = (x{i, 1}(j,1:end)- m(i,j))./s(i,j);
    end
end
%% проверка нормирования, m1=0, s1=1
for i=1:numel(x)% число ячеек - грс в массиве х
    for j = 1:3 % число строк-входных  переменных в каждой грс в массиве х
    m1(i,j) = mean(x{i, 1}(j,1:end-1));
    s1(i,j) = std(x{i, 1}(j,1:end-1));
    end
end
%% формируем строку ответов, это расход
for i = 1:numel(x)
     y{i} = x{i}(4,1:end);
end
%% подали выходную переменную саму на себя, сдвинув на 1 шаг
for i = 1:numel(x)
    x{i}(4,1:end-1) = [x{i}(4,2:end)];
    %было x{i} = [x{i}(:,2:end)];
end
%% формируем обучающую и тестовую выборки, сначала берем первые 3 ячейки целиком,потому что в 4-й будем отделять часть данных для тестовой выборки
% из 4-й ячейки часть оставляем на обучающую выборку
% x_train = x{(1:3)};% обучающая выборка для входного параметра, первые 3 ГРС
% y_train = y{(1:3)}; % обучающая выборка для выходного параметра, первые 3 ГРС
% %%
% n_x_train = 8000;
% x_train = [x_train'; x{4}(:,1:n_x_train)'];% обучающая выборка для входного параметра, часть из 4 ГРС
% y_train = [y_train'; y{4}(1:n_x_train)']; % обучающая выборка для выходного параметра, часть из 4 ГРС
% %%
% x_train = x_train';
% y_train = y_train';
% %%
% x_test = x{4}(:,n_x_train+1:end);% тестовая выборка, вторая часть из 4 ГРС
% y_test = y{4}(n_x_train+1:end);% тестовая выборка для выходного параметра, вторая часть из 4 ГРС
%%
% load net_grs
load net_gts_all
%%
i=1; % это номер ГРС
x_test = x{i};
y_test = y{i};
%% Predict on each time step. For each prediction, predict the next time step using the observed value of the previous time step.
C_1 = cell(1);
kk = 0;
y_pred = [];
dur = 0;
n = 0;
l = 0;
tr_jump = 0.25;
tr_dur = 3;
ii = 0;
Y_pred = predict(net,x_test);
anomaly = Y_pred(2:end) - y_test(1:end-1);
f = figure;
f.Position = [0,0,1000,1000];
ax = axes;
p = plot(ax,anomaly);
title("Аномалии");
hold on
%% поменять 
temp = false;
SPEED = [];
for k = 1:length(x_test)
    [net,y_pred(:,k)] = predictAndUpdateState(net,x_test(:,k));
    if k > 1 
        a = abs(y_test(k-1) - y_pred(k));
        speed = y_pred(k) - y_test(k-1); % скорость на текущем шаге
        if a > tr_jump       
            temp = true;
            C_1{kk+1}{1} = SPEED;
            C_1{kk+1}{2} = dur;
            C_1{kk+1}{3} = a;
            kk = kk + 1;
        end
        if temp % пока есть аномалия
            if dur == 0
                n = n + 1; % если это новая аномалия, то присваиваем новый номер    
            end
                dur = dur + 1;
                SPEED = [SPEED, speed];
                temp = false;
                disp("Отклонение,"  + " " + "индекс" + " " + string(k) + " " + "номер" + " " + string(n) + " " + "значение" + " " + a)
                disp("Продолжительность отклонения" + " " + string(dur) + " " + "ч.")
                disp("Скорость нарастания отклонения")
                disp(SPEED)
                if dur >= tr_dur
                    if n > l 
                            figure
                            plot(SPEED);
                            title("Отклонение,"+ " " + "индекс" + " " + string(k) + " " + "номер" + " " + string(n) + " " + "значение" + " " + a, "Скорость" + " " + SPEED + " " + "Продолжительность" + " " + string(dur) + " " + "ч.");
                            t = ax.YLim;
                            plot(ax,[k,k], t, "k-.");
                            T = text(ax, k, 0.5+ii/10, "Отклонение номер" + string(n));
                            ii = ii + 1;
                            date_1 = Date1{n_x_train + k};
                            day_1 = date_1(1:2);
                            month_1 = date_1(4:7);
                            hour_1 = t1(n_x_train+k,1);
                            T.String = "Отклонение номер" + " " + string(n) + " " + "длительность" + " " + string(dur) + " " + "ч." + newline + "Дата" + " " + day_1 + " " + month_1 + " " + "время" + " " + string(hour_1) + " " + "ч."; 
                            T.FontSize = 8;
                            plot(ax, [k-1,k],[y_pred(k-1) - y_test(k-2), y_pred(k) - y_test(k-1)], "r", "LineWidth", 3);
                            pause(1) % секунда
                            drawnow
                            l = l + 1;
                    else 
                            hold on
                            plot(SPEED);
                            title("Отклонение,"+ " " + "индекс" + " " + string(k) + " " + "номер" + " " + string(n) + " " + "значение" + " " + a, "Скорость" + " " + SPEED + " " + "Продолжительность" + " " + string(dur) + " " + "ч.");
                            t = ax.YLim;
                            plot(ax,[k,k], t, "k-.");
                            T = text(ax, k, 0.5+ii/10, "Отклонение номер" + string(n));
                            ii = ii + 1;
                            date_1 = Date1{n_x_train + k};
                            day_1 = date_1(1:2);
                            month_1 = date_1(4:7);
                            hour_1 = t1(n_x_train+k,1);
                            T.String = "Отклонение номер" + " " + string(n) + " " + "длительность" + " " + string(dur) + " " + "ч." + newline + "Дата" + " " + day_1 + " " + month_1 + " " + string(hour_1) + " " + "ч." ; 
                            T.FontSize = 8; 
                            plot(ax, [k-1,k],[y_pred(k-1) - y_test(k-2), y_pred(k) - y_test(k-1)], "r", "LineWidth", 3);
                            pause(1) % секунда
                            drawnow
                            l = l + 1;
                    end
                end
        else SPEED = [];
              dur = 0;
              l = n;
        end % цикл temp
     end % цикл k > 1
end % цикл k
%% 
% anomaly = y_pred(2:end) - y_test(1:end-1); figure plot(anomaly); title("Аномалии");
% 
% hold on t = axis; %% plot([20,20],t(3:4)); %% T = text(20,y_test(20),"Отклонение" 
% + string(1)); T.String = "ура = " + string(dur); 
% 
% idx = find(anomaly_jump); %индексы аномалий
% 
% y_pred = predict(net,x_test); figure plot(y_pred) hold on plot(y_test)
% 
% figure difference = y_pred - y_test; plot(difference); %% y_pred_all = predict(net,x); 
% figure plot(y_pred_all{end}); hold on plot(y{end});
%% Визуал:
% бегунки на пороги+ как показать точки отклонений на графике измерений (аномалий) 
% как показать дату вместо индекса?(что подготовить?) как замедлить показ скорости 
% (сделать как бы режим реального времени) и что можно еще с ней сделать? как 
% показывать нарастающий итог длительности и скорости по каждому отклонению+ как 
% указать нарастающий итог количества отклонений?+ как не печатать если скорость 
% = 0 (а то выводится пустой график)?
%% Данные
% как генерировать фальшивые отклонения как оценить вероятностные характеристики 
% обнаружившегося отклонения? нарастает или нет скорость - как указать (ускорение)?+ 
% как убрать суточные пики (и надо ли)? как обнаружить тренд? может быть надо 
% убрать нормирование? надо ли resetState как детектировать 3 уровня, большое, 
% маленькое, среднее отклонение? как соединить 3 критерия - по трем уровням?
%% Смыслы
% как можно объяснить? как вывести в соответствие другие входные параметры? 
% imbalance levels - как просуммировать отклонения и вывести на экран? как посчитать 
% весь баланс в ГТС и сравнить с суммой выявленных отклонений? можно ли сделать 
% нейросеть для баланса сразу всей ГТС? как соединить с anfis? как соединить с 
% формулой баланса? как сделать регрессию запаса? почему не надо делать validation? 
% как соединить с моделью управления? ПФ, матрица состояний и пр.? как перенести 
% в питон Ии Темпоральная логика, dur Модель Перенести в питон Валидэйшн Знакомые 
% по Н чёткой логике Sequence to sequence Квантовые нейронные сети Вероятностные 
% характеристики