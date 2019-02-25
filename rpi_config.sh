#!/bin/bash
echo -e "Clock frequency:\n----------------"
for src in arm core h264 isp v3d uart pwm emmc pixel vec hdmi dpi ; do \
	echo -e "$src:\t$(vcgencmd measure_clock $src)" ; \
done

echo -e "Voltage:\n--------"
for id in core sdram_c sdram_i sdram_p ; do \
	echo -e "$id:\t$(vcgencmd measure_volts $id)" ; \
done

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