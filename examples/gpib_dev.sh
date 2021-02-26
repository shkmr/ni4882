##
##   Shell script library for my GPIB equipments
##
##

##
## HP34401A
##
hp34401a_measure_volt_dc()
{
    gpib wrtrd 22 0 "MEASURE:VOLTAGE:DC? 1, 0.001"
}

##
##  E3648A
##
e3648a_apply()
{
    pad=$1
    out=$2
    vol=$3
    amp=$4
    if [ "$5" = 1 ]; then
        sta="ON"
    else
        sta="OFF"
    fi
    gpib wrt $pad 0 "INSTRUMENT:NSELECT ${out}"
    gpib wrt $pad 0 "OUTPUT:STATE OFF"
    gpib wrt $pad 0 "APPLY ${vol},${amp}"
    gpib wrt $pad 0 "OUTPUT:STATE ${sta}"
}

e3648a_measure_current()
{
    pad=$1
    out=$2
    gpib wrt   $pad 0 "INSTRUMENT:NSELECT ${out}"
    gpib wrtrd $pad 0 "MEASURE:CURRENT?"
}

##
## E4425B
##
e4425b_set_cw()
{
    gpib wrt $1 0 "FREQUENCY:CW $2 Hz"
    gpib wrt $1 0 "POWER:AMPLITUDE $3 dBm"
    gpib wrt $1 0 "OUTPUT:STATE ON"
}

e4425b_shutoff()
{
    gpib wrt $1 0 "POWER:AMPLITUDE -135 dBm"
    gpib wrt $1 0 "POWER:AMPLITUDE -135 dBm"
}

# EOF
