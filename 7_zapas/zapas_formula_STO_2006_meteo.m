%скрипт для обучения нейросети для запаса
clear
%%
load zapas_formula_grunti % формирование массива для КВ
%t_ch_h(:,[2:5,8:24,26,30:35,38,42,43])=[];% остались только те, что в формуле,1 - Твоздуха, 6 - Рвых Шакяй=Рвх_Шакяй_Красн, 7 - Твых Шакяй = Твх Шакяй Красн, 
% 25 - Рвых Шакяй Красн, 27 - Рвх Красн-154, 28 - Твх Красн-154, 29 -Рвых_Красн - 154, 36,37 - плотности, 39,40 - молярные массы, 41 - запас на ВК

%t_ch_h(:,[2:5,8:30,32,38,41,43])=[];% остались только те, что в формуле,1 - Твоздуха, 6 - Рвых Шакяй = Рвх_Шакяй_Красн, 7 - Твых Шакяй = Твх_Шакяй Красн, 
% 31 - Рвых Шакяй Красн, 33 - Рвх Красн-140, 34 - Твх Красн-140, 35 - Рвых_Красн - 140, 36,37 - плотности, 39,40 - молярные массы, 42 - запас на ВК1
%% средние давления по ниткам
P_nach_1 = t_ch_h(:,6); % Рн, начальное  абсолютное давление газа на участке, МПа; Шакяй - Краснознаменская
P_nach_2 = t_ch_h(:,27); % Рн, начальное  абсолютное давление газа на участке, МПа; Краснознаменская - 154 км
% P_nach = t_ch_h(:,33); % Рн, начальное  абсолютное давление газа на участке, МПа; Краснознаменская - 140 км

P_kon_1 = t_ch_h(:,31);% Рк конечное абсолютное давлениея газа на участке, МПа; Шакяй - Краснознаменская
P_kon_2 = t_ch_h(:,29); % Рк конечное абсолютное давление газа на участке, МПа; Краснознаменская - 154 км
% P_kon = t_ch_h(:,35); % Рк конечное абсолютное давление газа на участке, МПа; Краснознаменская - 140 км

P_av_1 = 2/3*(P_nach_1 + (P_kon_1.*P_kon_1)./(P_nach_1 + P_kon_1)); % Среднее давление на участке Шакяй - Краснознаменская
P_av_2 = 2/3*(P_nach_2 + (P_kon_2.*P_kon_2)./(P_nach_2 + P_kon_2)); % Среднее давление на участке Шакяй - Краснознаменская

