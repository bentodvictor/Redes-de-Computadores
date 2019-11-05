set ns [new Simulator]

# nam sim data
set nf [open out.nam w]
$ns namtrace-all $nf

# cwnd data
set wf1 [open flow_1.tr w]
set wf2 [open flow_2.tr w]

# on finish
# flush all trace and open nam
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    # exec xgraph flow_1.tr flow_2.tr -geometry 800x400 &
    exec nam out.nam &
    exit 0
}

# create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# setup a simple dumbbell network as follows:
# n0                   n4
#    \                /
#     n2 ========== n3
#    /                \
# n1                   n5

$ns duplex-link $n0 $n2 2.0Gb 10ms DropTail
$ns duplex-link $n1 $n2 2.0Gb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Gb 100ms DropTail
$ns duplex-link $n3 $n4 2.0Gb 10ms DropTail
$ns duplex-link $n3 $n5 2.0Gb 10ms DropTail
$ns queue-limit $n2 $n3 10

# setup queue watcher and queue limit bet n2 and n3
$ns duplex-link-op $n2 $n3 queuePos 0.1

# setup nam positions
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient left
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

# setup simulation colors
$ns color 1 Blue
$ns color 2 Red

# setup n1 to n4 connection
set tcp0 [new Agent/TCP/Linux]
$tcp0 set fid_ 1
$tcp0 set class_ 1
$tcp0 set window_ 8000
$tcp0 set packetSize_ 1500
$ns at 0 "$tcp0 select_ca cubic"
$ns attach-agent $n1 $tcp0

set sink0 [new Agent/TCPSink/Sack1]
$sink0 set class_ 1
$sink0 set ts_echo_rfc1323_ true
$ns attach-agent $n4 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

$ns connect $tcp0 $sink0

# setup n0 to n5 connection
set tcp1 [new Agent/TCP/Linux]
$tcp1 set fid_ 2
$tcp1 set class_ 2
$tcp1 set window_ 8000
$tcp1 set packetSize_ 5000
$ns at 0 "$tcp1 select_ca cubic"
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink/Sack1]
$sink1 set class_ 2
$sink1 set ts_echo_rfc1323_ true
$ns attach-agent $n5 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

$ns connect $tcp1 $sink1

$ns at 0.1 "$ftp1 start"
$ns at 100.0 "$ftp0 start"

$ns at 375.0 "$ftp1 stop"
$ns at 499.5 "$ftp0 stop"

# setup proc for cwnd plotting
proc plotWindow {tcpSource1 tcpSource2 file1 file2} {
   global ns

   set time 0.1
   set now [$ns now]
   set cwnd1 [$tcpSource1 set cwnd_]
   set cwnd2 [$tcpSource2 set cwnd_]

   puts $file1 "$now $cwnd1"
   puts $file2 "$now $cwnd2"
   $ns at [expr $now+$time] "plotWindow $tcpSource1 $tcpSource2 $file1 $file2" 
}

# setup plotting
$ns at 0.1 "plotWindow $tcp0 $tcp1 $wf1 $wf2"

# when to stop
$ns at 500.0 "finish"

# starto!
$ns run
