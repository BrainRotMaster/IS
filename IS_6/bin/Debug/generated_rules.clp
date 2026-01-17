(deftemplate item (slot name))
(deftemplate option (slot id) (slot label) (slot group))
(deftemplate ioproxy
  (slot fact-id)
  (multislot answers)
  (multislot messages)
  (slot reaction)
  (slot value)
  (slot restore)
)
(deftemplate asked (slot id))

(deffacts proxy-fact
  (ioproxy
    (fact-id none)
    (answers)
    (messages)
    (reaction none)
    (value none)
    (restore none))
)

(defrule clear-messages
  (declare (salience 100))
  ?c <- (clearmessage)
  ?p <- (ioproxy)
  =>
  (modify ?p (messages))
  (retract ?c))

(defrule set-output
  (declare (salience 99))
  ?m <- (sendmessage ?text)
  ?p <- (ioproxy (messages $?msgs))
  =>
  (modify ?p (messages $?msgs ?text))
  (retract ?m))

(defrule handle-user-answer
  (declare (salience 200))
  ?p <- (ioproxy (reaction answered) (value ?id))
  =>
  (assert (item (name ?id)))
  (modify ?p
     (reaction none)
     (value none)
     (answers)))

(deffacts options
  (option (id f1) (label "Рыцарь123") (group class))
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

(defrule ask-class
  (declare (salience 50))
  (not (asked (id ask_class)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_class)
     (answers (find-all-facts ((?o option)) (eq ?o:group class)))
     (reaction none)
     (value none)))

(defrule ask-kingdom
  (declare (salience 50))
  (asked (id ask_class))
  (not (asked (id ask_kingdom)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_kingdom)
     (answers (find-all-facts ((?o option)) (eq ?o:group kingdom)))
     (reaction none)
     (value none)))

(defrule ask-region
  (declare (salience 50))
  (asked (id ask_kingdom))
  (not (asked (id ask_region)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_region)
     (answers (find-all-facts ((?o option)) (eq ?o:group region)))
     (reaction none)
     (value none)))

(defrule ask-entity
  (declare (salience 50))
  (asked (id ask_region))
  (not (asked (id ask_entity)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_entity)
     (answers (find-all-facts ((?o option)) (eq ?o:group entity)))
     (reaction none)
     (value none)))

(defrule ask-artifact
  (declare (salience 50))
  (asked (id ask_entity))
  (not (asked (id ask_artifact)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_artifact)
     (answers (find-all-facts ((?o option)) (eq ?o:group artifact)))
     (reaction none)
     (value none)))

(defrule ask-state
  (declare (salience 50))
  (asked (id ask_artifact))
  (not (asked (id ask_state)))
  ?p <- (ioproxy)
  =>
  (modify ?p
     (fact-id ask_state)
     (answers (find-all-facts ((?o option)) (eq ?o:group state)))
     (reaction none)
     (value none)))

(defrule r1
  (declare (salience 10))
  (item (name f1))
  (item (name f26))
  =>
  (assert (item (name f41)))
  (assert (sendmessage "f41: Рыцарь + Магия огня -> Боевой класс"))
)

(defrule r2
  (declare (salience 10))
  (item (name f1))
  (item (name f29))
  =>
  (assert (item (name f41)))
  (assert (sendmessage "f41: Рыцарь + Магия земли -> Боевой класс"))
)

(defrule r3
  (declare (salience 10))
  (item (name f2))
  (item (name f27))
  =>
  (assert (item (name f42)))
  (assert (sendmessage "f42: Маг + Магия воды -> Магический класс"))
)

(defrule r4
  (declare (salience 10))
  (item (name f2))
  (item (name f28))
  =>
  (assert (item (name f42)))
  (assert (sendmessage "f42: Маг + Магия воздуха -> Магический класс"))
)

(defrule r5
  (declare (salience 10))
  (item (name f4))
  (item (name f24))
  =>
  (assert (item (name f43)))
  (assert (sendmessage "f43: Жрица + Священный щит -> Духовный путь"))
)

(defrule r6
  (declare (salience 10))
  (item (name f4))
  (item (name f22))
  =>
  (assert (item (name f43)))
  (assert (sendmessage "f43: Жрица + Древний посох -> Духовный путь"))
)

(defrule r7
  (declare (salience 10))
  (item (name f5))
  (item (name f30))
  =>
  (assert (item (name f44)))
  (assert (sendmessage "f44: Варвар + Магия тьмы -> Дикий путь"))
)

(defrule r8
  (declare (salience 10))
  (item (name f5))
  (item (name f26))
  =>
  (assert (item (name f44)))
  (assert (sendmessage "f44: Варвар + Магия огня -> Дикий путь"))
)

(defrule r9
  (declare (salience 10))
  (item (name f3))
  (item (name f23))
  =>
  (assert (item (name f45)))
  (assert (sendmessage "f45: Наёмник + Чёрный амулет -> Теневой путь"))
)

(defrule r10
  (declare (salience 10))
  (item (name f3))
  (item (name f25))
  =>
  (assert (item (name f45)))
  (assert (sendmessage "f45: Наёмник + Кольцо власти -> Теневой путь"))
)

(defrule r11
  (declare (salience 10))
  (item (name f1))
  (item (name f16))
  =>
  (assert (item (name f48)))
  (assert (sendmessage "f48: Рыцарь + Дракон -> Охотник на чудовищ"))
)

(defrule r12
  (declare (salience 10))
  (item (name f1))
  (item (name f17))
  =>
  (assert (item (name f46)))
  (assert (sendmessage "f46: Рыцарь + Гоблин -> Защитник королевства"))
)

(defrule r13
  (declare (salience 10))
  (item (name f2))
  (item (name f20))
  =>
  (assert (item (name f47)))
  (assert (sendmessage "f47: Маг + Нежить -> Проводник магии"))
)

(defrule r14
  (declare (salience 10))
  (item (name f4))
  (item (name f20))
  =>
  (assert (item (name f49)))
  (assert (sendmessage "f49: Жрица + Нежить -> Хранитель веры"))
)

(defrule r15
  (declare (salience 10))
  (item (name f5))
  (item (name f18))
  =>
  (assert (item (name f50)))
  (assert (sendmessage "f50: Варвар + Тролль -> Разрушитель орд"))
)

(defrule r16
  (declare (salience 10))
  (item (name f11))
  (item (name f16))
  =>
  (assert (item (name f56)))
  (assert (sendmessage "f56: Северные земли + Дракон -> Северный поход"))
)

(defrule r17
  (declare (salience 10))
  (item (name f12))
  (item (name f17))
  =>
  (assert (item (name f57)))
  (assert (sendmessage "f57: Тёмные леса + Гоблин -> Лесная кампания"))
)

(defrule r18
  (declare (salience 10))
  (item (name f13))
  (item (name f18))
  =>
  (assert (item (name f58)))
  (assert (sendmessage "f58: Солнечные равнины + Тролль -> Поход равнин"))
)

(defrule r19
  (declare (salience 10))
  (item (name f14))
  (item (name f19))
  =>
  (assert (item (name f59)))
  (assert (sendmessage "f59: Горные вершины + Волшебный зверь -> Горная экспедиция"))
)

(defrule r20
  (declare (salience 10))
  (item (name f15))
  (item (name f20))
  =>
  (assert (item (name f60)))
  (assert (sendmessage "f60: Туманные болота + Нежить -> Болотная миссия"))
)

(defrule r21
  (declare (salience 10))
  (item (name f31))
  (item (name f16))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Заброшенная крепость + Дракон -> Сломанное равновесие"))
)

(defrule r22
  (declare (salience 10))
  (item (name f32))
  (item (name f20))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Древний храм + Нежить -> Сломанное равновесие"))
)

(defrule r23
  (declare (salience 10))
  (item (name f33))
  (item (name f18))
  =>
  (assert (item (name f79)))
  (assert (sendmessage "f79: Катакомбы + Тролль -> Потерянное знание"))
)

(defrule r24
  (declare (salience 10))
  (item (name f34))
  (item (name f17))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Магическая башня + Гоблин -> Сломанное равновесие"))
)

(defrule r25
  (declare (salience 10))
  (item (name f35))
  (item (name f19))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Разрушенный мост + Волшебный зверь -> Сломанное равновесие"))
)

(defrule r26
  (declare (salience 10))
  (item (name f26))
  (item (name f16))
  =>
  (assert (item (name f61)))
  (assert (sendmessage "f61: Магия огня + Дракон -> Контроль огня"))
)

(defrule r27
  (declare (salience 10))
  (item (name f27))
  (item (name f20))
  =>
  (assert (item (name f62)))
  (assert (sendmessage "f62: Магия воды + Нежить -> Контроль воды"))
)

(defrule r28
  (declare (salience 10))
  (item (name f28))
  (item (name f19))
  =>
  (assert (item (name f63)))
  (assert (sendmessage "f63: Магия воздуха + Волшебный зверь -> Контроль воздуха"))
)

(defrule r29
  (declare (salience 10))
  (item (name f29))
  (item (name f18))
  =>
  (assert (item (name f64)))
  (assert (sendmessage "f64: Магия земли + Тролль -> Контроль земли"))
)

(defrule r30
  (declare (salience 10))
  (item (name f30))
  (item (name f17))
  =>
  (assert (item (name f65)))
  (assert (sendmessage "f65: Магия тьмы + Гоблин -> Контроль тьмы"))
)

(defrule r31
  (declare (salience 10))
  (item (name f56))
  (item (name f78))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Северный поход + Сломанное равновесие -> Последний шанс"))
)

(defrule r32
  (declare (salience 10))
  (item (name f57))
  (item (name f78))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Лесная кампания + Сломанное равновесие -> Последний шанс"))
)

(defrule r33
  (declare (salience 10))
  (item (name f58))
  (item (name f79))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Поход равнин + Потерянное знание -> Последний шанс"))
)

(defrule r34
  (declare (salience 10))
  (item (name f59))
  (item (name f78))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Горная экспедиция + Сломанное равновесие -> Последний шанс"))
)

(defrule r35
  (declare (salience 10))
  (item (name f60))
  (item (name f78))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Болотная миссия + Сломанное равновесие -> Последний шанс"))
)

(defrule r36
  (declare (salience 10))
  (item (name f38))
  (item (name f78))
  =>
  (assert (item (name f53)))
  (assert (sendmessage "f53: Пророчество + Сломанное равновесие -> Избранник пророчества"))
)

(defrule r37
  (declare (salience 10))
  (item (name f38))
  (item (name f79))
  =>
  (assert (item (name f53)))
  (assert (sendmessage "f53: Пророчество + Потерянное знание -> Избранник пророчества"))
)

(defrule r38
  (declare (salience 10))
  (item (name f37))
  (item (name f56))
  =>
  (assert (item (name f55)))
  (assert (sendmessage "f55: Мирное время + Северный поход -> Благословлённый герой"))
)

(defrule r39
  (declare (salience 10))
  (item (name f36))
  (item (name f78))
  =>
  (assert (item (name f54)))
  (assert (sendmessage "f54: Угроза миру + Сломанное равновесие -> Проклятый герой"))
)

(defrule r40
  (declare (salience 10))
  (item (name f36))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Угроза миру + Последний шанс -> Последний шанс"))
)

(defrule r41
  (declare (salience 10))
  (item (name f41))
  (item (name f71))
  =>
  (assert (item (name f48)))
  (assert (sendmessage "f48: Боевой класс + Драконья угроза -> Охотник на чудовищ"))
)

(defrule r42
  (declare (salience 10))
  (item (name f42))
  (item (name f75))
  =>
  (assert (item (name f47)))
  (assert (sendmessage "f47: Магический класс + Восстание нежити -> Проводник магии"))
)

(defrule r43
  (declare (salience 10))
  (item (name f43))
  (item (name f78))
  =>
  (assert (item (name f49)))
  (assert (sendmessage "f49: Духовный путь + Сломанное равновесие -> Хранитель веры"))
)

(defrule r44
  (declare (salience 10))
  (item (name f44))
  (item (name f72))
  =>
  (assert (item (name f50)))
  (assert (sendmessage "f50: Дикий путь + Нашествие гоблинов -> Разрушитель орд"))
)

(defrule r45
  (declare (salience 10))
  (item (name f45))
  (item (name f73))
  =>
  (assert (item (name f48)))
  (assert (sendmessage "f48: Теневой путь + Ярость троллей -> Охотник на чудовищ"))
)

(defrule r46
  (declare (salience 10))
  (item (name f61))
  (item (name f76))
  =>
  (assert (item (name f77)))
  (assert (sendmessage "f77: Контроль огня + Древний ритуал -> Печать стихий"))
)

(defrule r47
  (declare (salience 10))
  (item (name f62))
  (item (name f76))
  =>
  (assert (item (name f77)))
  (assert (sendmessage "f77: Контроль воды + Древний ритуал -> Печать стихий"))
)

(defrule r48
  (declare (salience 10))
  (item (name f63))
  (item (name f76))
  =>
  (assert (item (name f77)))
  (assert (sendmessage "f77: Контроль воздуха + Древний ритуал -> Печать стихий"))
)

(defrule r49
  (declare (salience 10))
  (item (name f64))
  (item (name f76))
  =>
  (assert (item (name f77)))
  (assert (sendmessage "f77: Контроль земли + Древний ритуал -> Печать стихий"))
)

(defrule r50
  (declare (salience 10))
  (item (name f65))
  (item (name f76))
  =>
  (assert (item (name f80)))
  (assert (sendmessage "f80: Контроль тьмы + Древний ритуал -> Запретная магия"))
)

(defrule r51
  (declare (salience 10))
  (item (name f56))
  (item (name f71))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Северный поход + Драконья угроза -> Последний шанс"))
)

(defrule r52
  (declare (salience 10))
  (item (name f57))
  (item (name f72))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Лесная кампания + Нашествие гоблинов -> Последний шанс"))
)

(defrule r53
  (declare (salience 10))
  (item (name f58))
  (item (name f73))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Поход равнин + Ярость троллей -> Последний шанс"))
)

(defrule r54
  (declare (salience 10))
  (item (name f59))
  (item (name f74))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Горная экспедиция + Звериный хаос -> Последний шанс"))
)

(defrule r55
  (declare (salience 10))
  (item (name f60))
  (item (name f75))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Болотная миссия + Восстание нежити -> Последний шанс"))
)

(defrule r56
  (declare (salience 10))
  (item (name f66))
  (item (name f71))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Штурм крепости + Драконья угроза -> Сломанное равновесие"))
)

(defrule r57
  (declare (salience 10))
  (item (name f67))
  (item (name f75))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Очищение храма + Восстание нежити -> Сломанное равновесие"))
)

(defrule r58
  (declare (salience 10))
  (item (name f68))
  (item (name f73))
  =>
  (assert (item (name f79)))
  (assert (sendmessage "f79: Исследование катакомб + Ярость троллей -> Потерянное знание"))
)

(defrule r59
  (declare (salience 10))
  (item (name f69))
  (item (name f72))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Защита башни + Нашествие гоблинов -> Сломанное равновесие"))
)

(defrule r60
  (declare (salience 10))
  (item (name f70))
  (item (name f74))
  =>
  (assert (item (name f78)))
  (assert (sendmessage "f78: Восстановление моста + Звериный хаос -> Сломанное равновесие"))
)

(defrule r61
  (declare (salience 10))
  (item (name f81))
  (item (name f71))
  =>
  (assert (item (name f71)))
  (assert (sendmessage "f71: Путь силы + Драконья угроза -> Драконья угроза"))
)

(defrule r62
  (declare (salience 10))
  (item (name f82))
  (item (name f79))
  =>
  (assert (item (name f82)))
  (assert (sendmessage "f82: Путь мудрости + Потерянное знание -> Путь мудрости"))
)

(defrule r63
  (declare (salience 10))
  (item (name f83))
  (item (name f78))
  =>
  (assert (item (name f83)))
  (assert (sendmessage "f83: Путь веры + Сломанное равновесие -> Путь веры"))
)

(defrule r64
  (declare (salience 10))
  (item (name f84))
  (item (name f72))
  =>
  (assert (item (name f84)))
  (assert (sendmessage "f84: Путь ярости + Нашествие гоблинов -> Путь ярости"))
)

(defrule r65
  (declare (salience 10))
  (item (name f85))
  (item (name f75))
  =>
  (assert (item (name f85)))
  (assert (sendmessage "f85: Путь тени + Восстание нежити -> Путь тени"))
)

(defrule r66
  (declare (salience 10))
  (item (name f53))
  (item (name f77))
  =>
  (assert (item (name f89)))
  (assert (sendmessage "f89: Избранник пророчества + Печать стихий -> Возрождение древних"))
)

(defrule r67
  (declare (salience 10))
  (item (name f88))
  (item (name f80))
  =>
  (assert (item (name f87)))
  (assert (sendmessage "f87: Падение магии + Запретная магия -> Раскол мира"))
)

(defrule r68
  (declare (salience 10))
  (item (name f90))
  (item (name f78))
  =>
  (assert (item (name f86)))
  (assert (sendmessage "f86: Последний шанс + Сломанное равновесие -> Союз королевств"))
)

(defrule r69
  (declare (salience 10))
  (item (name f79))
  (item (name f82))
  =>
  (assert (item (name f82)))
  (assert (sendmessage "f82: Потерянное знание + Путь мудрости -> Путь мудрости"))
)

(defrule r70
  (declare (salience 10))
  (item (name f55))
  (item (name f83))
  =>
  (assert (item (name f55)))
  (assert (sendmessage "f55: Благословлённый герой + Путь веры -> Благословлённый герой"))
)

(defrule r71
  (declare (salience 10))
  (item (name f48))
  (item (name f71))
  =>
  (assert (item (name f71)))
  (assert (sendmessage "f71: Охотник на чудовищ + Драконья угроза -> Драконья угроза"))
)

(defrule r72
  (declare (salience 10))
  (item (name f47))
  (item (name f75))
  =>
  (assert (item (name f75)))
  (assert (sendmessage "f75: Проводник магии + Восстание нежити -> Восстание нежити"))
)

(defrule r73
  (declare (salience 10))
  (item (name f49))
  (item (name f78))
  =>
  (assert (item (name f83)))
  (assert (sendmessage "f83: Хранитель веры + Сломанное равновесие -> Путь веры"))
)

(defrule r74
  (declare (salience 10))
  (item (name f50))
  (item (name f72))
  =>
  (assert (item (name f72)))
  (assert (sendmessage "f72: Разрушитель орд + Нашествие гоблинов -> Нашествие гоблинов"))
)

(defrule r75
  (declare (salience 10))
  (item (name f48))
  (item (name f73))
  =>
  (assert (item (name f73)))
  (assert (sendmessage "f73: Охотник на чудовищ + Ярость троллей -> Ярость троллей"))
)

(defrule r76
  (declare (salience 10))
  (item (name f86))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Союз королевств + Последний шанс -> Последний шанс"))
)

(defrule r77
  (declare (salience 10))
  (item (name f87))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Раскол мира + Последний шанс -> Последний шанс"))
)

(defrule r78
  (declare (salience 10))
  (item (name f89))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Возрождение древних + Последний шанс -> Последний шанс"))
)

(defrule r79
  (declare (salience 10))
  (item (name f88))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Падение магии + Последний шанс -> Последний шанс"))
)

(defrule r80
  (declare (salience 10))
  (item (name f78))
  (item (name f90))
  =>
  (assert (item (name f90)))
  (assert (sendmessage "f90: Сломанное равновесие + Последний шанс -> Последний шанс"))
)

(defrule r81
  (declare (salience 10))
  (item (name f71))
  (item (name f90))
  =>
  (assert (item (name f301)))
  (assert (sendmessage "f301: Драконья угроза + Последний шанс -> Великий квест - уничтожение дракона"))
)

(defrule r82
  (declare (salience 10))
  (item (name f75))
  (item (name f90))
  =>
  (assert (item (name f302)))
  (assert (sendmessage "f302: Восстание нежити + Последний шанс -> Великий квест - очищение мира от нежити"))
)

(defrule r83
  (declare (salience 10))
  (item (name f78))
  (item (name f90))
  =>
  (assert (item (name f306)))
  (assert (sendmessage "f306: Сломанное равновесие + Последний шанс -> Великий квест - предотвращение катастрофы"))
)

(defrule r84
  (declare (salience 10))
  (item (name f79))
  (item (name f90))
  =>
  (assert (item (name f303)))
  (assert (sendmessage "f303: Потерянное знание + Последний шанс -> Великий квест - восстановление магического баланса"))
)

(defrule r85
  (declare (salience 10))
  (item (name f89))
  (item (name f90))
  =>
  (assert (item (name f307)))
  (assert (sendmessage "f307: Возрождение древних + Последний шанс -> Великий квест - объединение королевств"))
)

(defrule r86
  (declare (salience 10))
  (item (name f86))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Союз королевств + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r87
  (declare (salience 10))
  (item (name f87))
  (item (name f90))
  =>
  (assert (item (name f309)))
  (assert (sendmessage "f309: Раскол мира + Последний шанс -> Великий квест - последний рубеж человечества"))
)

(defrule r88
  (declare (salience 10))
  (item (name f88))
  (item (name f90))
  =>
  (assert (item (name f303)))
  (assert (sendmessage "f303: Падение магии + Последний шанс -> Великий квест - восстановление магического баланса"))
)

(defrule r89
  (declare (salience 10))
  (item (name f55))
  (item (name f90))
  =>
  (assert (item (name f304)))
  (assert (sendmessage "f304: Благословлённый герой + Последний шанс -> Великий квест - исполнение пророчества"))
)

(defrule r90
  (declare (salience 10))
  (item (name f53))
  (item (name f90))
  =>
  (assert (item (name f304)))
  (assert (sendmessage "f304: Избранник пророчества + Последний шанс -> Великий квест - исполнение пророчества"))
)

(defrule r91
  (declare (salience 10))
  (item (name f48))
  (item (name f90))
  =>
  (assert (item (name f301)))
  (assert (sendmessage "f301: Охотник на чудовищ + Последний шанс -> Великий квест - уничтожение дракона"))
)

(defrule r92
  (declare (salience 10))
  (item (name f47))
  (item (name f90))
  =>
  (assert (item (name f303)))
  (assert (sendmessage "f303: Проводник магии + Последний шанс -> Великий квест - восстановление магического баланса"))
)

(defrule r93
  (declare (salience 10))
  (item (name f49))
  (item (name f90))
  =>
  (assert (item (name f305)))
  (assert (sendmessage "f305: Хранитель веры + Последний шанс -> Великий квест - спасение древних земель"))
)

(defrule r94
  (declare (salience 10))
  (item (name f50))
  (item (name f90))
  =>
  (assert (item (name f308)))
  (assert (sendmessage "f308: Разрушитель орд + Последний шанс -> Великий квест - запечатывание тьмы"))
)

(defrule r95
  (declare (salience 10))
  (item (name f82))
  (item (name f90))
  =>
  (assert (item (name f307)))
  (assert (sendmessage "f307: Путь мудрости + Последний шанс -> Великий квест - объединение королевств"))
)

(defrule r96
  (declare (salience 10))
  (item (name f83))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Путь веры + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r97
  (declare (salience 10))
  (item (name f84))
  (item (name f90))
  =>
  (assert (item (name f301)))
  (assert (sendmessage "f301: Путь ярости + Последний шанс -> Великий квест - уничтожение дракона"))
)

(defrule r98
  (declare (salience 10))
  (item (name f85))
  (item (name f90))
  =>
  (assert (item (name f308)))
  (assert (sendmessage "f308: Путь тени + Последний шанс -> Великий квест - запечатывание тьмы"))
)

(defrule r99
  (declare (salience 10))
  (item (name f77))
  (item (name f90))
  =>
  (assert (item (name f306)))
  (assert (sendmessage "f306: Печать стихий + Последний шанс -> Великий квест - предотвращение катастрофы"))
)

(defrule r100
  (declare (salience 10))
  (item (name f80))
  (item (name f90))
  =>
  (assert (item (name f309)))
  (assert (sendmessage "f309: Запретная магия + Последний шанс -> Великий квест - последний рубеж человечества"))
)

(defrule r101
  (declare (salience 10))
  (item (name f66))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Штурм крепости + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r102
  (declare (salience 10))
  (item (name f67))
  (item (name f90))
  =>
  (assert (item (name f303)))
  (assert (sendmessage "f303: Очищение храма + Последний шанс -> Великий квест - восстановление магического баланса"))
)

(defrule r103
  (declare (salience 10))
  (item (name f68))
  (item (name f90))
  =>
  (assert (item (name f305)))
  (assert (sendmessage "f305: Исследование катакомб + Последний шанс -> Великий квест - спасение древних земель"))
)

(defrule r104
  (declare (salience 10))
  (item (name f69))
  (item (name f90))
  =>
  (assert (item (name f309)))
  (assert (sendmessage "f309: Защита башни + Последний шанс -> Великий квест - последний рубеж человечества"))
)

(defrule r105
  (declare (salience 10))
  (item (name f70))
  (item (name f90))
  =>
  (assert (item (name f307)))
  (assert (sendmessage "f307: Восстановление моста + Последний шанс -> Великий квест - объединение королевств"))
)

(defrule r106
  (declare (salience 10))
  (item (name f56))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Северный поход + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r107
  (declare (salience 10))
  (item (name f57))
  (item (name f90))
  =>
  (assert (item (name f305)))
  (assert (sendmessage "f305: Лесная кампания + Последний шанс -> Великий квест - спасение древних земель"))
)

(defrule r108
  (declare (salience 10))
  (item (name f58))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Поход равнин + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r109
  (declare (salience 10))
  (item (name f59))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Горная экспедиция + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r110
  (declare (salience 10))
  (item (name f60))
  (item (name f90))
  =>
  (assert (item (name f300)))
  (assert (sendmessage "f300: Болотная миссия + Последний шанс -> Великий квест - защита королевства"))
)

(defrule r111
  (declare (salience 10))
  (item (name f41))
  (item (name f90))
  =>
  (assert (item (name f301)))
  (assert (sendmessage "f301: Боевой класс + Последний шанс -> Великий квест - уничтожение дракона"))
)

(defrule r112
  (declare (salience 10))
  (item (name f42))
  (item (name f90))
  =>
  (assert (item (name f303)))
  (assert (sendmessage "f303: Магический класс + Последний шанс -> Великий квест - восстановление магического баланса"))
)

(defrule r113
  (declare (salience 10))
  (item (name f43))
  (item (name f90))
  =>
  (assert (item (name f305)))
  (assert (sendmessage "f305: Духовный путь + Последний шанс -> Великий квест - спасение древних земель"))
)

(defrule r114
  (declare (salience 10))
  (item (name f44))
  (item (name f90))
  =>
  (assert (item (name f301)))
  (assert (sendmessage "f301: Дикий путь + Последний шанс -> Великий квест - уничтожение дракона"))
)

(defrule r115
  (declare (salience 10))
  (item (name f45))
  (item (name f90))
  =>
  (assert (item (name f308)))
  (assert (sendmessage "f308: Теневой путь + Последний шанс -> Великий квест - запечатывание тьмы"))
)

(defrule r116
  (declare (salience 10))
  (item (name f51))
  (item (name f90))
  =>
  (assert (item (name f307)))
  (assert (sendmessage "f307: Связь с королевством + Последний шанс -> Великий квест - объединение королевств"))
)

(defrule r117
  (declare (salience 10))
  (item (name f52))
  (item (name f90))
  =>
  (assert (item (name f309)))
  (assert (sendmessage "f309: Изгнанник земель + Последний шанс -> Великий квест - последний рубеж человечества"))
)

(defrule r118
  (declare (salience 10))
  (item (name f54))
  (item (name f90))
  =>
  (assert (item (name f308)))
  (assert (sendmessage "f308: Проклятый герой + Последний шанс -> Великий квест - запечатывание тьмы"))
)

(defrule r119
  (declare (salience 10))
  (item (name f55))
  (item (name f90))
  =>
  (assert (item (name f304)))
  (assert (sendmessage "f304: Благословлённый герой + Последний шанс -> Великий квест - исполнение пророчества"))
)

(defrule r120
  (declare (salience 10))
  (item (name f90))
  =>
  (assert (item (name f309)))
  (assert (sendmessage "f309: Последний шанс -> Великий квест - последний рубеж человечества"))
)

