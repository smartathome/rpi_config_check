#!/bin/bash
echo -e "Clock frequency:\n----------------"
for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi ; do \
	echo -e "$src:\t$(vcgencmd measure_clock $src)" ; \
done

echo -e "Voltage:\n--------"
for id in core sdram_c sdram_i sdram_p ; do \
	echo -e "$id:\t$(vcgencmd measure_volts $id)" ; \
done

echo -e "Voltage/Temperature throttling:\n------------------------------"
#Flag Bits
UNDERVOLTED=0x1
CAPPED=0x2
THROTTLED=0x4
HAS_UNDERVOLTED=0x10000
HAS_CAPPED=0x20000
HAS_THROTTLED=0x40000

#Text Colors
GREEN=`tput setaf 2`
RED=`tput setaf 1`
NC=`tput sgr0`

#Output Strings
GOOD="${GREEN}NO${NC}"
BAD="${RED}YES${NC}"

#Get Status, extract hex
STATUS=$(vcgencmd get_throttled)
STATUS=${STATUS#*=}

echo -n "Status: "
(($STATUS!=0)) && echo "${RED}${STATUS}${NC}" || echo "${GREEN}${STATUS}${NC}"

echo "Undervolted:"
echo -n "   Now: "
((($STATUS&UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_UNDERVOLTED)!=0)) && echo "${BAD}" || echo "${GOOD}"

echo "Throttled:"
echo -n "   Now: "
((($STATUS&THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_THROTTLED)!=0)) && echo "${BAD}" || echo "${GOOD}"

echo "Frequency Capped:"
echo -n "   Now: "
((($STATUS&CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"
echo -n "   Run: "
((($STATUS&HAS_CAPPED)!=0)) && echo "${BAD}" || echo "${GOOD}"

echo -e "Codecs:\n-------"
for codec in H264 MPG2 WVC1 MPG4 MJPG WMV9 ; do \
	echo -e "$codec:\t$(vcgencmd codec_enabled $codec)" ; \
done

echo -e "Temperature:\n------------"
vcgencmd measure_temp

echo -e "Configuration sets:\n-------------------"
vcgencmd get_config int

echo -e "Memory split:\n-------------"
vcgencmd get_mem arm && vcgencmd get_mem gpu

echo -e "Version:\n--------"
vcgencmd version