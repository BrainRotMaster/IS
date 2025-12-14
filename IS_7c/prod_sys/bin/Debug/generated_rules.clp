(defrule clear-message
  (declare (salience 90))
  ?clear-msg-flg <- (clearmessage)
  ?sendmessage <- (sendmessagehalt ?msg)
  =>
  (retract ?clear-msg-flg)
  (retract ?sendmessage)
)

(deftemplate item
  (slot name (default none))
)

(defrule r1
  (declare (salience 50))
  (item (name f1))
  =>
  (assert (item (name f101)))
  (assert (sendmessagehalt "f101: Рыцарь -> боевой класс"))
  (halt)
)

(defrule r2
  (declare (salience 50))
  (item (name f2))
  =>
  (assert (item (name f102)))
  (assert (sendmessagehalt "f102: Маг -> магический класс"))
  (halt)
)

(defrule r3
  (declare (salience 50))
  (item (name f3))
  =>
  (assert (item (name f103)))
  (assert (sendmessagehalt "f103: Наемник -> вольный класс"))
  (halt)
)

(defrule r4
  (declare (salience 50))
  (item (name f4))
  =>
  (assert (item (name f104)))
  (assert (sendmessagehalt "f104: Жрица -> духовный класс"))
  (halt)
)

(defrule r5
  (declare (salience 50))
  (item (name f5))
  =>
  (assert (item (name f105)))
  (assert (sendmessagehalt "f105: Варвар -> дикий класс"))
  (halt)
)

(defrule r6
  (declare (salience 50))
  (item (name f101))
  (item (name f6))
  =>
  (assert (item (name f120)))
  (assert (sendmessagehalt "f120: Боевой класс + Алендор -> рыцарь Алендора"))
  (halt)
)

(defrule r7
  (declare (salience 50))
  (item (name f101))
  (item (name f7))
  =>
  (assert (item (name f121)))
  (assert (sendmessagehalt "f121: Боевой класс + Моргир -> рыцарь Моргира"))
  (halt)
)

(defrule r8
  (declare (salience 50))
  (item (name f101))
  (item (name f8))
  =>
  (assert (item (name f122)))
  (assert (sendmessagehalt "f122: Боевой класс + Тарн -> рыцарь Тарна"))
  (halt)
)

(defrule r9
  (declare (salience 50))
  (item (name f101))
  (item (name f9))
  =>
  (assert (item (name f123)))
  (assert (sendmessagehalt "f123: Боевой класс + Хольм -> рыцарь Хольма"))
  (halt)
)

(defrule r10
  (declare (salience 50))
  (item (name f10))
  (item (name f101))
  =>
  (assert (item (name f124)))
  (assert (sendmessagehalt "f124: Боевой класс + Эльдаран -> рыцарь Эльдарана"))
  (halt)
)

(defrule r11
  (declare (salience 50))
  (item (name f102))
  (item (name f6))
  =>
  (assert (item (name f125)))
  (assert (sendmessagehalt "f125: Маг + Алендор -> маг Алендора"))
  (halt)
)

(defrule r12
  (declare (salience 50))
  (item (name f102))
  (item (name f7))
  =>
  (assert (item (name f126)))
  (assert (sendmessagehalt "f126: Маг + Моргир -> маг Моргира"))
  (halt)
)

(defrule r13
  (declare (salience 50))
  (item (name f102))
  (item (name f8))
  =>
  (assert (item (name f127)))
  (assert (sendmessagehalt "f127: Маг + Тарн -> маг Тарна"))
  (halt)
)

(defrule r14
  (declare (salience 50))
  (item (name f102))
  (item (name f9))
  =>
  (assert (item (name f128)))
  (assert (sendmessagehalt "f128: Маг + Хольм -> маг Хольма"))
  (halt)
)

(defrule r15
  (declare (salience 50))
  (item (name f10))
  (item (name f102))
  =>
  (assert (item (name f129)))
  (assert (sendmessagehalt "f129: Маг + Эльдаран -> маг Эльдарана"))
  (halt)
)

(defrule r16
  (declare (salience 50))
  (item (name f11))
  (item (name f120))
  =>
  (assert (item (name f150)))
  (assert (sendmessagehalt "f150: Рыцарь Алендора + север -> зона 1"))
  (halt)
)

