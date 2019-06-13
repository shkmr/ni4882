(use ni4882)
(use gauche.uvector)

(define-constant GPIB0 0)        ; Board index

(define Num_Instruments 0)       ; Number of instruments on GPIB
(define PAD             0)       ; Primary address
(define SAD             0)       ; Secondary address
(define loop            0)       ; Loop counter
(define Instruments (make-s16vector 32 0))
(define Resul       (make-s16vector 32 0))


(define (main args)
  ;;
  ;; Your board needs to be the Controller-In-Charge in order to find
  ;; all instrument on the GPIB.  To accomplish this, the function
  ;; SendIFC is called.  If the error bit ERR is set in ibsta, call
  ;; GpibError with an error message.
  ;;
  (SendIFC GPIB0)
  (if (logand (Ibsta) ERR)
    (GpibError "SendIFC error"))

  ;;
  ;;  Create an array containing all valid GPIB primary addresses,
  ;;  except for primary address 0.  Your GPIB interface board is at
  ;;  address 0 by default.  This array (Instruments) will be given to
  ;;  the function FindLstn to find all instruments.  The constant
  ;;  NOADDR, defined in NI488.H, signifies the end of the array.
  ;;
  (do ((i 0 (+ i 1)))
      ((= i 30) #t)
    (vector-set! Instruments i (+ i 1)))
  (vector-set! Instruments 30 NOADDR)

  ;;
  ;;  Print message to tell user that the program is searching for all
  ;;  active listeners.  Find all of the instruments on the bus.  Store
  ;;  the instrument addresses in the array Result. Note, the
  ;;  instruments must be powered on and connected with a GPIB cable in
  ;;  order for FindLstn to detect them. If the error bit ERR is set in
  ;;  ibsta, call GpibError with an error message.
  ;;
  (print "Finding all instruments on the bus...\n")

  (FindLstn GPIB0 Instruments Result 31)

  (if (logand (Ibsta) ERR)
    (GpibError "SFindLstn error"))

  ;;
  ;;  Ibcnt() returns the actual number of addresses stored in the
  ;;  Result array. Assign the value of Ibcnt() to the variable
  ;;  Num_Instruments. Print the number of instruments found.
  ;;
  (set! Num_Instruments (Ibcnt))
  (print #`"Number of instruments found = ,|Num_Instruments|\n")

  ;;
  ;;  The Result array contains the addresses of all the instruments
  ;;  found by FindLstn. Use the constant NOADDR, as defined in
  ;;  NI488.H, to signify the end of the array.
  ;;
  (vector-set! Result Num_Instruments NOADDR)

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
      (print #`"The instrument at Result[,|i|]: PAD = ,|PAD| SAD = NONE")
      (print #`"The instrument at Result[,|i|]: PAD = ,|PAD| SAD = ,|SAD|")))

  (ibonl GPIB0 0)
  0)


(define (GpibError msg)
  (let ((Status (Ibsta))
        (Error  (Iberr))
        (Count  (Ibcnt)))
    (print msg)
    (format #t "ibsta = &H~2,'0X  <" Status)
    (display (cond ((not (zero? (logand Status ERR)))  " ERR")
                   ((not (zero? (logand Status TIMO))) " TIMO")
                   ((not (zero? (logand Status END)))  " END")
                   ((not (zero? (logand Status SRQI))) " SRQI")
                   ((not (zero? (logand Status RQS)))  " RQS")
                   ((not (zero? (logand Status CMPL))) " CMPL")
                   ((not (zero? (logand Status LOK)))  " LOK")
                   ((not (zero? (logand Status REM)))  " REM")
                   ((not (zero? (logand Status CIC)))  " CIC")
                   ((not (zero? (logand Status ATN)))  " ATN")
                   ((not (zero? (logand Status TACS))) " TACS")
                   ((not (zero? (logand Status LACS))) " LACS")
                   ((not (zero? (logand Status DTAS))) " DTAS")
                   ((not (zero? (logand Status DCAS))) " DCAS")
                   (else "unknown")))
    (print " >")
    (format #t "iberr = ~d" Error)
    (print
     (case Error
       ((EDVR) " EDVR <Driver error>")
       ((ECIC) " ECIC <Not Controller-In-Charge>")
       ((ENOL) " ENOL <No Listener>")
       ((EADR) " EADR <Address error>")
       ((EARG) " EARG <Invalid argument>")
       ((ESAC) " ESAC <Not System Controller>")
       ((EABO) " EABO <Operation aborted>")
       ((ENEB) " ENEB <No GPIB board>")
       ((EDMA) " EDMA <DMA error>")
       ((EOIP) " EOIP <Async I/O in progress>")
       ((ECAP) " ECAP <No capability>")
       ((EFSO) " EFSO <File system error>")
       ((EBUS) " EBUS <Command error>")
       ((ESRQ) " ESRQ <SRQ stuck on>")
       ((ETAB) " ETAB <Table Overflow>")
       ((ELCK) " ELCK <Interface is locked>")
       ((EARM) " EARM <ibnotify callback failed to rearm>")
       ((EHDL) " EHDL <Input handle is invalid>")
       ((EWIP) " EWIP <Wait in progress on specified input handle>")
       ((ERST) " ERST <The event notification was cancelled due to a reset of the interface>")
       ((EPWR) " EPWR <The interface lost power>")
       (else   " Unknown error")))
    (format  #t "ibcnt = ~d~%" Count)
    (ibonl Device 0)
    (exit 1)))
