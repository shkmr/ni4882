;;;
;;; ni4882
;;;
(define-module ni4882 (export-all))
(select-module ni4882)
(dynamic-load "ni4882")

(provide "ni4882")

(define-inline (ibfind udname)  (ibfindA udname))
(define-inline (ibrdf ud filename) (ibrdfA ud filename))
(define-inline (ibwrtf ud filename) (ibwrtfA ud filename))


(define-inline (ibdma ud v) (ibconfig ud IbcDMA v))
(define-inline (ibeos ud v) (ibconfig ud IbcEOS v))
(define-inline (ibeot ud v) (ibconfig ud IbcEOT v))
(define-inline (ibist ud v) (ibconfig ud IbcIst v))
(define-inline (ibpad ud v) (ibconfig ud IbcPAD v))
(define-inline (ibrsc ud v) (ibconfig ud IbcSC  v))
(define-inline (ibrsv ud v) (ibconfig ud IbcRsv v))
(define-inline (ibsad ud v) (ibconfig ud IbcSAD v))
(define-inline (ibsre ud v) (ibconfig ud IbcSRE v))
(define-inline (ibtmo ud v) (ibconfig ud IbcTMO v))

(define (GetPAD val) (bit-field val 0 7))
(define (GetSAD val) (bit-field val 8 15))

;;; EOF