(defrule r17
  (declare (salience 50))
  (item (name f12))
  (item (name f120))
  =>
  (assert (item (name f151)))
  (assert (sendmessagehalt "f151: Рыцарь Алендора + леса -> зона 2"))
  (halt)
)

(defrule r18
  (declare (salience 50))
  (item (name f120))
  (item (name f13))
  =>
  (assert (item (name f152)))
  (assert (sendmessagehalt "f152: Рыцарь Алендора + равнины -> зона 3"))
  (halt)
)

(defrule r19
  (declare (salience 50))
  (item (name f120))
  (item (name f14))
  =>
  (assert (item (name f153)))
  (assert (sendmessagehalt "f153: Рыцарь Алендора + горы -> зона 4"))
  (halt)
)

(defrule r20
  (declare (salience 50))
  (item (name f120))
  (item (name f15))
  =>
  (assert (item (name f154)))
  (assert (sendmessagehalt "f154: Рыцарь Алендора + болота -> зона 5"))
  (halt)
)

(defrule r21
  (declare (salience 50))
  (item (name f11))
  (item (name f125))
  =>
  (assert (item (name f150)))
  (assert (sendmessagehalt "f150: Маг Алендора + север -> зона 1"))
  (halt)
)

(defrule r22
  (declare (salience 50))
  (item (name f12))
  (item (name f125))
  =>
  (assert (item (name f151)))
  (assert (sendmessagehalt "f151: Маг Алендора + леса -> зона 2"))
  (halt)
)

(defrule r23
  (declare (salience 50))
  (item (name f125))
  (item (name f13))
  =>
  (assert (item (name f152)))
  (assert (sendmessagehalt "f152: Маг Алендора + равнины -> зона 3"))
  (halt)
)

(defrule r24
  (declare (salience 50))
  (item (name f125))
  (item (name f14))
  =>
  (assert (item (name f153)))
  (assert (sendmessagehalt "f153: Маг Алендора + горы -> зона 4"))
  (halt)
)

(defrule r25
  (declare (salience 50))
  (item (name f125))
  (item (name f15))
  =>
  (assert (item (name f154)))
  (assert (sendmessagehalt "f154: Маг Алендора + болота -> зона 5"))
  (halt)
)

(defrule r26
  (declare (salience 50))
  (item (name f150))
  (item (name f16))
  =>
  (assert (item (name f180)))
  (assert (sendmessagehalt "f180: Зона 1 + дракон -> угроза 1"))
  (halt)
)

(defrule r27
  (declare (salience 50))
  (item (name f150))
  (item (name f17))
  =>
  (assert (item (name f181)))
  (assert (sendmessagehalt "f181: Зона 1 + гоблины -> угроза 2"))
  (halt)
)

(defrule r28
  (declare (salience 50))
  (item (name f150))
  (item (name f18))
  =>
  (assert (item (name f182)))
  (assert (sendmessagehalt "f182: Зона 1 + тролли -> угроза 3"))
  (halt)
)

(defrule r29
  (declare (salience 50))
  (item (name f150))
  (item (name f19))
  =>
  (assert (item (name f183)))
  (assert (sendmessagehalt "f183: Зона 1 + зверь -> угроза 4"))
  (halt)
)

(defrule r30
  (declare (salience 50))
  (item (name f150))
  (item (name f20))
  =>
  (assert (item (name f184)))
  (assert (sendmessagehalt "f184: Зона 1 + нежить -> угроза 5"))
  (halt)
)

(defrule r51
  (declare (salience 50))
  (item (name f180))
  (item (name f21))
  =>
  (assert (item (name f230)))
  (assert (sendmessagehalt "f230: Угроза 1 + меч -> путь 1"))
  (halt)
)

(defrule r52
  (declare (salience 50))
  (item (name f180))
  (item (name f22))
  =>
  (assert (item (name f231)))
  (assert (sendmessagehalt "f231: Угроза 1 + посох -> путь 2"))
  (halt)
)

(defrule r53
  (declare (salience 50))
  (item (name f180))
  (item (name f23))
  =>
  (assert (item (name f232)))
  (assert (sendmessagehalt "f232: Угроза 1 + амулет -> путь 3"))
  (halt)
)

(defrule r54
  (declare (salience 50))
  (item (name f180))
  (item (name f24))
  =>
  (assert (item (name f233)))
  (assert (sendmessagehalt "f233: Угроза 1 + щит -> путь 4"))
  (halt)
)

