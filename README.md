# Methods and algorithms for neural network control of gas balance in the gas transportation network
## Problems for Matlab
1. Train a regression and classification neural network for all GDS (in progress).
3. Identify and classify deviations. Assess the probability that the identified deviations belong to the original distribution law.
4. Based on the anfis, determine the imbalance based on the deviations from clause 3.
5. Determine the reserve, taking into account the real soil temperature and the unknown temperature T in the service station
6. Create virtual sensors for expenses for own needs, reserves, imbalances, and elimination costs.
7. Program an algorithm for deciding on corrective measures depending on the causes and optimization factor
8. Determine the balance using the old and new methods
9. Show the effectiveness of the method by comparing what the balance (imbalance) would be and what it would become
10. Connect neural networks to gas and electric models
11. Create transfer functions and state matrix
12. Program the neural network controller
    
## For a model in Simulink
1. Correctly, from the point of view of physical properties and statistical data, working model
2. Generate new data
3. Reading data from objects and additional training of the neural network (the neural network has already been trained)
4. Identification of anomalies on objects by comparing real values and neural network predictions (the algorithm is being developed)
5. Control based on the developed algorithm (the algorithm is being developed).
6. Explore the possibility of using System Identification Toolbox
7. Explore the possibility of using Neural Controller
8. Obtain differential equations, transfer functions, state matrix
9. Generate anomalies to check operation
10. Connect UGS and reserves
11. Include a regression neural network trained on all GRSs into a neural network with two outputs
12. Translate into C++, program the controller

# Методы и алгоритмы нейросетевого управления балансом газа в газотранспортной сети
## Задачи для Матлаб
1.	Обучить регрессионную и классификационную нейросеть для всех ГРС (в процессе).
3.	Идентифицировать и классифицировать отклонения.	Оценить вероятность принадлежности выявленных отклонений исходному закону распределения.
4.	По анфису определить небаланс по отклонениям из п.3.
5.	Определить запас, с учетом температуры грунта реальной и неизвестной в СТО температуры Т
6.	Создать виртуальные датчики расходов на собственные нужды, запаса, небаланса, расходов на устранение.
7.	Запрограммировать алгоритм принятия решения о мерах устранения в зависимости от причин и оптимизационного фактора
8.	Определить баланс старым и новым методом
9.	Показать эффективность метода сравнением какой был бы баланс(небаланс) и какой стал
10.	Подключить нейросети в газовую и электромодель
11.	Составить передаточные функции и матрицу состояний
12.	Запрограммировать нейросетевой контроллер
    
## Для модели в Симулинк
1. Корректно, с точки зрения физических свойств и статистических данных, работающая модель 
2. Генерировать новые данные  
3. Считывание данных с объектов и дообучение нейросети (нейросеть уже обучена) 
4. Идентификация аномалий на объектах путем сравнения реальных значений и предсказаний нейросети (алгоритм разрабатывается) 
5. Управление на основе разработанного алгоритма (алгоритм разрабатывается).  
6. Исследовать возможность использования System Identification Toolbox 
7. Исследовать возможность использования Neural Controller 
8. Получить дифференциальные уравнения, передаточные функции, матрицу состояний 
9. Генерировать аномалии, для проверки работы
10. Подключить ПХГ и запас
11. Влючить обученную на всех ГРС регрессионную нейросеть в нейросеть с двумя выходами
12. Перевести на С++, запрограммировать контроллер

_____
![Схема](https://github.com/AigulPetrova/Gas/blob/86e5967bc2a582732c26ee1abcb0e2d5a213430d/%D0%A1%D1%85%D0%B5%D0%BC%D0%B0%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D0%B8%201.jpg)
![Схема](https://github.com/AigulPetrova/Gas/blob/5f4c6932e1c5b389cd034adcc56ad072cb6e3afd/%D0%A2%D0%B0%D0%B1%D0%BB%D0%B8%D1%86%D0%B0%201.jpg)
