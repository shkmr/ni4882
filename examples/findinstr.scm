;;;
;;;
;;;

(use ni4882)
(use gauche.uvector)

(define debug? #f)
(define (p x)  (if debug? (print x)))

(define (sta)  (format #f "0x~4,'0x" (Ibsta)))
(define (ck ib)
  (p #"~|ib|=~(sta)")
  (if (not (zero? (logand (Ibsta) ERR)))
    (GpibError #"~|ib| error")))


(define-constant GPIB0 0)        ; Board index
(define Num_Instruments 0)       ; Number of instruments on GPIB
(define PAD             0)       ; Primary address
(define SAD             0)       ; Secondary address
(define loop            0)       ; Loop counter
(define Instruments (make-s16vector 32 0))
(define Result      (make-s16vector 32 0))

(define (main args)
  ;;
  ;; Your board needs to be the Controller-In-Charge in order to find
  ;; all instrument on the GPIB.  To accomplish this, the function
  ;; SendIFC is called.  If the error bit ERR is set in ibsta, call
  ;; GpibError with an error message.
  ;;
  (SendIFC GPIB0)
  (ck "(SendIFC)")

  ;;
  ;;  Create an array containing all valid GPIB primary addresses,
  ;;  except for primary address 0.  Your GPIB interface board is at
  ;;  address 0 by default.  This array (Instruments) will be given to
  ;;  the function FindLstn to find all instruments.  The constant
  ;;  NOADDR, defined in NI488.H, signifies the end of the array.
  ;;
  (do ((i 0 (+ i 1)))
      ((= i 30) #t)
    (uvector-set! Instruments i (+ i 1)))
  (uvector-set! Instruments 30 -1)

  ;;
  ;;  Print message to tell user that the program is searching for all
  ;;  active listeners.  Find all of the instruments on the bus.  Store
  ;;  the instrument addresses in the array Result. Note, the
  ;;  instruments must be powered on and connected with a GPIB cable in
  ;;  order for FindLstn to detect them. If the error bit ERR is set in
  ;;  ibsta, call GpibError with an error message.
  ;;
  (p "Finding all instruments on the bus...\n")

  (FindLstn GPIB0 Instruments Result 31)
  (ck "(FindLstn)")

  ;;
  ;;  Ibcnt() returns the actual number of addresses stored in the
  ;;  Result array. Assign the value of Ibcnt() to the variable
  ;;  Num_Instruments. Print the number of instruments found.
  ;;
  (set! Num_Instruments (Ibcnt))
  (p #"Number of instruments found = ~|Num_Instruments|\n")

  ;;
  ;;  The Result array contains the addresses of all the instruments
  ;;  found by FindLstn. Use the constant NOADDR, as defined in
  ;;  NI488.H, to signify the end of the array.
  ;;
  (uvector-set! Result Num_Instruments -1)

  ;;
  ;;  Print out each instrument's PAD and SAD, one at a time.
  ;;
  ;;  Establish a FOR loop to print out the information. The variable
  ;;  LOOP will serve as a counter for the FOR loop and as the index
  ;;  to the array Result.
  ;;

  (do ((i 0 (+ i 1)))
      ((>= i Num_Instruments) #t)
    ;;
    ;;  The low byte of the instrument address is the primary
    ;;  address. Assign the variable PAD the primary address of the
    ;;  instrument. The macro GetPAD, defined in NI488.H, returns
    ;;  the low byte of the instrument address.
    ;;
    (set! PAD (GetPAD (uvector-ref Result i)))

    ;;
    ;;  The high byte of the instrument address is the secondary
    ;;  address. Assign the variable SAD the primary address of the
    ;;  instrument. The macro GetSAD, defined in NI488.H, returns
    ;;  the high byte of the instrument address.
    ;;
    (set! SAD (GetSAD (uvector-ref Result i)))
    (if (= SAD NO_SAD)
      (print #"The instrument at Result[~|i|]: PAD = ~|PAD| SAD = NONE")
      (print #"The instrument at Result[~|i|]: PAD = ~|PAD| SAD = ~|SAD|")))

  ;(ibonl GPIB0 0)
  0)

(define (GpibError msg)
  (print msg)
  (format #t "ibsta = 0x~2,'0X  <" (Ibsta))
  (display (if (not (zero? (logand (Ibsta) ERR)))  " ERR"   ""))
  (display (if (not (zero? (logand (Ibsta) TIMO))) " TIMO"  ""))
  (display (if (not (zero? (logand (Ibsta) END)))  " END"   ""))
  (display (if (not (zero? (logand (Ibsta) SRQI))) " SRQI"  ""))
  (display (if (not (zero? (logand (Ibsta) RQS)))  " RQS"   ""))
  (display (if (not (zero? (logand (Ibsta) CMPL))) " CMPL"  ""))
  (display (if (not (zero? (logand (Ibsta) LOK)))  " LOK"   ""))
  (display (if (not (zero? (logand (Ibsta) REM)))  " REM"   ""))
  (display (if (not (zero? (logand (Ibsta) CIC)))  " CIC"   ""))
  (display (if (not (zero? (logand (Ibsta) ATN)))  " ATN"   ""))
  (display (if (not (zero? (logand (Ibsta) TACS))) " TACS"  ""))
  (display (if (not (zero? (logand (Ibsta) LACS))) " LACS"  ""))
  (display (if (not (zero? (logand (Ibsta) DTAS))) " DTAS"  ""))
  (display (if (not (zero? (logand (Ibsta) DCAS))) " DCAS"  ""))
  (print " >")
  (format #t "iberr = ~d" (Iberr))
  (print (cond ((= (Iberr) EDVR) " EDVR <Driver error>")
               ((= (Iberr) ECIC) " ECIC <Not Controller-In-Charge>")
               ((= (Iberr) ENOL) " ENOL <No Listener>")
               ((= (Iberr) EADR) " EADR <Address error>")
               ((= (Iberr) EARG) " EARG <Invalid argument>")
               ((= (Iberr) ESAC) " ESAC <Not System Controller>")
               ((= (Iberr) EABO) " EABO <Operation aborted>")
               ((= (Iberr) ENEB) " ENEB <No GPIB board>")
               ((= (Iberr) EDMA) " EDMA <DMA error>")
               ((= (Iberr) EOIP) " EOIP <Async I/O in progress>")
               ((= (Iberr) ECAP) " ECAP <No capability>")
               ((= (Iberr) EFSO) " EFSO <File system error>")
               ((= (Iberr) EBUS) " EBUS <Command error>")
               ((= (Iberr) ESRQ) " ESRQ <SRQ stuck on>")
               ((= (Iberr) ETAB) " ETAB <Table Overflow>")
               ((= (Iberr) ELCK) " ELCK <Interface is locked>")
               ((= (Iberr) EARM) " EARM <ibnotify callback failed to rearm>")
               ((= (Iberr) EHDL) " EHDL <Input handle is invalid>")
               ((= (Iberr) EWIP) " EWIP <Wait in progress on specified input handle>")
               ((= (Iberr) ERST) " ERST <The event notification was cancelled due to a reset of the interface>")
               ((= (Iberr) EPWR) " EPWR <The interface lost power>")
               (else             " Unknown error")))
  (format  #t "ibcnt = ~d~%" (Ibcnt))
  #;(ibonl dev 0)
  (exit 1))
