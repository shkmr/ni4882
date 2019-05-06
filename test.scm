;;;
;;; Test ni4882
;;;

(use gauche.test)

(test-start "ni4882")
(use ni4882)
(test-module 'ni4882)

;; The following is a dummy test code.
;; Replace it for your tests.
(test* "test-ni4882" "ni4882 is working"
       (test-ni4882))

;; If you don't want `gosh' to exit with nonzero status even if
;; the test fails, pass #f to :exit-on-failure.
(test-end :exit-on-failure #t)




