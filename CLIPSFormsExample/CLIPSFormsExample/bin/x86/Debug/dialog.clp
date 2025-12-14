(defrule clear-message
  ?c <- (clearmessage)
=>
  (retract ?c))

(defrule wait-start
  ?a <- (answer start)
  ?io <- (ioproxy)
=>
  (retract ?a)
  (modify ?io
    (messages
      "Вопрос 1: ПК не включается?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f1))))

(defrule handle-f1-yes
  ?a <- (answer yes)
  ?q <- (asked (id f1))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f1)))
  (modify ?io
    (messages
      "Вопрос 2: Нет реакции на кнопку питания?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f2))))
(defrule handle-f1-no
  ?a <- (answer no)
  ?q <- (asked (id f1))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 2: Нет реакции на кнопку питания?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f2))))

(defrule handle-f2-yes
  ?a <- (answer yes)
  ?q <- (asked (id f2))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f2)))
  (modify ?io
    (messages
      "Вопрос 3: Вентиляторы крутятся, но изображения нет?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f3))))
(defrule handle-f2-no
  ?a <- (answer no)
  ?q <- (asked (id f2))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 3: Вентиляторы крутятся, но изображения нет?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f3))))

(defrule handle-f3-yes
  ?a <- (answer yes)
  ?q <- (asked (id f3))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f3)))
  (modify ?io
    (messages
      "Вопрос 4: ПК включается и сразу выключается?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f4))))
(defrule handle-f3-no
  ?a <- (answer no)
  ?q <- (asked (id f3))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 4: ПК включается и сразу выключается?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f4))))

(defrule handle-f4-yes
  ?a <- (answer yes)
  ?q <- (asked (id f4))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f4)))
  (modify ?io
    (messages
      "Вопрос 5: ПК перезагружается сам по себе?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f5))))
(defrule handle-f4-no
  ?a <- (answer no)
  ?q <- (asked (id f4))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 5: ПК перезагружается сам по себе?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f5))))

(defrule handle-f5-yes
  ?a <- (answer yes)
  ?q <- (asked (id f5))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f5)))
  (modify ?io
    (messages
      "Вопрос 6: Чувствуется запах гари?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f6))))
(defrule handle-f5-no
  ?a <- (answer no)
  ?q <- (asked (id f5))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 6: Чувствуется запах гари?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f6))))

(defrule handle-f6-yes
  ?a <- (answer yes)
  ?q <- (asked (id f6))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f6)))
  (modify ?io
    (messages
      "Вопрос 7: Блок питания сильно шумит?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f7))))
(defrule handle-f6-no
  ?a <- (answer no)
  ?q <- (asked (id f6))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 7: Блок питания сильно шумит?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f7))))

(defrule handle-f7-yes
  ?a <- (answer yes)
  ?q <- (asked (id f7))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f7)))
  (modify ?io
    (messages
      "Вопрос 8: Индикатор питания мигает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f8))))
(defrule handle-f7-no
  ?a <- (answer no)
  ?q <- (asked (id f7))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 8: Индикатор питания мигает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f8))))

(defrule handle-f8-yes
  ?a <- (answer yes)
  ?q <- (asked (id f8))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f8)))
  (modify ?io
    (messages
      "Вопрос 9: Нестабильное напряжение в сети?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f9))))
(defrule handle-f8-no
  ?a <- (answer no)
  ?q <- (asked (id f8))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 9: Нестабильное напряжение в сети?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f9))))

(defrule handle-f9-yes
  ?a <- (answer yes)
  ?q <- (asked (id f9))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f9)))
  (modify ?io
    (messages
      "Вопрос 10: Используется дешёвый удлинитель или тройник?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f10))))
(defrule handle-f9-no
  ?a <- (answer no)
  ?q <- (asked (id f9))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 10: Используется дешёвый удлинитель или тройник?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f10))))

(defrule handle-f10-yes
  ?a <- (answer yes)
  ?q <- (asked (id f10))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f10)))
  (modify ?io
    (messages
      "Вопрос 11: Высокая температура процессора?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f11))))
(defrule handle-f10-no
  ?a <- (answer no)
  ?q <- (asked (id f10))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 11: Высокая температура процессора?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f11))))

