# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     5                         ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      400                      ;# X dimension of topography
set val(y)      300                      ;# Y dimension of topography
set val(stop)   300.0                         ;# time of simulation end

#===================================
#        Initialization
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open 5_random_tcp.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open 5_random_tcp.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
    -llType        $val(ll) \
    -macType       $val(mac) \
    -ifqType       $val(ifq) \
    -ifqLen        $val(ifqlen) \
    -antType       $val(ant) \
    -propType      $val(prop) \
    -phyType       $val(netif) \
    -channel       $chan \
    -topoInstance  $topo \
    -energyModel "EnergyModel" \
    -initialEnergy 50 \
    -txPower 0.09 \
    -rxPower 0.07 \
    -idlePower 0.01 \
    -sleeppower 0.0001 \
    -transitionPower 0.02 \
    -transitionTime 0.0005 \
    -agentTrace    ON \
    -routerTrace   ON \
    -macTrace      ON \
    -movementTrace ON

#===================================
#        Nodes Definition
#===================================
#Create 20 nodes
set n0 [$ns node]
$n0 set X_ 50
$n0 set Y_ 264
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 330
$n1 set Y_ 264
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 190
$n2 set Y_ 206
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 260
$n3 set Y_ 206
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 50
$n4 set Y_ 101
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20

#===================================
#        Generate movement
#===================================
set xx_ [expr rand()*400]
set yy_ [expr rand()*300]
set finalxx_ [expr $xx_]
set finalyy_ [expr $yy_]
set rng_time [expr rand()*$val(stop)]
$ns at $rng_time "$n0 setdest $finalxx_ $finalyy_ 25.0"

set xx_ [expr rand()*400]
set yy_ [expr rand()*300]
set finalxx_ [expr $xx_]
set finalyy_ [expr $yy_]
set rng_time [expr rand()*$val(stop)]
$ns at $rng_time "$n4 setdest $finalxx_ $finalyy_ 25.0"

set xx_ [expr rand()*400]
set yy_ [expr rand()*300]
set finalxx_ [expr $xx_]
set finalyy_ [expr $yy_]
set rng_time [expr rand()*$val(stop)]
$ns at $rng_time "$n3 setdest $finalxx_ $finalyy_ 25.0"

#===================================
#        Agents Definition        
#===================================
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n4 $sink
$ns connect $tcp $sink


#===================================
#        Applications Definition        
#===================================
#Setup a CBR Application over UDP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 2.0 "$ftp start"
$ns at 290.0 "$ftp stop"


#===================================
#        Termination
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam 5_random_tcp.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
