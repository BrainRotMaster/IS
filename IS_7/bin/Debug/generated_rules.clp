(deftemplate item (slot name) (slot conf (type FLOAT) (default 0.0)))
(deftemplate option (slot id) (slot label) (slot group))
(deftemplate ioproxy (slot id) (slot text) (multislot options))
(deftemplate answer (slot id) (slot value))
(deftemplate asked (slot id))

(defrule clear-message
  (declare (salience 100))
  ?c <- (clearmessage)
  ?m <- (sendmessagehalt ?)
  =>
  (retract ?c)
  (retract ?m)
)

(defrule clear-ioproxy
  (declare (salience 100))
  ?c <- (clearquestion)
  ?p <- (ioproxy)
  =>
  (retract ?c)
  (retract ?p)
)

(defrule combine
  (declare (salience 60))
  ?i1 <- (item (name ?f1) (conf ?conf1))
  ?i2 <- (item (name ?f2) (conf ?conf2))
  =>
  (if (and (eq ?f1 ?f2) (!= ?conf1 ?conf2)) then
    (assert (item (name ?f1) (conf (- (+ ?conf1 ?conf2) (* ?conf1 ?conf2)))) )
    (retract ?i1)
    (retract ?i2)
    (assert (sendmessagehalt (sym-cat ?f1 ": ===Коэффициент уверенности пересчитан===")))
    (halt))
)