(defrule r55
  (declare (salience 50))
  (item (name f180))
  (item (name f25))
  =>
  (assert (item (name f234)))
  (assert (sendmessagehalt "f234: Угроза 1 + кольцо -> путь 5"))
  (halt)
)

(defrule r56
  (declare (salience 50))
  (item (name f181))
  (item (name f21))
  =>
  (assert (item (name f235)))
  (assert (sendmessagehalt "f235: Угроза 2 + меч -> путь 6"))
  (halt)
)

(defrule r57
  (declare (salience 50))
  (item (name f181))
  (item (name f22))
  =>
  (assert (item (name f236)))
  (assert (sendmessagehalt "f236: Угроза 2 + посох -> путь 7"))
  (halt)
)

(defrule r58
  (declare (salience 50))
  (item (name f181))
  (item (name f23))
  =>
  (assert (item (name f237)))
  (assert (sendmessagehalt "f237: Угроза 2 + амулет -> путь 8"))
  (halt)
)

(defrule r59
  (declare (salience 50))
  (item (name f181))
  (item (name f24))
  =>
  (assert (item (name f238)))
  (assert (sendmessagehalt "f238: Угроза 2 + щит -> путь 9"))
  (halt)
)

(defrule r60
  (declare (salience 50))
  (item (name f181))
  (item (name f25))
  =>
  (assert (item (name f239)))
  (assert (sendmessagehalt "f239: Угроза 2 + кольцо -> путь 10"))
  (halt)
)

(defrule r121
  (declare (salience 50))
  (item (name f230))
  (item (name f36))
  =>
  (assert (item (name f300)))
  (assert (sendmessagehalt "f300: Путь 1 + угроза миру -> защитить север"))
  (halt)
)

(defrule r122
  (declare (salience 50))
  (item (name f231))
  (item (name f36))
  =>
  (assert (item (name f301)))
  (assert (sendmessagehalt "f301: Путь 2 + угроза миру -> изгнание тьмы"))
  (halt)
)

(defrule r123
  (declare (salience 50))
  (item (name f232))
  (item (name f36))
  =>
  (assert (item (name f302)))
  (assert (sendmessagehalt "f302: Путь 3 + угроза миру -> победа над драконом"))
  (halt)
)

(defrule r124
  (declare (salience 50))
  (item (name f233))
  (item (name f40))
  =>
  (assert (item (name f303)))
  (assert (sendmessagehalt "f303: Путь 4 + рост тьмы -> очистить храм"))
  (halt)
)

(defrule r125
  (declare (salience 50))
  (item (name f234))
  (item (name f40))
  =>
  (assert (item (name f304)))
  (assert (sendmessagehalt "f304: Путь 5 + рост тьмы -> остановить нежить"))
  (halt)
)

(defrule r126
  (declare (salience 50))
  (item (name f235))
  (item (name f38))
  =>
  (assert (item (name f305)))
  (assert (sendmessagehalt "f305: Путь 6 + пророчество -> исполнить пророчество огня"))
  (halt)
)

(defrule r127
  (declare (salience 50))
  (item (name f236))
  (item (name f38))
  =>
  (assert (item (name f306)))
  (assert (sendmessagehalt "f306: Путь 7 + пророчество -> восстановить магию"))
  (halt)
)

(defrule r128
  (declare (salience 50))
  (item (name f237))
  (item (name f39))
  =>
  (assert (item (name f307)))
  (assert (sendmessagehalt "f307: Путь 8 + ослабление магии -> уничтожить амулет тьмы"))
  (halt)
)

(defrule r129
  (declare (salience 50))
  (item (name f238))
  (item (name f39))
  =>
  (assert (item (name f308)))
  (assert (sendmessagehalt "f308: Путь 9 + ослабление магии -> защитить башню магов"))
  (halt)
)

(defrule r130
  (declare (salience 50))
  (item (name f239))
  (item (name f39))
  =>
  (assert (item (name f309)))
  (assert (sendmessagehalt "f309: Путь 10 + ослабление магии -> освободить разумы"))
  (halt)
)

(defrule r1000
  (declare (salience 50))
  (item (name f302))
  (item (name f304))
  (item (name f308))
  =>
  (assert (item (name f1000)))
  (assert (sendmessagehalt "f1000: Целевой квест"))
  (halt)
)

