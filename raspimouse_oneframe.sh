#!/bin/bash -xv

echo 100 > /dev/rtbuzzer0
sleep 0.5s
echo 0 > /dev/rtbuzzer0
echo 1 > /dev/rtmotoren0

oneframe() { #oneframe 'value(hz)'
	local Time=0
	local R=2.4 #radius of wheel(cm)
	echo "$R"
	Time=`echo "scale=3; (400*18)/(2*$R*3.14*$1)*1000" | bc` #(2*3.14*2.4*P(hz))/(400*18) = oneframe's time  **18 = one frame of micro mouse coase
	echo "$Time"
	echo $1 $1 $Time > /dev/rtmotor0
}

turn(){ #turn 'hz ($1)' 'angle(deg) ($2)' '0or1(right or left) ($3)'
	local Time=0
	local R=2.4 #radius of wheel(cm)
	local a=5.0 #distance of the wheels and the shaft(cm)
	Time=`echo "scale=3; ($2*400*$a)/(360*$1*$R)*1000" | bc` #angle 90
	echo "$Time"
	if [ $3 -eq 0 ];then
		echo $1 -$1 $Time > /dev/rtmotor0
	elif [ $3 -eq 1 ];then
		echo -$1 $1 $Time > /dev/rtmotor0
	else
		echo "turn 0or1 (right or left)"
	fi
}

oneframe 300 #300hz one frame move
sleep 1s
turn 300 90 0 #300hz 90(deg) right turn
sleep 1s
turn 400 45 1 #400hz 45(deg) left turn
sleep 1s
turn 200 45 1 #200hz 45(deg) left turn