(defrule handle-f11-yes
  ?a <- (answer yes)
  ?q <- (asked (id f11))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f11)))
  (modify ?io
    (messages
      "Вопрос 12: Высокая температура видеокарты?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f12))))
(defrule handle-f11-no
  ?a <- (answer no)
  ?q <- (asked (id f11))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 12: Высокая температура видеокарты?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f12))))

(defrule handle-f12-yes
  ?a <- (answer yes)
  ?q <- (asked (id f12))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f12)))
  (modify ?io
    (messages
      "Вопрос 13: ПК сильно шумит под нагрузкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f13))))
(defrule handle-f12-no
  ?a <- (answer no)
  ?q <- (asked (id f12))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 13: ПК сильно шумит под нагрузкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f13))))

(defrule handle-f13-yes
  ?a <- (answer yes)
  ?q <- (asked (id f13))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f13)))
  (modify ?io
    (messages
      "Вопрос 14: Вентиляторы не вращаются?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f14))))
(defrule handle-f13-no
  ?a <- (answer no)
  ?q <- (asked (id f13))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 14: Вентиляторы не вращаются?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f14))))

(defrule handle-f14-yes
  ?a <- (answer yes)
  ?q <- (asked (id f14))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f14)))
  (modify ?io
    (messages
      "Вопрос 15: Много пыли внутри корпуса?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f15))))
(defrule handle-f14-no
  ?a <- (answer no)
  ?q <- (asked (id f14))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 15: Много пыли внутри корпуса?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f15))))

(defrule handle-f15-yes
  ?a <- (answer yes)
  ?q <- (asked (id f15))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f15)))
  (modify ?io
    (messages
      "Вопрос 16: Плохой воздушный поток в корпусе?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f16))))
(defrule handle-f15-no
  ?a <- (answer no)
  ?q <- (asked (id f15))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 16: Плохой воздушный поток в корпусе?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f16))))

(defrule handle-f16-yes
  ?a <- (answer yes)
  ?q <- (asked (id f16))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f16)))
  (modify ?io
    (messages
      "Вопрос 17: Старая или сухая термопаста?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f17))))
(defrule handle-f16-no
  ?a <- (answer no)
  ?q <- (asked (id f16))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 17: Старая или сухая термопаста?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f17))))

(defrule handle-f17-yes
  ?a <- (answer yes)
  ?q <- (asked (id f17))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f17)))
  (modify ?io
    (messages
      "Вопрос 18: Радиатор очень горячий?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f18))))
(defrule handle-f17-no
  ?a <- (answer no)
  ?q <- (asked (id f17))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 18: Радиатор очень горячий?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f18))))

(defrule handle-f18-yes
  ?a <- (answer yes)
  ?q <- (asked (id f18))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f18)))
  (modify ?io
    (messages
      "Вопрос 19: Процессор сбрасывает частоты (троттлинг)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f19))))
(defrule handle-f18-no
  ?a <- (answer no)
  ?q <- (asked (id f18))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 19: Процессор сбрасывает частоты (троттлинг)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f19))))

(defrule handle-f19-yes
  ?a <- (answer yes)
  ?q <- (asked (id f19))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f19)))
  (modify ?io
    (messages
      "Вопрос 20: Видеокарта сбрасывает частоты (троттлинг)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f20))))
(defrule handle-f19-no
  ?a <- (answer no)
  ?q <- (asked (id f19))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 20: Видеокарта сбрасывает частоты (троттлинг)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f20))))

(defrule handle-f20-yes
  ?a <- (answer yes)
  ?q <- (asked (id f20))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f20)))
  (modify ?io
    (messages
      "Вопрос 21: На мониторе нет сигнала?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f21))))
(defrule handle-f20-no
  ?a <- (answer no)
  ?q <- (asked (id f20))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 21: На мониторе нет сигнала?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f21))))