(deffacts options
  (option (id f1) (label "Рыцарь") (group class))
  (option (id f2) (label "Маг") (group class))
  (option (id f3) (label "Наёмник") (group class))
  (option (id f4) (label "Жрица") (group class))
  (option (id f5) (label "Варвар") (group class))
  (option (id f6) (label "Королевство Алендор") (group kingdom))
  (option (id f7) (label "Королевство Моргир") (group kingdom))
  (option (id f8) (label "Королевство Тарн") (group kingdom))
  (option (id f9) (label "Королевство Хольм") (group kingdom))
  (option (id f10) (label "Королевство Эльдаран") (group kingdom))
  (option (id f11) (label "Северные земли") (group region))
  (option (id f12) (label "Тёмные леса") (group region))
  (option (id f13) (label "Солнечные равнины") (group region))
  (option (id f14) (label "Горные вершины") (group region))
  (option (id f15) (label "Туманные болота") (group region))
  (option (id f16) (label "Дракон") (group entity))
  (option (id f17) (label "Гоблин") (group entity))
  (option (id f18) (label "Тролль") (group entity))
  (option (id f19) (label "Волшебный зверь") (group entity))
  (option (id f20) (label "Нежить") (group entity))
  (option (id f21) (label "Магический меч") (group artifact))
  (option (id f22) (label "Древний посох") (group artifact))
  (option (id f23) (label "Чёрный амулет") (group artifact))
  (option (id f24) (label "Священный щит") (group artifact))
  (option (id f25) (label "Кольцо власти") (group artifact))
  (option (id f26) (label "Магия огня") (group state))
  (option (id f27) (label "Магия воды") (group state))
  (option (id f28) (label "Магия воздуха") (group state))
  (option (id f29) (label "Магия земли") (group state))
  (option (id f30) (label "Магия тьмы") (group state))
  (option (id f31) (label "Заброшенная крепость") (group state))
  (option (id f32) (label "Древний храм") (group state))
  (option (id f33) (label "Катакомбы") (group state))
  (option (id f34) (label "Магическая башня") (group state))
  (option (id f35) (label "Разрушенный мост") (group state))
  (option (id f36) (label "Угроза миру") (group state))
  (option (id f37) (label "Мирное время") (group state))
  (option (id f38) (label "Пророчество") (group state))
  (option (id f39) (label "Ослабление магии") (group state))
  (option (id f40) (label "Рост тьмы") (group state))
  (option (id f41) (label "Боевой класс") (group other))
  (option (id f42) (label "Магический класс") (group other))
  (option (id f43) (label "Духовный путь") (group other))
  (option (id f44) (label "Дикий путь") (group other))
  (option (id f45) (label "Теневой путь") (group other))
  (option (id f46) (label "Защитник королевства") (group other))
  (option (id f47) (label "Проводник магии") (group other))
  (option (id f48) (label "Охотник на чудовищ") (group other))
  (option (id f49) (label "Хранитель веры") (group other))
  (option (id f50) (label "Разрушитель орд") (group other))
  (option (id f51) (label "Связь с королевством") (group other))
  (option (id f52) (label "Изгнанник земель") (group other))
  (option (id f53) (label "Избранник пророчества") (group other))
  (option (id f54) (label "Проклятый герой") (group other))
  (option (id f55) (label "Благословлённый герой") (group other))
  (option (id f56) (label "Северный поход") (group other))
  (option (id f57) (label "Лесная кампания") (group other))
  (option (id f58) (label "Поход равнин") (group other))
  (option (id f59) (label "Горная экспедиция") (group other))
  (option (id f60) (label "Болотная миссия") (group other))
  (option (id f61) (label "Контроль огня") (group other))
  (option (id f62) (label "Контроль воды") (group other))
  (option (id f63) (label "Контроль воздуха") (group other))
  (option (id f64) (label "Контроль земли") (group other))
  (option (id f65) (label "Контроль тьмы") (group other))
  (option (id f66) (label "Штурм крепости") (group other))
  (option (id f67) (label "Очищение храма") (group other))
  (option (id f68) (label "Исследование катакомб") (group other))
  (option (id f69) (label "Защита башни") (group other))
  (option (id f70) (label "Восстановление моста") (group other))
  (option (id f71) (label "Драконья угроза") (group other))
  (option (id f72) (label "Нашествие гоблинов") (group other))
  (option (id f73) (label "Ярость троллей") (group other))
  (option (id f74) (label "Звериный хаос") (group other))
  (option (id f75) (label "Восстание нежити") (group other))
  (option (id f76) (label "Древний ритуал") (group other))
  (option (id f77) (label "Печать стихий") (group other))
  (option (id f78) (label "Сломанное равновесие") (group other))
  (option (id f79) (label "Потерянное знание") (group other))
  (option (id f80) (label "Запретная магия") (group other))
  (option (id f81) (label "Путь силы") (group other))
  (option (id f82) (label "Путь мудрости") (group other))
  (option (id f83) (label "Путь веры") (group other))
  (option (id f84) (label "Путь ярости") (group other))
  (option (id f85) (label "Путь тени") (group other))
  (option (id f86) (label "Союз королевств") (group other))
  (option (id f87) (label "Раскол мира") (group other))
  (option (id f88) (label "Падение магии") (group other))
  (option (id f89) (label "Возрождение древних") (group other))
  (option (id f90) (label "Последний шанс") (group other))
  (option (id f300) (label "Великий квест - защита королевства") (group other))
  (option (id f301) (label "Великий квест - уничтожение дракона") (group other))
  (option (id f302) (label "Великий квест - очищение мира от нежити") (group other))
  (option (id f303) (label "Великий квест - восстановление магического баланса") (group other))
  (option (id f304) (label "Великий квест - исполнение пророчества") (group other))
  (option (id f305) (label "Великий квест - спасение древних земель") (group other))
  (option (id f306) (label "Великий квест - предотвращение катастрофы") (group other))
  (option (id f307) (label "Великий квест - объединение королевств") (group other))
  (option (id f308) (label "Великий квест - запечатывание тьмы") (group other))
  (option (id f309) (label "Великий квест - последний рубеж человечества") (group other))
)