%%
% T_gr_1 = 3.2; % январь грунт
% T_gr_2 = 2.5; % февраль грунт
% T_gr_4 = 3.5; % апрель грунт
% T_gr_5 = 8.3; % май грунт
% T_gr_6 = 12; % июнь грунт
% T_gr_7 = 14.5; % июль грунт
% T_gr_8 = 15.2; % август грунт
% T_gr_9 = 13.7; % сентябрь грунт
% T_gr_10 =14.4 ; % октябрь грунт
% T_gr_11 = 7.2; % ноябрь грунт
% T_gr_12 = 4.6; % декабрь грунт
% T_mean = 7.9; % средняя годовая температура, данные climate-energy.ru
% Tamp = 21.4 - 3.5 ; % Tamp - амплитуда, данные climate-energy.ru
% T_year = (1:1:12); % порядковый номер месяца
% T_shift = 2; % номер месяца с минимальной температурой, здесь февраль данные climate-energy.ru
% T_gr_rasch_1 = 6.3;
% T_gr_rasch_2 = 6;
% T_gr_rasch_3 = 6.5;
% T_gr_rasch_4 = 7.6;
% T_gr_rasch_5 = 9.2;
% T_gr_rasch_6 = 10.7;
% T_gr_rasch_7 = 11.8;
% T_gr_rasch_8 = 12.7;
% T_gr_rasch_9 = 12.3;
% T_gr_rasch_10 = 11.1;
% T_gr_rasch_11 = 9.5;
% T_gr_rasch_12 = 7.9;
% T_gr_rasch = T_mean - Tamp * exp (- h_0 * sqrt(pi / (365 * alfa_temper_grunt_av))) * cos(2 * pi / 365 * (T_year - T_shift -  h_0 / 2 * sqrt(pi / (365 * alfa_temper_grunt_av)))); 
%% константы
h_0 = 150; % h0 - глубина заложения оси трубопровода от поверхности грунта, м;
lambda_gr_t = 1.45; %(1.25); % λгр - коэффициент теплопроводности грунта, Вт/мК, при Тгр > 0 (Тгр* > 273 К) и газа (Т > 273 К) - талого грунта λт, СНиП 2.02.04
lambda_gr_m = 1.57; %(1.35); % λгр - коэффициент теплопроводности грунта, Вт/мК, при Тгр < 0 (Тгр* < 273 К) и газа (Т < 273 К) - мерзлого грунта λm, СНиП 2.02.04
lambda_gr_av = (lambda_gr_m + lambda_gr_t) / 2; % допущение, усреднила
alfa_temper_grunt_t = 0.7557; % Температуропроводность талого грунта λт, СНиП II-Б.6-66, (м2/месяц)
alfa_temper_grunt_m = 1.0496; % Температуропроводность мерзлого грунта λm, СНиП II-Б.6-66, (м2/месяц)
alfa_temper_grunt_av = (alfa_temper_grunt_t + alfa_temper_grunt_m) / 2; % Средняя емпературопроводность грунта (м2/месяц),допущение
density_air=1.20445; % кг/м3 - плотность воздуха при стандартных условиях.
P_c = 0.101325;% МПа;давление при стандартных условиях по ГОСТ 2939
T_c = 293.15;% К; температура при стандартных условиях по ГОСТ 2939
T_sgorania = 293.15;% К Удельная объемная теплота сгорания (теплотворная способность) природного газа
% переводные единицы:
%1 МПа = 10,19716 кгс/см2;
%1 кгс/см2 = 0,0980665 МПа.
R_mu = 8.31451; % кДж/кмоль·К - универсальная газовая постоянная;
M_x_a = 28.0135; % молярная доля азота кг/моль, определяемая по ГОСТ 30319.1
M_x_y = 44.010;   % молярная доля диоксида углерода кг/моль, определяемая по ГОСТ 30319.1 
d_nar_1 = 516; % dн - наружный диаметр газопровода, мм для нитки ВК;
d_iz_1 = 530; % диаметр с изоляцией для нитки ВК
d_nar_2 = 706; % dн - наружный диаметр газопровода, мм для нитки ВК2;
d_iz_2 = 720;% диаметр с изоляцией для нитки ВК2
d_vn_1 = d_nar_1; % внутренний диаметр газопровода, мм, здесь допушение что внутренний и внешний равны
d_vn_2 = d_nar_2; % внутренний диаметр газопровода, мм, здесь допушение что внутренний и внешний равны
lambda_iz = 0.041; % теплопроводность изоляции, Вт/м·К, здесь Пенополимерминерал (допущение, цифра из справочника)
lambda_sn_1 = 0.1; % λсн - коэффициент теплопроводности снежного покрова, Вт/м·К, в зависимости от состояния снега: снег свежевыпавший - 0,1 Вт/м·К;
lambda_sn_2 = 0.35;% снег уплотненный - 0,35 Вт/м·К; 
lambda_sn_3 = 0.64;% снег тающий - 0,64 Вт/м·К;
lambda_s_av = (lambda_sn_1 + lambda_sn_2 + lambda_sn_3)/3; % усреднила, допущение
delta_sn = 0.2; % δсн - толщина снежного покрова, м;
v_1 = 4.1; % средняя скорость ветра, м/с, за период со средней суточной темпе­ратурой воздуха ≤ 8 °С (Октябрь - Апрель)
v_2 = 4.3; % минимальная из средних скоростей ветра по румбам за июль, м/с (Май-Сентябрь)
v_av = (v_1 + v_2) / 2; % пока сделала для упрощения расчетов
alfa_v  = 6.2 + 4.2 * v_av; % α_в - коэффициент теплоотдачи от поверхности грунта в атмосферу, Вт/м2·К
L_1 = 20; % L - длина участка газопровода, км. Шакяй - Краснознаменская
L_2 = 134; % L - длина участка газопровода, км. Краснознаменская - 154 км
L_3 = 120; % L - длина участка газопровода, км. Краснознаменская - 140 км
x_1 = L_1/2; % допущение, взяла центр длины участка расстояние от начала газопровода до рассматриваемой точки, км;
x_2 = L_2/2; % допущение, взяла центр длины участка расстояние от начала газопровода до рассматриваемой точки, км;
x_3 = L_3/2; % допущение, взяла центр длины участка расстояние от начала газопровода до рассматриваемой точки, км;
q_vk = 1003.8 / 365; % q - пропускная способность газопровода VK 154 km, млн.м3/сут;
q_vk_2 = 1496.2 / 365; % q - пропускная способность газопровода VK-2 140 km, млн.м3/сут;
% V = pi * d_vn ^ 2 / 4 * L; % геометрический объем трубы
V_1 = 5.534 * 1000;% геометрический объем трубы Шакяй - Краснознаменская м3
V_2 = 28.67 * 1000;% геометрический объем трубы Краснознаменская - 154 м3
V_3 = 10.974 * 1000;% геометрический объем трубы Краснознаменская м3
V_4 = 25.633* 1000;% геометрический объем трубы 140 м3
%% переменные из таблицы zapas_chet_h
% Тн - температура газа в начале участка газопровода, К; при отсутствии охлаждения газа на КС температуру Тн = Т газа на выходе из компрессорного цеха, 
% при наличии охлаждения газа величина Тн = Т газа на выходе из системы охлаждения;
T_vosd_izmer = t_ch_h(:,1); % 
x_a = t_ch_h(:,42);% концентрация азота, доли ед. измерения
x_y = t_ch_h(:,43);% концентрация диоксида углерода, доли ед. измерения;
T_nach_1 = t_ch_h(:,7); % Тн Шакяй - Краснознаменская
T_nach_2 = t_ch_h(:,28); % Тн Краснознаменская - 154
T_kon_1 = 2.6; % Тк конечная температура газа, здесь взята из предоставленных данных, как допущение, Шакяй - Краснознаменская 
T_kon_2 = 2.3; % Тк конечная температура газа, здесь взята из предоставленных данных, как допущение, Краснознаменская - 154
density_standart_Shak = t_ch_h(:,36); % плотность природного газа по воздуху измеренная Шаакяй
density_standart_Krasn = t_ch_h(:,37); % плотность природного газа по воздуху измеренная Краснознаменская
T_gr_sprav = t_ch_h(:,44); % спрвочное значние грунта
%% псевдокритические давление и температура
P_pk_1 = 2.9585 * (1.608 - 0.05994 * density_standart_Shak + M_x_y - 0.392 * M_x_a);% псевдокритическое давление Рпк 
T_pk_1 = 88.25 * (0.9915 + 1.759 * density_standart_Shak - M_x_y - 1.681 * M_x_a); % псевдокритическая температура Тпк 
%% относительная плотность
density_otnosit_Shak = density_standart_Shak/density_air; % Δ - относительная плотность газа по воздуху;
% Re = 17.75 * 10e+3 * q_vk * density_otnosit_Shak/(d_nar * mu); % Число Рейнольдса Re 
R_iz_1 = (10e-3)*d_nar_1/(2*lambda_iz)*log(d_iz_1/d_nar_1); % R_из - термическое сопротивление изоляции трубопровода, м2·К/Вт
%% Коэффициент  
h_oe = h_0 + lambda_gr_av * (1/ alfa_v + delta_sn / lambda_s_av);   
%% Коэффициент теплоотдачи от трубы в грунт αгр 
alfa_gr_1 = lambda_gr_av  / (10e-3 * d_nar_1) * (0.65 + (10e-3 * d_nar_1 / h_oe) ^ 2);% α_гр - коэффициент теплоотдачи от трубопровода в грунт, Вт/м2·К;
%% Кср - средний на участке общий коэффициент теплопередачи от газа в окружающую среду, Вт/м2·К; здесь формула для подземных газопроводов
K_av_1 = 1/(R_iz_1 + 1/alfa_gr_1) ^ (-1);
%% средняя температура газа на участке газопровода Тср 
% Простая формула
T_av_prost_1 = T_gr_sprav + (T_nach_1 - T_kon_1) / log((T_nach_1 - T_kon_1)./(T_kon_1 - T_gr_sprav)); % Средняя температура грунта, простая формула
% T_av = T_gr_sprav + (T_nach_1 - T_gr_sprav) / (alfa * L_1) * (1 - exp(-alfa * x_1)) - Di * (P_nach_1 ^ 2 - P_kon_1 ^ 2) / (2 * alfa * L_1 * P_av_1) * (1 - 1 / (alfa * L_1) * (1 - exp(-alfa * x_1))) ;
%Тokr - расчетная температура окружающей среды, К; При подземной прокладке То = Тгр ср за период на глубине заложения оси трубопровода. Здесь Т грунта Минска из справочника
%% приведенные давление и температура
P_pr_1 = P_av_1./P_pk_1; % приведенное давление
T_pr_1 = T_av_prost_1./T_pk_1; % приведенная температура
%% Средняя изобарная теплоемкость природного газа Ср 
M = M_x_a * x_a + M_x_y * x_y; % Молярная масса природного газа М, кг/кмоль, на основе компонентного состава
K = 8.3143 / M;
E_0 = 4.437 - 1.015 * T_pr_1 + 0.591 * T_pr_1;
%%
E_1 = 3.29 - 11.37 / T_pr_1 + 10.9 / (T_pr_1 * T_pr_1);
%%
E_2 = 3.23 - 16.27 / T_pr_1 + 25.48 / (T_pr_1 ^ 2) - 11.81 / (T_pr_1 ^ 3);
E_3 = - 0.214 + 0.908 / T_pr_1 + 0.967 / (T_pr_1 ^ 2);
C_p = K * (E_0 + E_1 * P_pr_1 + E_2 * P_pr_1 ^ 2 + E_3 * (P_pr_1 ^ 3)); % Средняя изобарная теплоемкость природного газа Ср
%% Альфа
alfa = 225.5 * K_av_1  * d_nar_1 /(q_vk * density_otnosit_Shak * C_p * 10e+6);
%% коэффициент сжимаемости
A_1 = -0.39 + 2.03/T_pr_1 - 3.16/(T_pr_1^2) + 1.09/(T_pr_1^3);
A_2 = 0.0423 - 0.1812/T_pr_1 + 0.2124/(T_pr_1^2);
Z = 1 + A_1 * P_pr_1 + A_2 * P_pr_1^2;  % коэффициент сжимаемости природного газа при стандартных условиях.
%Z = K_0 + p(K_1 + K_2/Т + K_3*density_Shakyai_standart + K_4*x_a + K_5*x_y);% для расчета коэффициента сжимаемости допускается использовать это уравнение
%% Среднее значение коэффициента Джоуля-Томсона Di 
H_0 = 24.96 - 20.3 * T_pr_1 + 4.57 * (T_pr_1 ^ 2);
H_1 = 5.66 - 19.92 / T_pr_1 + 16.89 / (T_pr_1 ^ 2);
H_2 = -4.11 + 14.68 / T_pr_1 + 13.39 / (T_pr_1 ^ 2);
H_3 = 0.568 - 2 / T_pr + 1.79 / (T_pr ^ 2);
Di = H_0 + H_1 * P_pr_1 + H_2 * P_pr_1 ^ 2 + H_3*P_pr_1 ^ 3; % для природных газов с содержанием метана > 80 % в диапазоне 250 - 400 К, при давлениях до 15 МПа 
%%
% Z_prost = 1 - 0.0907 * P_av_1 * (T_av / 200) ^ (-3.668); % Коэффициент сжимаемости, простая формула
% tau = 1 - 1.68 * T_pr_1 + 0.78 * T_pr_1 ^ 2 + 0.0107 * T_pr_1 ^ 3;
% Z_av_prost = 1 - 0.0241 * P_pr_1 / tau;
%% Запас газа итог
V_zapas = V * P_av_1 * T_c/(T_av * Z * P_c); % Объём запаса газа на протяженных участках 