(defrule handle-f21-yes
  ?a <- (answer yes)
  ?q <- (asked (id f21))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f21)))
  (modify ?io
    (messages
      "Вопрос 22: На экране появляются артефакты?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f22))))
(defrule handle-f21-no
  ?a <- (answer no)
  ?q <- (asked (id f21))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 22: На экране появляются артефакты?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f22))))

(defrule handle-f22-yes
  ?a <- (answer yes)
  ?q <- (asked (id f22))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f22)))
  (modify ?io
    (messages
      "Вопрос 23: Изображение есть только в BIOS?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f23))))
(defrule handle-f22-no
  ?a <- (answer no)
  ?q <- (asked (id f22))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 23: Изображение есть только в BIOS?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f23))))

(defrule handle-f23-yes
  ?a <- (answer yes)
  ?q <- (asked (id f23))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f23)))
  (modify ?io
    (messages
      "Вопрос 24: Драйвер видеокарты часто вылетает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f24))))
(defrule handle-f23-no
  ?a <- (answer no)
  ?q <- (asked (id f23))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 24: Драйвер видеокарты часто вылетает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f24))))

(defrule handle-f24-yes
  ?a <- (answer yes)
  ?q <- (asked (id f24))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f24)))
  (modify ?io
    (messages
      "Вопрос 25: Монитор проверен и исправен?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f25))))
(defrule handle-f24-no
  ?a <- (answer no)
  ?q <- (asked (id f24))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 25: Монитор проверен и исправен?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f25))))

(defrule handle-f25-yes
  ?a <- (answer yes)
  ?q <- (asked (id f25))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f25)))
  (modify ?io
    (messages
      "Вопрос 26: Кабель от видеокарты к монитору исправен?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f26))))
(defrule handle-f25-no
  ?a <- (answer no)
  ?q <- (asked (id f25))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 26: Кабель от видеокарты к монитору исправен?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f26))))

(defrule handle-f26-yes
  ?a <- (answer yes)
  ?q <- (asked (id f26))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f26)))
  (modify ?io
    (messages
      "Вопрос 27: Видеокарта очень старая?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f27))))
(defrule handle-f26-no
  ?a <- (answer no)
  ?q <- (asked (id f26))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 27: Видеокарта очень старая?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f27))))

(defrule handle-f27-yes
  ?a <- (answer yes)
  ?q <- (asked (id f27))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f27)))
  (modify ?io
    (messages
      "Вопрос 28: Видеокарта сильно греется в простое?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f28))))
(defrule handle-f27-no
  ?a <- (answer no)
  ?q <- (asked (id f27))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 28: Видеокарта сильно греется в простое?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f28))))

(defrule handle-f28-yes
  ?a <- (answer yes)
  ?q <- (asked (id f28))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f28)))
  (modify ?io
    (messages
      "Вопрос 29: Разгон видеокарты включён?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f29))))
(defrule handle-f28-no
  ?a <- (answer no)
  ?q <- (asked (id f28))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 29: Разгон видеокарты включён?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f29))))

(defrule handle-f29-yes
  ?a <- (answer yes)
  ?q <- (asked (id f29))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f29)))
  (modify ?io
    (messages
      "Вопрос 30: Видеокарта издаёт писк под нагрузкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f30))))
(defrule handle-f29-no
  ?a <- (answer no)
  ?q <- (asked (id f29))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 30: Видеокарта издаёт писк под нагрузкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f30))))

(defrule handle-f30-yes
  ?a <- (answer yes)
  ?q <- (asked (id f30))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f30)))
  (modify ?io
    (messages
      "Вопрос 31: Жёсткий диск или SSD работает медленно?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f31))))
(defrule handle-f30-no
  ?a <- (answer no)
  ?q <- (asked (id f30))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 31: Жёсткий диск или SSD работает медленно?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f31))))

(defrule handle-f31-yes
  ?a <- (answer yes)
  ?q <- (asked (id f31))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f31)))
  (modify ?io
    (messages
      "Вопрос 32: Из жёсткого диска слышны щелчки или стуки?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f32))))
(defrule handle-f31-no
  ?a <- (answer no)
  ?q <- (asked (id f31))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 32: Из жёсткого диска слышны щелчки или стуки?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f32))))

