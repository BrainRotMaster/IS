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
  (slot conf (type FLOAT) (default 0.0))
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
    (assert (sendmessagehalt (sym-cat ?f1 ": \n=================================\nКоэффициент уверенности пересчитан\n=================================")))
    (halt))
)

(defrule r1
  (declare (salience 50))
  (item (name f49) (conf ?c0))
  (item (name f53) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.20 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Охотник, Снайпер -> Средняя"))
  (halt)
)

(defrule r2
  (declare (salience 50))
  (item (name f49) (conf ?c0))
  (item (name f54) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.34 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Охотник, Штурмовик -> Низкая"))
  (halt)
)

(defrule r3
  (declare (salience 50))
  (item (name f49) (conf ?c0))
  (item (name f55) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.10 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Охотник, Берсерк -> Средняя"))
  (halt)
)

(defrule r4
  (declare (salience 50))
  (item (name f49) (conf ?c0))
  (item (name f56) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.70 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Охотник, Медик -> Низкая"))
  (halt)
)

(defrule r5
  (declare (salience 50))
  (item (name f50) (conf ?c0))
  (item (name f53) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.80 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Сирена, Снайпер -> Низкая"))
  (halt)
)

(defrule r6
  (declare (salience 50))
  (item (name f50) (conf ?c0))
  (item (name f54) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.48 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Сирена, Штурмовик -> Низкая"))
  (halt)
)

(defrule r7
  (declare (salience 50))
  (item (name f50) (conf ?c0))
  (item (name f55) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.23 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Сирена, Берсерк -> Низкая"))
  (halt)
)

(defrule r8
  (declare (salience 50))
  (item (name f50) (conf ?c0))
  (item (name f56) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.34 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Сирена, Медик -> Низкая"))
  (halt)
)

(defrule r9
  (declare (salience 50))
  (item (name f51) (conf ?c0))
  (item (name f53) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.21 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Коммандор, Снайпер -> Средняя"))
  (halt)
)

(defrule r10
  (declare (salience 50))
  (item (name f51) (conf ?c0))
  (item (name f54) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.34 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Коммандор, Штурмовик -> Низкая"))
  (halt)
)

(defrule r11
  (declare (salience 50))
  (item (name f51) (conf ?c0))
  (item (name f55) (conf ?c1))
  =>
  (assert (item (name f57) (conf (* 0.87 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f57: Коммандор, Берсерк -> Высокая"))
  (halt)
)

(defrule r12
  (declare (salience 50))
  (item (name f51) (conf ?c0))
  (item (name f56) (conf ?c1))
  =>
  (assert (item (name f59) (conf (* 0.99 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f59: Коммандор, Медик -> Низкая"))
  (halt)
)

(defrule r13
  (declare (salience 50))
  (item (name f52) (conf ?c0))
  (item (name f53) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.30 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Стрелок, Снайпер -> Средняя"))
  (halt)
)

(defrule r14
  (declare (salience 50))
  (item (name f52) (conf ?c0))
  (item (name f54) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.43 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Стрелок, Штурмовик -> Средняя"))
  (halt)
)

(defrule r15
  (declare (salience 50))
  (item (name f52) (conf ?c0))
  (item (name f55) (conf ?c1))
  =>
  (assert (item (name f57) (conf (* 0.56 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f57: Стрелок, Берсерк -> Высокая"))
  (halt)
)

(defrule r16
  (declare (salience 50))
  (item (name f52) (conf ?c0))
  (item (name f56) (conf ?c1))
  =>
  (assert (item (name f58) (conf (* 0.41 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f58: Стрелок, Медик -> Средняя"))
  (halt)
)

(defrule r17
  (declare (salience 50))
  (item (name f60) (conf ?c0))
  (item (name f62) (conf ?c1))
  =>
  (assert (item (name f66) (conf (* 0.81 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f66: Старая Гавань, День -> Мародёры"))
  (halt)
)

(defrule r18
  (declare (salience 50))
  (item (name f61) (conf ?c0))
  (item (name f62) (conf ?c1))
  =>
  (assert (item (name f67) (conf (* 0.76 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f67: Старая Гавань, Вечер -> Психи"))
  (halt)
)

(defrule r19
  (declare (salience 50))
  (item (name f60) (conf ?c0))
  (item (name f63) (conf ?c1))
  =>
  (assert (item (name f68) (conf (* 0.64 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f68: Перспектива, День -> Инженеры"))
  (halt)
)

(defrule r20
  (declare (salience 50))
  (item (name f61) (conf ?c0))
  (item (name f63) (conf ?c1))
  =>
  (assert (item (name f69) (conf (* 0.83 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f69: Перспектива, Вечер -> Грузчики"))
  (halt)
)

(defrule r21
  (declare (salience 50))
  (item (name f60) (conf ?c0))
  (item (name f64) (conf ?c1))
  =>
  (assert (item (name f66) (conf (* 0.39 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f66: Айсберг Лжеца, День -> Мародёры"))
  (halt)
)

(defrule r22
  (declare (salience 50))
  (item (name f61) (conf ?c0))
  (item (name f64) (conf ?c1))
  =>
  (assert (item (name f67) (conf (* 0.21 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f67: Айсберг Лжеца, Вечер -> Психи"))
  (halt)
)

(defrule r23
  (declare (salience 50))
  (item (name f60) (conf ?c0))
  (item (name f65) (conf ?c1))
  =>
  (assert (item (name f70) (conf (* 0.98 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f70: 1000 Шрамов, День -> Бандиты на больших машинах"))
  (halt)
)

(defrule r24
  (declare (salience 50))
  (item (name f61) (conf ?c0))
  (item (name f65) (conf ?c1))
  =>
  (assert (item (name f70) (conf (* 0.38 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f70: 1000 Шрамов, Вечер -> Бандиты на больших машинах"))
  (halt)
)

(defrule r25
  (declare (salience 50))
  (item (name f57) (conf ?c0))
  (item (name f67) (conf ?c1))
  =>
  (assert (item (name f71) (conf (* 0.30 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f71: Психи, Высокая -> Земля пухом"))
  (halt)
)

(defrule r26
  (declare (salience 50))
  (item (name f58) (conf ?c0))
  (item (name f67) (conf ?c1))
  =>
  (assert (item (name f31) (conf (* 0.64 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f31: Психи, Средняя -> Штурмовая винтовка"))
  (halt)
)

(defrule r27
  (declare (salience 50))
  (item (name f59) (conf ?c0))
  (item (name f67) (conf ?c1))
  =>
  (assert (item (name f35) (conf (* 0.89 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f35: Психи, Низкая -> SMG"))
  (halt)
)

(defrule r28
  (declare (salience 50))
  (item (name f57) (conf ?c0))
  (item (name f69) (conf ?c1))
  =>
  (assert (item (name f32) (conf (* 0.87 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f32: Грузчики, Высокая -> Лаунчер"))
  (halt)
)

(defrule r29
  (declare (salience 50))
  (item (name f58) (conf ?c0))
  (item (name f69) (conf ?c1))
  =>
  (assert (item (name f31) (conf (* 0.47 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f31: Грузчики, Средняя -> Штурмовая винтовка"))
  (halt)
)

(defrule r30
  (declare (salience 50))
  (item (name f59) (conf ?c0))
  (item (name f69) (conf ?c1))
  =>
  (assert (item (name f33) (conf (* 0.51 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f33: Грузчики, Низкая -> Пистолет"))
  (halt)
)

(defrule r31
  (declare (salience 50))
  (item (name f57) (conf ?c0))
  (item (name f66) (conf ?c1))
  =>
  (assert (item (name f34) (conf (* 0.23 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f34: Мародёры, Высокая -> Дробовик"))
  (halt)
)

(defrule r32
  (declare (salience 50))
  (item (name f58) (conf ?c0))
  (item (name f66) (conf ?c1))
  =>
  (assert (item (name f36) (conf (* 0.61 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f36: Мародёры, Средняя -> Снайперская винтовка"))
  (halt)
)

(defrule r33
  (declare (salience 50))
  (item (name f59) (conf ?c0))
  (item (name f66) (conf ?c1))
  =>
  (assert (item (name f35) (conf (* 0.70 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f35: Мародёры, Низкая -> SMG"))
  (halt)
)

(defrule r34
  (declare (salience 50))
  (item (name f57) (conf ?c0))
  (item (name f70) (conf ?c1))
  =>
  (assert (item (name f34) (conf (* 0.78 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f34: Бандиты на больших машинах, Высокая -> Дробовик"))
  (halt)
)

(defrule r35
  (declare (salience 50))
  (item (name f58) (conf ?c0))
  (item (name f70) (conf ?c1))
  =>
  (assert (item (name f71) (conf (* 0.64 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f71: Бандиты на больших машинах, Средняя -> Земля пухом"))
  (halt)
)

(defrule r36
  (declare (salience 50))
  (item (name f59) (conf ?c0))
  (item (name f70) (conf ?c1))
  =>
  (assert (item (name f71) (conf (* 0.61 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f71: Бандиты на больших машинах, Низкая -> Земля пухом"))
  (halt)
)

(defrule r37
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f40) (conf (* 0.80 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f40: Дробовик, Стихийный урон -> Джейкобс"))
  (halt)
)

(defrule r38
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f39) (conf (* 0.50 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f39: Дробовик, Без стихийного урона -> Гиперион"))
  (halt)
)

(defrule r39
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f38) (conf (* 0.71 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f38: Лаунчер, Стихийный урон -> Даль"))
  (halt)
)

(defrule r40
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f37) (conf (* 0.59 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f37: Лаунчер, Без стихийного урона -> Атлас"))
  (halt)
)

(defrule r41
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f39) (conf (* 0.41 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f39: Снайперская винтовка, Стихийный урон -> Гиперион"))
  (halt)
)

(defrule r42
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f40) (conf (* 0.74 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f40: Снайперская винтовка, Без стихийного урона -> Джейкобс"))
  (halt)
)

(defrule r43
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f41) (conf (* 0.84 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f41: Штурмовая винтовка, Стихийный урон -> Малливан"))
  (halt)
)

(defrule r44
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f37) (conf (* 0.74 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f37: Штурмовая винтовка, Без стихийного урона -> Атлас"))
  (halt)
)

(defrule r45
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f42) (conf (* 0.64 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f42: Пистолет, Стихийный урон -> Тедиор"))
  (halt)
)

(defrule r46
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f38) (conf (* 0.24 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f38: Пистолет, Без стихийного урона -> Даль"))
  (halt)
)

(defrule r47
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f47) (conf ?c1))
  =>
  (assert (item (name f41) (conf (* 0.14 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f41: SMG, Стихийный урон -> Малливан"))
  (halt)
)

(defrule r48
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f48) (conf ?c1))
  =>
  (assert (item (name f42) (conf (* 0.94 (min ?c0 ?c1)))))
  (assert (sendmessagehalt "f42: SMG, Без стихийного урона -> Тедиор"))
  (halt)
)

(defrule r49
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f1) (conf (* 0.50 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f1: Даль, Пистолет, Редкий -> Мститель"))
  (halt)
)

(defrule r50
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f2) (conf (* 0.34 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f2: Даль, Пистолет, Необычный -> AAA"))
  (halt)
)

(defrule r51
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f72) (conf (* 0.97 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f72: Даль, Пистолет, Эпический -> Даль развалился и находится в нищете"))
  (halt)
)

(defrule r52
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f72) (conf (* 0.41 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f72: Даль, Пистолет, Легендарный -> Даль развалился и находится в нищете"))
  (halt)
)

(defrule r53
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f3) (conf (* 0.89 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f3: Даль, Лаунчер, Редкий -> Улей"))
  (halt)
)

(defrule r54
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f4) (conf (* 0.29 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f4: Даль, Лаунчер, Необычный -> Иерихон"))
  (halt)
)

(defrule r55
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f72) (conf (* 0.30 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f72: Даль, Лаунчер, Эпический -> Даль развалился и находится в нищете"))
  (halt)
)

(defrule r56
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f38) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f72) (conf (* 0.34 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f72: Даль, Лаунчер, Легендарный -> Даль развалился и находится в нищете"))
  (halt)
)

(defrule r57
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f73) (conf (* 0.65 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f73: Джейкобс, Дробовик, Редкий -> Джейкобс не производит ширпотреб"))
  (halt)
)

(defrule r58
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f73) (conf (* 0.94 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f73: Джейкобс, Дробовик, Необычный -> Джейкобс не производит ширпотреб"))
  (halt)
)

(defrule r59
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f5) (conf (* 0.72 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f5: Джейкобс, Дробовик, Эпический -> Аспирин"))
  (halt)
)

(defrule r60
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f6) (conf (* 0.65 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f6: Джейкобс, Дробовик, Легендарный -> Герой вечеринки"))
  (halt)
)

(defrule r61
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f73) (conf (* 0.09 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f73: Джейкобс, Снайперская винтовка, Редкий -> Джейкобс не производит ширпотреб"))
  (halt)
)

(defrule r62
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f73) (conf (* 0.11 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f73: Джейкобс, Снайперская винтовка, Необычный -> Джейкобс не производит ширпотреб"))
  (halt)
)

(defrule r63
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f7) (conf (* 0.31 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f7: Джейкобс, Снайперская винтовка, Эпический -> Хищная птица"))
  (halt)
)

(defrule r64
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f40) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f8) (conf (* 0.99 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f8: Джейкобс, Снайперская винтовка, Легендарный -> Монокль"))
  (halt)
)

(defrule r65
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f9) (conf (* 0.89 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f9: Гиперион, Дробовик, Редкий -> Феберт"))
  (halt)
)

(defrule r66
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f10) (conf (* 0.65 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f10: Гиперион, Дробовик, Необычный -> Вызов обществу"))
  (halt)
)

(defrule r67
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f74) (conf (* 0.39 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f74: Гиперион, Дробовик, Эпический -> Всё эпическое оружие Гипериона до сих пор находится в сейфе Красавчика Джека, и никто не помнит пароль"))
  (halt)
)

(defrule r68
  (declare (salience 50))
  (item (name f34) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f11) (conf (* 0.61 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f11: Гиперион, Дробовик, Легендарный -> Мордобойник"))
  (halt)
)

(defrule r69
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f12) (conf (* 0.32 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f12: Гиперион, Снайперская винтовка, Редкий -> Прокачанный арбалет"))
  (halt)
)

(defrule r70
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f13) (conf (* 0.93 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f13: Гиперион, Снайперская винтовка, Необычный -> Нулевой указатель"))
  (halt)
)

(defrule r71
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f74) (conf (* 0.51 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f74: Гиперион, Снайперская винтовка, Эпический -> Всё эпическое оружие Гипериона до сих пор находится в сейфе Красавчика Джека, и никто не помнит пароль"))
  (halt)
)

(defrule r72
  (declare (salience 50))
  (item (name f36) (conf ?c0))
  (item (name f39) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f14) (conf (* 0.91 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f14: Гиперион, Снайперская винтовка, Легендарный -> Двукратный"))
  (halt)
)

(defrule r73
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f15) (conf (* 0.85 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f15: Атлас, Лаунчер, Редкий -> Фримен"))
  (halt)
)

(defrule r74
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f16) (conf (* 0.55 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f16: Атлас, Лаунчер, Необычный -> Яхонтовый гнев"))
  (halt)
)

(defrule r75
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f17) (conf (* 0.53 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f17: Атлас, Лаунчер, Эпический -> Привет из Челябинска"))
  (halt)
)

(defrule r76
  (declare (salience 50))
  (item (name f32) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f75) (conf (* 0.71 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f75: Атлас, Лаунчер, Легендарный -> Всё легендарное оружие Атласа в данный момент используется в миссии по поиску пропавших вещей Риза Стронгфорка, обратитесь позже"))
  (halt)
)

(defrule r77
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f18) (conf (* 0.53 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f18: Атлас, Штурмовая винтовка, Редкий -> Клич повстанца"))
  (halt)
)

(defrule r78
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f19) (conf (* 0.86 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f19: Атлас, Штурмовая винтовка, Необычный -> Механизм Д.Ы.Р"))
  (halt)
)

(defrule r79
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f20) (conf (* 0.73 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f20: Атлас, Штурмовая винтовка, Эпический -> Авианосец"))
  (halt)
)

(defrule r80
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f37) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f75) (conf (* 0.31 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f75: Атлас, Штурмовая винтовка, Легендарный -> Всё легендарное оружие Атласа в данный момент используется в миссии по поиску пропавших вещей Риза Стронгфорка, обратитесь позже"))
  (halt)
)

(defrule r81
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f21) (conf (* 0.97 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f21: Тедиор, Пистолет, Редкий -> 6ЛУГ4-УБ11Ц4"))
  (halt)
)

(defrule r82
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f22) (conf (* 0.43 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f22: Тедиор, Пистолет, Необычный -> Скорпион"))
  (halt)
)

(defrule r83
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f76) (conf (* 0.70 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f76: Тедиор, Пистолет, Эпический -> Тедиор забыл как производить эпическое оружие после исчезновения Сьюзен Колдвелл"))
  (halt)
)

(defrule r84
  (declare (salience 50))
  (item (name f33) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f23) (conf (* 0.51 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f23: Тедиор, Пистолет, Легендарный -> Бумеранг"))
  (halt)
)

(defrule r85
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f24) (conf (* 0.60 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f24: Тедиор, SMG, Редкий -> Смарт-пушка"))
  (halt)
)

(defrule r86
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f25) (conf (* 0.81 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f25: Тедиор, SMG, Необычный -> Эхо"))
  (halt)
)

(defrule r87
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f76) (conf (* 0.56 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f76: Тедиор, SMG, Эпический -> Тедиор забыл как производить эпическое оружие после исчезновения Сьюзен Колдвелл"))
  (halt)
)

(defrule r88
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f42) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f26) (conf (* 0.14 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f26: Тедиор, SMG, Легендарный -> Цунами"))
  (halt)
)

(defrule r89
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f27) (conf (* 0.78 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f27: Малливан, SMG, Редкий -> Ионный лазер"))
  (halt)
)

(defrule r90
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f28) (conf (* 0.31 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f28: Малливан, SMG, Необычный -> Ген Д.Н.К."))
  (halt)
)

(defrule r91
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f77) (conf (* 0.74 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f77: Малливан, SMG, Эпический -> Всё эпическое оружие Малливан украл Атлас"))
  (halt)
)

(defrule r92
  (declare (salience 50))
  (item (name f35) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f78) (conf (* 0.24 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f78: Малливан, SMG, Легендарный -> Всё легендарное оружие Малливан прямо сейчас используется в миссии по нахождению Катагавы-младшего (если вы его видели позвоните нам)"))
  (halt)
)

(defrule r93
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f46) (conf ?c2))
  =>
  (assert (item (name f29) (conf (* 0.94 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f29: Малливан, Штурмовая винтовка, Редкий -> Ясновидец"))
  (halt)
)

(defrule r94
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f45) (conf ?c2))
  =>
  (assert (item (name f30) (conf (* 0.14 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f30: Малливан, Штурмовая винтовка, Необычный -> Мозахист"))
  (halt)
)

(defrule r95
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f44) (conf ?c2))
  =>
  (assert (item (name f77) (conf (* 0.64 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f77: Малливан, Штурмовая винтовка, Эпический -> Всё эпическое оружие Малливан украл Атлас"))
  (halt)
)

(defrule r96
  (declare (salience 50))
  (item (name f31) (conf ?c0))
  (item (name f41) (conf ?c1))
  (item (name f43) (conf ?c2))
  =>
  (assert (item (name f78) (conf (* 0.34 (min ?c0 ?c1 ?c2)))))
  (assert (sendmessagehalt "f78: Малливан, Штурмовая винтовка, Легендарный -> Всё легендарное оружие Малливан прямо сейчас используется в миссии по нахождению Катагавы-младшего (если вы его видели позвоните нам)"))
  (halt)
)

