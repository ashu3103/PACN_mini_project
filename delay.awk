BEGIN {
    seqno = -1

    droppedPackets = 0

    receivedPackets = 0

    count = 0

    recvdSize = 0

    startTime = 400

    stopTime = 0
}

{
    #packet delivery ratio
    if ($4 == "AGT" && $1 == "s" && seqno < $6) { seqno = $6 }
    else if (($4 == "AGT") && ($1 == "r")) { receivedPackets++ }
    else if ($1 == "D" && $7 == "tcp" && $8 > 512) { droppedPackets++ }

    #end-to-end delay
    if ($4 == "AGT" && $1 == "s") {
        tp++
        start_time[$6] = $2
    }
    else if ($1 == "r") { end_time[$6] = $2 }
    else if ($1 == "D" && $7 == "tcp") { end_time[$6] = -1 }

    event = $1

    time = $2

    node_id = $3

    pkt_size = $8

    level = $4

    # Store start time
    if (level == "AGT" && event == "s" && pkt_size >= 512) {
        if (time < startTime) { startTime = time }
    }

    # Update total received packets' size and store packets arrival time
    if (level == "AGT" && event == "r" && pkt_size >= 512) {
        if (time > stopTime) { stopTime = time }

        # Rip off the header

        hdr_size = pkt_size % 512

        pkt_size -= hdr_size

        # Store received packet's size

        recvdSize += pkt_size
    }
}

END {
    for (i = 0; i <= seqno; i++) {
        #print" For " i " : "end_time[i];
        if (end_time[i] > 0) {
            delay[i] = end_time[i] - start_time[i]
            count++
        }
        else { delay[i] = -1 }
    }

    for (i = 0; i < count; i++) {
        if (delay[i] > 0) { n_to_n_delay = n_to_n_delay + delay[i] }
    }

    if (count > 0) { n_to_n_delay = n_to_n_delay / count }



    print receivedPackets / (seqno + 1) * 100

    print n_to_n_delay * 1000

    print (recvdSize / (stopTime - startTime)) * (8 / 1000)
}