(defrule handle-f32-yes
  ?a <- (answer yes)
  ?q <- (asked (id f32))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f32)))
  (modify ?io
    (messages
      "Вопрос 33: Появляются ошибки чтения или записи диска?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f33))))
(defrule handle-f32-no
  ?a <- (answer no)
  ?q <- (asked (id f32))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 33: Появляются ошибки чтения или записи диска?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f33))))

(defrule handle-f33-yes
  ?a <- (answer yes)
  ?q <- (asked (id f33))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f33)))
  (modify ?io
    (messages
      "Вопрос 34: SMART диска показывает предупреждения?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f34))))
(defrule handle-f33-no
  ?a <- (answer no)
  ?q <- (asked (id f33))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 34: SMART диска показывает предупреждения?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f34))))

(defrule handle-f34-yes
  ?a <- (answer yes)
  ?q <- (asked (id f34))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f34)))
  (modify ?io
    (messages
      "Вопрос 35: Очень мало свободного места на системном диске?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f35))))
(defrule handle-f34-no
  ?a <- (answer no)
  ?q <- (asked (id f34))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 35: Очень мало свободного места на системном диске?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f35))))

(defrule handle-f35-yes
  ?a <- (answer yes)
  ?q <- (asked (id f35))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f35)))
  (modify ?io
    (messages
      "Вопрос 36: Компьютер зависает при загрузке системы?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f36))))
(defrule handle-f35-no
  ?a <- (answer no)
  ?q <- (asked (id f35))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 36: Компьютер зависает при загрузке системы?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f36))))

(defrule handle-f36-yes
  ?a <- (answer yes)
  ?q <- (asked (id f36))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f36)))
  (modify ?io
    (messages
      "Вопрос 37: Операционная система загружается очень долго?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f37))))
(defrule handle-f36-no
  ?a <- (answer no)
  ?q <- (asked (id f36))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 37: Операционная система загружается очень долго?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f37))))

(defrule handle-f37-yes
  ?a <- (answer yes)
  ?q <- (asked (id f37))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f37)))
  (modify ?io
    (messages
      "Вопрос 38: Диск используется больше 5 лет?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f38))))
(defrule handle-f37-no
  ?a <- (answer no)
  ?q <- (asked (id f37))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 38: Диск используется больше 5 лет?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f38))))

(defrule handle-f38-yes
  ?a <- (answer yes)
  ?q <- (asked (id f38))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f38)))
  (modify ?io
    (messages
      "Вопрос 39: Диск сильно греется?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f39))))
(defrule handle-f38-no
  ?a <- (answer no)
  ?q <- (asked (id f38))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 39: Диск сильно греется?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f39))))

(defrule handle-f39-yes
  ?a <- (answer yes)
  ?q <- (asked (id f39))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f39)))
  (modify ?io
    (messages
      "Вопрос 40: SMART показывает повреждённые (bad) сектора?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f40))))
(defrule handle-f39-no
  ?a <- (answer no)
  ?q <- (asked (id f39))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 40: SMART показывает повреждённые (bad) сектора?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f40))))

(defrule handle-f40-yes
  ?a <- (answer yes)
  ?q <- (asked (id f40))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f40)))
  (modify ?io
    (messages
      "Вопрос 41: Система в целом сильно тормозит?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f41))))
(defrule handle-f40-no
  ?a <- (answer no)
  ?q <- (asked (id f40))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 41: Система в целом сильно тормозит?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f41))))

(defrule handle-f41-yes
  ?a <- (answer yes)
  ?q <- (asked (id f41))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f41)))
  (modify ?io
    (messages
      "Вопрос 42: В автозагрузке запущено много программ?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f42))))
(defrule handle-f41-no
  ?a <- (answer no)
  ?q <- (asked (id f41))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 42: В автозагрузке запущено много программ?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f42))))

