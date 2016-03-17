set ai_chan "#holland"

# Maximum time interval between messages (in minutes)
set ai_time 720

set ai_msgs {
  
  "-- Welcome to #Holland! See the channel's statistics on http://bit.ly/22l8WCQ --"
  "I am fr3Sh! See my chatstats, and yours, on: http://bit.ly/22l8WCQ"
}

proc ai_start {} {
  global ai_time
  if {[string match *ai_sendmsg* [timers]]} {return 0}
  timer [expr [rand $ai_time] + 1] ai_sendmsg
}

proc ai_sendmsg {} {
  global botnick ai_chan ai_msgs ai_time
  if {[validchan $ai_chan] && [onchan $botnick $ai_chan]} {
    puthelp "PRIVMSG $ai_chan :[lindex $ai_msgs [rand [llength $ai_msgs]]]"
  }
  timer [expr [rand $ai_time] + 1] ai_sendmsg
}

set ai_chan [string tolower $ai_chan]

ai_start

putlog "Loaded Channel Promo v1.1 by ArNz|8o8"
