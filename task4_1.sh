#!/bin/bash
d=`dirname $0`
cd $d
apt update -y > /dev/null
CPU=`lshw -class cpu | grep product | awk -F"product:" '{ print $2 }'| sed -r 's/^\s+//g'`
RAM=`cat /proc/meminfo | grep MemTotal | awk -F"MemTotal:" '{print $2}'| sed -r 's/^\s+//g'`
#MOTHERBOARD=`dmidecode -t system | grep Manufacturer | awk -F"Manufacturer:" '{print $2}'`
MOTHERBOARD=`dmidecode -s baseboard-manufacturer && dmidecode -s baseboard-product-name`
SSN=`dmidecode -s system-serial-number`
OS=`lsb_release -a | grep Description | awk -F"Description:" '{print $2}' | sed -r 's/^\s+//g'`
KERNEL=`uname -r`
INSTDATE=`ls -clt / | tail -n 1 | awk '{ print $7, $6, $8 }'`
HOSTNAME=`uname -n`
UPTIME=`uptime -p`
PROCRUN=`ps aux | wc -l`
USERLOG=`who | cut -d' ' -f1 | wc -l`

NETWINT=`ifconfig -s | tail -n+2 | awk '{print $1}'`
COUNTNETW=`ifconfig -s | tail -n+2 | awk '{print $1}' | wc -l`

echo "--- Hardware ---" > task4_1.out
echo "CPU: $CPU" >> task4_1.out
echo "RAM: $RAM" >> task4_1.out
echo "Motherboard: $MOTHERBOARD" >> task4_1.out
if [ $MOTHERBOARD ]; then echo "Motherboard: $MOTHERBOARD" >> task4_1.out ; else echo "Motherboard: Unknown" >> task4_1.out ; fi
if [ $SSN ]; then echo "System Serial Number: $SSN" >> task4_1.out ; else echo "System serial Number: Unknown" >> task4_1.out ; fi
echo "--- System ---" >> task4_1.out
echo "OS Distribution: $OS" >> task4_1.out
echo "Kernel version: $KERNEL" >> task4_1.out
echo "Installation date: $INSTDATE" >> task4_1.out
echo "Hostname: $HOSTNAME" >> task4_1.out
echo "Uptime: $UPTIME" >> task4_1.out
echo "Processes running: $PROCRUN" >> task4_1.out
echo "User logged in: $USERLOG" >> task4_1.out
echo "--- Network ---" >> task4_1.out

i=1
while [ $COUNTNETW -ge $i ]
do
IFNAME=`ifconfig -s | tail -n+2 | awk '{print $1}' | head -n$i | tail -n1`
NETWIP=`ip -4 a show $IFNAME | grep inet | awk '{ print $2 }'`
echo "<iface #$i $IFNAME>: $NETWIP" >> task4_1.out
i=$(( $i + 1 ))
done
 


