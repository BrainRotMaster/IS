with open("generated_rules.clp", 'w', encoding='utf8') as o, open("rules.txt", encoding='utf8') as f:
    o.write(
'''
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
(assert  (item (name ?f1) (conf (- (+ ?conf1 ?conf2) (* ?conf1 ?conf2)))))
(retract ?i1)
(retract ?i2)
(assert ( sendmessagehalt (sym-cat ?f1 ": \n=================================\nКоэффициент уверенности пересчитан\n=================================")) )
(halt))
)

''')
    for line in f:
        if line and not line.startswith('\n'):
            iid, lhs, rhs, conf, desc = map(str.strip, line.split(';'))
            lhs = set(map(str.strip, lhs.split(',')))
            rhs = set(map(str.strip, rhs.split(',')))
            o.write(
f'''(defrule {iid}
(declare (salience 50))
''')
            i = 0
            for item in sorted(lhs):
                o.write(
f'(item (name {item}) (conf ?c{i}))\n'
)
                i += 1
            o.write(
'=>\n'
)
            minn = '(min ' + ' '.join(f'?c{j}' for j in range(i)) + ')'
            for item in sorted(rhs):
                o.write(
f'''(assert (item (name {item}) (conf (* {conf} {minn}) ) ) )
''')
            o.write(
f'''(assert (sendmessagehalt "{rhs.pop()}: {desc}"))
(halt)
)

''')

# (assert ( item (name f2) (conf (* 0.5 (min ?conf1 ?conf2) ) )))
# (assert ( sendmessagehalt "f2,Wood->Planks" ) )