(defrule r1
  (declare (salience 10))
  (item (name f1) (conf ?c0))
  (item (name f26) (conf ?c1))
  =>
  (assert (item (name f41) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f41: Рыцарь + Магия огня -> Боевой класс"))
  (halt)
)

(defrule r2
  (declare (salience 10))
  (item (name f1) (conf ?c0))
  (item (name f29) (conf ?c1))
  =>
  (assert (item (name f41) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f41: Рыцарь + Магия земли -> Боевой класс"))
  (halt)
)

(defrule r3
  (declare (salience 10))
  (item (name f2) (conf ?c0))
  (item (name f27) (conf ?c1))
  =>
  (assert (item (name f42) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f42: Маг + Магия воды -> Магический класс"))
  (halt)
)

(defrule r4
  (declare (salience 10))
  (item (name f2) (conf ?c0))
  (item (name f28) (conf ?c1))
  =>
  (assert (item (name f42) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f42: Маг + Магия воздуха -> Магический класс"))
  (halt)
)

(defrule r5
  (declare (salience 10))
  (item (name f4) (conf ?c0))
  (item (name f24) (conf ?c1))
  =>
  (assert (item (name f43) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f43: Жрица + Священный щит -> Духовный путь"))
  (halt)
)

(defrule r6
  (declare (salience 10))
  (item (name f4) (conf ?c0))
  (item (name f22) (conf ?c1))
  =>
  (assert (item (name f43) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f43: Жрица + Древний посох -> Духовный путь"))
  (halt)
)

(defrule r7
  (declare (salience 10))
  (item (name f5) (conf ?c0))
  (item (name f30) (conf ?c1))
  =>
  (assert (item (name f44) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f44: Варвар + Магия тьмы -> Дикий путь"))
  (halt)
)

(defrule r8
  (declare (salience 10))
  (item (name f5) (conf ?c0))
  (item (name f26) (conf ?c1))
  =>
  (assert (item (name f44) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f44: Варвар + Магия огня -> Дикий путь"))
  (halt)
)

(defrule r9
  (declare (salience 10))
  (item (name f3) (conf ?c0))
  (item (name f23) (conf ?c1))
  =>
  (assert (item (name f45) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f45: Наёмник + Чёрный амулет -> Теневой путь"))
  (halt)
)

(defrule r10
  (declare (salience 10))
  (item (name f3) (conf ?c0))
  (item (name f25) (conf ?c1))
  =>
  (assert (item (name f45) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f45: Наёмник + Кольцо власти -> Теневой путь"))
  (halt)
)

(defrule r11
  (declare (salience 10))
  (item (name f1) (conf ?c0))
  (item (name f16) (conf ?c1))
  =>
  (assert (item (name f48) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f48: Рыцарь + Дракон -> Охотник на чудовищ"))
  (halt)
)

(defrule r12
  (declare (salience 10))
  (item (name f1) (conf ?c0))
  (item (name f17) (conf ?c1))
  =>
  (assert (item (name f46) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f46: Рыцарь + Гоблин -> Защитник королевства"))
  (halt)
)

(defrule r13
  (declare (salience 10))
  (item (name f2) (conf ?c0))
  (item (name f20) (conf ?c1))
  =>
  (assert (item (name f47) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f47: Маг + Нежить -> Проводник магии"))
  (halt)
)

(defrule r14
  (declare (salience 10))
  (item (name f4) (conf ?c0))
  (item (name f20) (conf ?c1))
  =>
  (assert (item (name f49) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f49: Жрица + Нежить -> Хранитель веры"))
  (halt)
)

(defrule r15
  (declare (salience 10))
  (item (name f5) (conf ?c0))
  (item (name f18) (conf ?c1))
  =>
  (assert (item (name f50) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f50: Варвар + Тролль -> Разрушитель орд"))
  (halt)
)

(defrule r16
  (declare (salience 10))
  (item (name f11) (conf ?c0))
  (item (name f16) (conf ?c1))
  =>
  (assert (item (name f56) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f56: Северные земли + Дракон -> Северный поход"))
  (halt)
)

(defrule r17
  (declare (salience 10))
  (item (name f12) (conf ?c0))
  (item (name f17) (conf ?c1))
  =>
  (assert (item (name f57) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f57: Тёмные леса + Гоблин -> Лесная кампания"))
  (halt)
)

(defrule r18
  (declare (salience 10))
  (item (name f13) (conf ?c0))
  (item (name f18) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Солнечные равнины + Тролль -> Поход равнин"))
  (halt)
)

(defrule r19
  (declare (salience 10))
  (item (name f14) (conf ?c0))
  (item (name f19) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Горные вершины + Волшебный зверь -> Горная экспедиция"))
  (halt)
)

(defrule r20
  (declare (salience 10))
  (item (name f15) (conf ?c0))
  (item (name f20) (conf ?c1))
  =>
  (assert (item (name f60) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f60: Туманные болота + Нежить -> Болотная миссия"))
  (halt)
)

(defrule r21
  (declare (salience 10))
  (item (name f31) (conf ?c0))
  (item (name f16) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Заброшенная крепость + Дракон -> Сломанное равновесие"))
  (halt)
)

(defrule r22
  (declare (salience 10))
  (item (name f32) (conf ?c0))
  (item (name f20) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Древний храм + Нежить -> Сломанное равновесие"))
  (halt)
)

(defrule r23
  (declare (salience 10))
  (item (name f33) (conf ?c0))
  (item (name f18) (conf ?c1))
  =>
  (assert (item (name f79) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f79: Катакомбы + Тролль -> Потерянное знание"))
  (halt)
)

(defrule r24
  (declare (salience 10))
  (item (name f34) (conf ?c0))
  (item (name f17) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Магическая башня + Гоблин -> Сломанное равновесие"))
  (halt)
)

(defrule r25
  (declare (salience 10))
  (item (name f35) (conf ?c0))
  (item (name f19) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Разрушенный мост + Волшебный зверь -> Сломанное равновесие"))
  (halt)
)

(defrule r26
  (declare (salience 10))
  (item (name f26) (conf ?c0))
  (item (name f16) (conf ?c1))
  =>
  (assert (item (name f61) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f61: Магия огня + Дракон -> Контроль огня"))
  (halt)
)

(defrule r27
  (declare (salience 10))
  (item (name f27) (conf ?c0))
  (item (name f20) (conf ?c1))
  =>
  (assert (item (name f62) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f62: Магия воды + Нежить -> Контроль воды"))
  (halt)
)

(defrule r28
  (declare (salience 10))
  (item (name f28) (conf ?c0))
  (item (name f19) (conf ?c1))
  =>
  (assert (item (name f63) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f63: Магия воздуха + Волшебный зверь -> Контроль воздуха"))
  (halt)
)

(defrule r29
  (declare (salience 10))
  (item (name f29) (conf ?c0))
  (item (name f18) (conf ?c1))
  =>
  (assert (item (name f64) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f64: Магия земли + Тролль -> Контроль земли"))
  (halt)
)

(defrule r30
  (declare (salience 10))
  (item (name f30) (conf ?c0))
  (item (name f17) (conf ?c1))
  =>
  (assert (item (name f65) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f65: Магия тьмы + Гоблин -> Контроль тьмы"))
  (halt)
)

(defrule r31
  (declare (salience 10))
  (item (name f56) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Северный поход + Сломанное равновесие -> Последний шанс"))
  (halt)
)

(defrule r32
  (declare (salience 10))
  (item (name f57) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Лесная кампания + Сломанное равновесие -> Последний шанс"))
  (halt)
)

(defrule r33
  (declare (salience 10))
  (item (name f58) (conf ?c0))
  (item (name f79) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Поход равнин + Потерянное знание -> Последний шанс"))
  (halt)
)

(defrule r34
  (declare (salience 10))
  (item (name f59) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Горная экспедиция + Сломанное равновесие -> Последний шанс"))
  (halt)
)

(defrule r35
  (declare (salience 10))
  (item (name f60) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Болотная миссия + Сломанное равновесие -> Последний шанс"))
  (halt)
)

(defrule r36
  (declare (salience 10))
  (item (name f38) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f53) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f53: Пророчество + Сломанное равновесие -> Избранник пророчества"))
  (halt)
)

(defrule r37
  (declare (salience 10))
  (item (name f38) (conf ?c0))
  (item (name f79) (conf ?c1))
  =>
  (assert (item (name f53) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f53: Пророчество + Потерянное знание -> Избранник пророчества"))
  (halt)
)

(defrule r38
  (declare (salience 10))
  (item (name f37) (conf ?c0))
  (item (name f56) (conf ?c1))
  =>
  (assert (item (name f55) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f55: Мирное время + Северный поход -> Благословлённый герой"))
  (halt)
)

(defrule r39
  (declare (salience 10))
  (item (name f36) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f54) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f54: Угроза миру + Сломанное равновесие -> Проклятый герой"))
  (halt)
)

(defrule r40
  (declare (salience 10))
  (item (name f36) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f306) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f306: Угроза миру + Последний шанс -> Великий квест - предотвращение катастрофы"))
  (halt)
)

(defrule r41
  (declare (salience 10))
  (item (name f41) (conf ?c0))
  (item (name f71) (conf ?c1))
  =>
  (assert (item (name f48) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f48: Боевой класс + Драконья угроза -> Охотник на чудовищ"))
  (halt)
)

(defrule r42
  (declare (salience 10))
  (item (name f42) (conf ?c0))
  (item (name f75) (conf ?c1))
  =>
  (assert (item (name f47) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f47: Магический класс + Восстание нежити -> Проводник магии"))
  (halt)
)

(defrule r43
  (declare (salience 10))
  (item (name f43) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f49) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f49: Духовный путь + Сломанное равновесие -> Хранитель веры"))
  (halt)
)

(defrule r44
  (declare (salience 10))
  (item (name f44) (conf ?c0))
  (item (name f72) (conf ?c1))
  =>
  (assert (item (name f50) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f50: Дикий путь + Нашествие гоблинов -> Разрушитель орд"))
  (halt)
)

(defrule r45
  (declare (salience 10))
  (item (name f45) (conf ?c0))
  (item (name f73) (conf ?c1))
  =>
  (assert (item (name f48) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f48: Теневой путь + Ярость троллей -> Охотник на чудовищ"))
  (halt)
)

(defrule r46
  (declare (salience 10))
  (item (name f61) (conf ?c0))
  (item (name f76) (conf ?c1))
  =>
  (assert (item (name f77) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f77: Контроль огня + Древний ритуал -> Печать стихий"))
  (halt)
)

(defrule r47
  (declare (salience 10))
  (item (name f62) (conf ?c0))
  (item (name f76) (conf ?c1))
  =>
  (assert (item (name f77) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f77: Контроль воды + Древний ритуал -> Печать стихий"))
  (halt)
)

(defrule r48
  (declare (salience 10))
  (item (name f63) (conf ?c0))
  (item (name f76) (conf ?c1))
  =>
  (assert (item (name f77) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f77: Контроль воздуха + Древний ритуал -> Печать стихий"))
  (halt)
)

(defrule r49
  (declare (salience 10))
  (item (name f64) (conf ?c0))
  (item (name f76) (conf ?c1))
  =>
  (assert (item (name f77) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f77: Контроль земли + Древний ритуал -> Печать стихий"))
  (halt)
)

(defrule r50
  (declare (salience 10))
  (item (name f65) (conf ?c0))
  (item (name f76) (conf ?c1))
  =>
  (assert (item (name f80) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f80: Контроль тьмы + Древний ритуал -> Запретная магия"))
  (halt)
)

(defrule r51
  (declare (salience 10))
  (item (name f56) (conf ?c0))
  (item (name f71) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Северный поход + Драконья угроза -> Последний шанс"))
  (halt)
)

(defrule r52
  (declare (salience 10))
  (item (name f57) (conf ?c0))
  (item (name f72) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Лесная кампания + Нашествие гоблинов -> Последний шанс"))
  (halt)
)

(defrule r53
  (declare (salience 10))
  (item (name f58) (conf ?c0))
  (item (name f73) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Поход равнин + Ярость троллей -> Последний шанс"))
  (halt)
)

(defrule r54
  (declare (salience 10))
  (item (name f59) (conf ?c0))
  (item (name f74) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Горная экспедиция + Звериный хаос -> Последний шанс"))
  (halt)
)

(defrule r55
  (declare (salience 10))
  (item (name f60) (conf ?c0))
  (item (name f75) (conf ?c1))
  =>
  (assert (item (name f90) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f90: Болотная миссия + Восстание нежити -> Последний шанс"))
  (halt)
)

(defrule r56
  (declare (salience 10))
  (item (name f66) (conf ?c0))
  (item (name f71) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Штурм крепости + Драконья угроза -> Сломанное равновесие"))
  (halt)
)

(defrule r57
  (declare (salience 10))
  (item (name f67) (conf ?c0))
  (item (name f75) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Очищение храма + Восстание нежити -> Сломанное равновесие"))
  (halt)
)

(defrule r58
  (declare (salience 10))
  (item (name f68) (conf ?c0))
  (item (name f73) (conf ?c1))
  =>
  (assert (item (name f79) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f79: Исследование катакомб + Ярость троллей -> Потерянное знание"))
  (halt)
)

(defrule r59
  (declare (salience 10))
  (item (name f69) (conf ?c0))
  (item (name f72) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Защита башни + Нашествие гоблинов -> Сломанное равновесие"))
  (halt)
)

(defrule r60
  (declare (salience 10))
  (item (name f70) (conf ?c0))
  (item (name f74) (conf ?c1))
  =>
  (assert (item (name f78) (conf (* 0.8 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f78: Восстановление моста + Звериный хаос -> Сломанное равновесие"))
  (halt)
)

(defrule r61
  (declare (salience 10))
  (item (name f81) (conf ?c0))
  (item (name f71) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Путь силы + Драконья угроза -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r62
  (declare (salience 10))
  (item (name f82) (conf ?c0))
  (item (name f79) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Путь мудрости + Потерянное знание -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r63
  (declare (salience 10))
  (item (name f83) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f305) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f305: Путь веры + Сломанное равновесие -> Великий квест - спасение древних земель"))
  (halt)
)

(defrule r64
  (declare (salience 10))
  (item (name f84) (conf ?c0))
  (item (name f72) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Путь ярости + Нашествие гоблинов -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r65
  (declare (salience 10))
  (item (name f85) (conf ?c0))
  (item (name f75) (conf ?c1))
  =>
  (assert (item (name f308) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f308: Путь тени + Восстание нежити -> Великий квест - запечатывание тьмы"))
  (halt)
)

(defrule r66
  (declare (salience 10))
  (item (name f53) (conf ?c0))
  (item (name f77) (conf ?c1))
  =>
  (assert (item (name f89) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f89: Избранник пророчества + Печать стихий -> Возрождение древних"))
  (halt)
)

(defrule r67
  (declare (salience 10))
  (item (name f88) (conf ?c0))
  (item (name f80) (conf ?c1))
  =>
  (assert (item (name f87) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f87: Падение магии + Запретная магия -> Раскол мира"))
  (halt)
)

(defrule r68
  (declare (salience 10))
  (item (name f90) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f86) (conf (* 0.85 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f86: Последний шанс + Сломанное равновесие -> Союз королевств"))
  (halt)
)

(defrule r69
  (declare (salience 10))
  (item (name f79) (conf ?c0))
  (item (name f82) (conf ?c1))
  =>
  (assert (item (name f82) (conf (* 1.0 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f82: Потерянное знание + Путь мудрости -> Путь мудрости"))
  (halt)
)

(defrule r70
  (declare (salience 10))
  (item (name f55) (conf ?c0))
  (item (name f83) (conf ?c1))
  =>
  (assert (item (name f55) (conf (* 1.0 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f55: Благословлённый герой + Путь веры -> Благословлённый герой"))
  (halt)
)

(defrule r71
  (declare (salience 10))
  (item (name f48) (conf ?c0))
  (item (name f71) (conf ?c1))
  =>
  (assert (item (name f71) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f71: Охотник на чудовищ + Драконья угроза -> Драконья угроза"))
  (halt)
)

(defrule r72
  (declare (salience 10))
  (item (name f47) (conf ?c0))
  (item (name f75) (conf ?c1))
  =>
  (assert (item (name f75) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f75: Проводник магии + Восстание нежити -> Восстание нежити"))
  (halt)
)

(defrule r73
  (declare (salience 10))
  (item (name f49) (conf ?c0))
  (item (name f78) (conf ?c1))
  =>
  (assert (item (name f83) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f83: Хранитель веры + Сломанное равновесие -> Путь веры"))
  (halt)
)

(defrule r74
  (declare (salience 10))
  (item (name f50) (conf ?c0))
  (item (name f72) (conf ?c1))
  =>
  (assert (item (name f72) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f72: Разрушитель орд + Нашествие гоблинов -> Нашествие гоблинов"))
  (halt)
)

(defrule r75
  (declare (salience 10))
  (item (name f48) (conf ?c0))
  (item (name f73) (conf ?c1))
  =>
  (assert (item (name f73) (conf (* 0.9 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f73: Охотник на чудовищ + Ярость троллей -> Ярость троллей"))
  (halt)
)

(defrule r76
  (declare (salience 10))
  (item (name f86) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Союз королевств + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r77
  (declare (salience 10))
  (item (name f87) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f309) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f309: Раскол мира + Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

(defrule r78
  (declare (salience 10))
  (item (name f89) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Возрождение древних + Последний шанс -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r79
  (declare (salience 10))
  (item (name f88) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Падение магии + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r80
  (declare (salience 10))
  (item (name f78) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f306) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f306: Сломанное равновесие + Последний шанс -> Великий квест - предотвращение катастрофы"))
  (halt)
)

(defrule r81
  (declare (salience 10))
  (item (name f71) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Драконья угроза + Последний шанс -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r82
  (declare (salience 10))
  (item (name f75) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f302) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f302: Восстание нежити + Последний шанс -> Великий квест - очищение мира от нежити"))
  (halt)
)

(defrule r83
  (declare (salience 10))
  (item (name f78) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f306) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f306: Сломанное равновесие + Последний шанс -> Великий квест - предотвращение катастрофы"))
  (halt)
)

(defrule r84
  (declare (salience 10))
  (item (name f79) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Потерянное знание + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r85
  (declare (salience 10))
  (item (name f89) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Возрождение древних + Последний шанс -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r86
  (declare (salience 10))
  (item (name f86) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Союз королевств + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r87
  (declare (salience 10))
  (item (name f87) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f309) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f309: Раскол мира + Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

(defrule r88
  (declare (salience 10))
  (item (name f88) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Падение магии + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r89
  (declare (salience 10))
  (item (name f55) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f304) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f304: Благословлённый герой + Последний шанс -> Великий квест - исполнение пророчества"))
  (halt)
)

(defrule r90
  (declare (salience 10))
  (item (name f53) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f304) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f304: Избранник пророчества + Последний шанс -> Великий квест - исполнение пророчества"))
  (halt)
)

(defrule r91
  (declare (salience 10))
  (item (name f48) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Охотник на чудовищ + Последний шанс -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r92
  (declare (salience 10))
  (item (name f47) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Проводник магии + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r93
  (declare (salience 10))
  (item (name f49) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f305) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f305: Хранитель веры + Последний шанс -> Великий квест - спасение древних земель"))
  (halt)
)

(defrule r94
  (declare (salience 10))
  (item (name f50) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f308) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f308: Разрушитель орд + Последний шанс -> Великий квест - запечатывание тьмы"))
  (halt)
)

(defrule r95
  (declare (salience 10))
  (item (name f82) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Путь мудрости + Последний шанс -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r96
  (declare (salience 10))
  (item (name f83) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Путь веры + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r97
  (declare (salience 10))
  (item (name f84) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Путь ярости + Последний шанс -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r98
  (declare (salience 10))
  (item (name f85) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f308) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f308: Путь тени + Последний шанс -> Великий квест - запечатывание тьмы"))
  (halt)
)

(defrule r99
  (declare (salience 10))
  (item (name f77) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f306) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f306: Печать стихий + Последний шанс -> Великий квест - предотвращение катастрофы"))
  (halt)
)

(defrule r100
  (declare (salience 10))
  (item (name f80) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f309) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f309: Запретная магия + Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

(defrule r101
  (declare (salience 10))
  (item (name f66) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Штурм крепости + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r102
  (declare (salience 10))
  (item (name f67) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Очищение храма + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r103
  (declare (salience 10))
  (item (name f68) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f305) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f305: Исследование катакомб + Последний шанс -> Великий квест - спасение древних земель"))
  (halt)
)

(defrule r104
  (declare (salience 10))
  (item (name f69) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f309) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f309: Защита башни + Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

(defrule r105
  (declare (salience 10))
  (item (name f70) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Восстановление моста + Последний шанс -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r106
  (declare (salience 10))
  (item (name f56) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Северный поход + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r107
  (declare (salience 10))
  (item (name f57) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f305) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f305: Лесная кампания + Последний шанс -> Великий квест - спасение древних земель"))
  (halt)
)

(defrule r108
  (declare (salience 10))
  (item (name f58) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Поход равнин + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r109
  (declare (salience 10))
  (item (name f59) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Горная экспедиция + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r110
  (declare (salience 10))
  (item (name f60) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f300) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f300: Болотная миссия + Последний шанс -> Великий квест - защита королевства"))
  (halt)
)

(defrule r111
  (declare (salience 10))
  (item (name f41) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Боевой класс + Последний шанс -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r112
  (declare (salience 10))
  (item (name f42) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f303) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f303: Магический класс + Последний шанс -> Великий квест - восстановление магического баланса"))
  (halt)
)

(defrule r113
  (declare (salience 10))
  (item (name f43) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f305) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f305: Духовный путь + Последний шанс -> Великий квест - спасение древних земель"))
  (halt)
)

(defrule r114
  (declare (salience 10))
  (item (name f44) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f301) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f301: Дикий путь + Последний шанс -> Великий квест - уничтожение дракона"))
  (halt)
)

(defrule r115
  (declare (salience 10))
  (item (name f45) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f308) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f308: Теневой путь + Последний шанс -> Великий квест - запечатывание тьмы"))
  (halt)
)

(defrule r116
  (declare (salience 10))
  (item (name f51) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f307) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f307: Связь с королевством + Последний шанс -> Великий квест - объединение королевств"))
  (halt)
)

(defrule r117
  (declare (salience 10))
  (item (name f52) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f309) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f309: Изгнанник земель + Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

(defrule r118
  (declare (salience 10))
  (item (name f54) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f308) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f308: Проклятый герой + Последний шанс -> Великий квест - запечатывание тьмы"))
  (halt)
)

(defrule r119
  (declare (salience 10))
  (item (name f55) (conf ?c0))
  (item (name f90) (conf ?c1))
  =>
  (assert (item (name f304) (conf (* 0.95 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f304: Благословлённый герой + Последний шанс -> Великий квест - исполнение пророчества"))
  (halt)
)

(defrule r120
  (declare (salience 10))
  (item (name f90) (conf ?c0))
  =>
  (assert (item (name f309) (conf (* 1.0 (min ?c0)))))
  (assert (sendmessagehalt "f309: Последний шанс -> Великий квест - последний рубеж человечества"))
  (halt)
)

