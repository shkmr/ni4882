;;;
;;; Test ni4882
;;;

(use gauche.test)
(test-start "ni4882")
(use ni4882)
(test-module 'ni4882)
(test* "UNL" #x3f UNL)
(test* "UNT" #x5f UNT)
(test* "ibfind"  #t (procedure? ibfind))
(test-end :exit-on-failure #t)

;;; EOF
