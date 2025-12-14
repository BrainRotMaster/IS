; main.clp — главный файл, который описывает функцию инициализации

(deffunction init-all ()
  (load "templates.clp")
  (load "domain.clp")
  (load "dialog.clp"))
