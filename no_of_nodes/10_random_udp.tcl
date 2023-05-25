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
set val(nn)     10                         ;# number of mobilenodes
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
set tracefile [open 10_random_udp.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open 10_random_udp.nam w]
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
#Create 10 nodes
set n0 [$ns node]
$n0 set X_ 50
$n0 set Y_ 264
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 260
$n1 set Y_ 264
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 330
$n2 set Y_ 264
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 50
$n3 set Y_ 206
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 330
$n4 set Y_ 206
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20
set n5 [$ns node]
$n5 set X_ 50
$n5 set Y_ 152
$n5 set Z_ 0.0
$ns initial_node_pos $n5 20
set n6 [$ns node]
$n6 set X_ 120
$n6 set Y_ 152
$n6 set Z_ 0.0
$ns initial_node_pos $n6 20
set n7 [$ns node]
$n7 set X_ 330
$n7 set Y_ 152
$n7 set Z_ 0.0
$ns initial_node_pos $n7 20
set n8 [$ns node]
$n8 set X_ 50
$n8 set Y_ 101
$n8 set Z_ 0.0
$ns initial_node_pos $n8 20
set n9 [$ns node]
$n9 set X_ 120
$n9 set Y_ 101
$n9 set Z_ 0.0
$ns initial_node_pos $n9 20

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
$ns at $rng_time "$n2 setdest $finalxx_ $finalyy_ 25.0"

#===================================
#        Agents Definition
#===================================
#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null1 [new Agent/Null]
$ns attach-agent $n4 $null1
$ns connect $udp0 $null1
$udp0 set packetSize_ 1500


#===================================
#        Applications Definition
#===================================
#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1.0Mb
$cbr0 set random_ null
$ns at 2.0 "$cbr0 start"
$ns at 290.0 "$cbr0 stop"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam 10_random_udp.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run