(defrule handle-f42-yes
  ?a <- (answer yes)
  ?q <- (asked (id f42))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f42)))
  (modify ?io
    (messages
      "Вопрос 43: Антивирус обнаруживал вредоносные программы?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f43))))
(defrule handle-f42-no
  ?a <- (answer no)
  ?q <- (asked (id f42))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 43: Антивирус обнаруживал вредоносные программы?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f43))))

(defrule handle-f43-yes
  ?a <- (answer yes)
  ?q <- (asked (id f43))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f43)))
  (modify ?io
    (messages
      "Вопрос 44: Драйверы устройств давно не обновлялись?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f44))))
(defrule handle-f43-no
  ?a <- (answer no)
  ?q <- (asked (id f43))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 44: Драйверы устройств давно не обновлялись?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f44))))

(defrule handle-f44-yes
  ?a <- (answer yes)
  ?q <- (asked (id f44))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f44)))
  (modify ?io
    (messages
      "Вопрос 45: После обновления Windows появились ошибки?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f45))))
(defrule handle-f44-no
  ?a <- (answer no)
  ?q <- (asked (id f44))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 45: После обновления Windows появились ошибки?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f45))))

(defrule handle-f45-yes
  ?a <- (answer yes)
  ?q <- (asked (id f45))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f45)))
  (modify ?io
    (messages
      "Вопрос 46: Появляются синие экраны (BSOD)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f46))))
(defrule handle-f45-no
  ?a <- (answer no)
  ?q <- (asked (id f45))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 46: Появляются синие экраны (BSOD)?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f46))))

(defrule handle-f46-yes
  ?a <- (answer yes)
  ?q <- (asked (id f46))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f46)))
  (modify ?io
    (messages
      "Вопрос 47: Курсор мыши периодически подвисает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f47))))
(defrule handle-f46-no
  ?a <- (answer no)
  ?q <- (asked (id f46))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 47: Курсор мыши периодически подвисает?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f47))))

(defrule handle-f47-yes
  ?a <- (answer yes)
  ?q <- (asked (id f47))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f47)))
  (modify ?io
    (messages
      "Вопрос 48: Приложения часто вылетают с ошибкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f48))))
(defrule handle-f47-no
  ?a <- (answer no)
  ?q <- (asked (id f47))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 48: Приложения часто вылетают с ошибкой?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f48))))

(defrule handle-f48-yes
  ?a <- (answer yes)
  ?q <- (asked (id f48))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f48)))
  (modify ?io
    (messages
      "Вопрос 49: Загрузка процессора часто 90-100%?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f49))))
(defrule handle-f48-no
  ?a <- (answer no)
  ?q <- (asked (id f48))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 49: Загрузка процессора часто 90-100%?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f49))))

(defrule handle-f49-yes
  ?a <- (answer yes)
  ?q <- (asked (id f49))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f49)))
  (modify ?io
    (messages
      "Вопрос 50: Мало свободной оперативной памяти?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f50))))
(defrule handle-f49-no
  ?a <- (answer no)
  ?q <- (asked (id f49))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Вопрос 50: Мало свободной оперативной памяти?"
      "(да/нет)")
    (answers yes no))
  (assert (asked (id f50))))

(defrule handle-f50-yes
  ?a <- (answer yes)
  ?q <- (asked (id f50))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (assert (have (id f50)))
  (modify ?io
    (messages
      "Все ответы записаны."
      "Нажмите «Дальше», чтобы получить диагноз (если его удалось вывести).")
    (answers)))
(defrule handle-f50-no
  ?a <- (answer no)
  ?q <- (asked (id f50))
  ?io <- (ioproxy)
=>
  (retract ?a)
  (retract ?q)
  (modify ?io
    (messages
      "Все ответы записаны."
      "Нажмите «Дальше», чтобы получить диагноз (если его удалось вывести).")
    (answers)))

;;(defrule show-diagnosis-once
  ;;(not (shown (what done)))
  ;;?io <- (ioproxy)
  ;;?d  <- (diagnosis (text ?t))
;;=>
  ;;(assert (shown (what done)))
  ;;(modify ?io
    ;;(messages
      ;;"Диагноз по введённым симптомам:"
      ;;?t
      ;;"Спасибо за использование системы.")
    ;;(answers)))
