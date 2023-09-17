# Методы и алгоритмы нейросетевого управления балансом газа в газотранспортной сети
## Задачи
1.	Обучить на всех ГРС регрессионную нейросеть (обучена, но тестовые данные были нормированы). 
Задача: обучить корректно нейросеть, с правильным валидированивем и тестированием. 
Папка 1. Скрипт train_net_Pin_Tin_grs_gis_temper_q_norm_update_all_19_08_23.m 
2.	Обучить классификационную нейросеть для всех ГРС (сейчас есть для одной, Светлогорска, которая оказалась в тестовой выборке).
Ждем разметку 
3.	Идентифицировать и классифицировать отклонения для регрессионной нейросети по трем уровням 3-х параметров (величина, длительность, ускорение отклонения), сделано по одному уровню для трех параметров, скорость, а не ускорение, и применена старая нейросеть, обученная на 4 ГРС, соответственно, data другие чем в п.1.
Задача: сделать идентификацию (величина отклонения, длительность, и ускорение) и классификацию (выбирается по максимальному значению одного из трех параметров таблицы 1).
Папка 3. Работающий скрипт по одному уровню параметров: detection_3_param_1_level_vertical_lines_on_graf_anomaly_3.m
Некорректно работающая версия для трех уровней трех параметров detection_3_param_3_levels__with_grafic.m
Функция для расчета ускорения находится в конце скрипта detection_3_param_3_levels_acceleration_function.m
4.	Идентифицировать и классифицировать отклонения для классификационной нейросети по одному уровня 4-х параметров (вероятность, длительность, скорость нарастания отклонения, причина). Начали делать, но код не работает, не успела довести
5.	Оценить вероятность принадлежности выявленных отклонений исходному закону распределения. Начали, со старой нейросетью, обученной на 4 ГРС, соответственно, data другие чем в п.1.
6.	По анфису определить небаланс по отклонениям из п.3.
7.	Определить запас, с учетом температуры грунта реальной и неизвестной в СТО температуры Т
8.	Создать виртуальные датчики расходов на собственные нужды, запаса, небаланса, расходов на устранение.
9.	Составить алгоритм принятия решения о мерах устранения в зависимости от причин и оптимизационного фактора
10.	Определить баланс старым и новым методом
11.	Показать эффективность метода сравнением какой был бы баланс(небаланс) и какой стал
12.	Подключить нейросети в газовую и электромодель
13.	Составить передаточные функции и матрицу состояний
14.	Сделать нейросетевой контроллер
    
Дополнительно (когда будет возможно)
1.	Влючить обученную на всех ГРС регрессионную нейросеть в нейросеть с двумя выходами
2.	Перевести на С++, запрограммировать контроллер
_____
