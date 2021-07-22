
#!/bin/bash
#para varrer uma determinada rede apenas setar o range...


probe () {
  ping -c1 -w5 $1 >&- 2>&- || touch /tmp/pingfail.$1
}
rm /tmp/pingfail.* 2>&-
for i in $(seq 1 50); do
  probe 192.168.0.$i &
done;
wait
for failip in /tmp/pingfail.*; do
  echo ${failip#*.}
done|sort -nt. -k1,1 -k2,2 -k3,3 -k4,4
rm /tmp/pingfail.* 2>&-
