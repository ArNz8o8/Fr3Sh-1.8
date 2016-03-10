bind pubm -|- * blocked:words

setudef flag bwords

#? and * works as wildcards
set bwords(words) "*nigger* *telfort*"
#Allow pflag to use these words ?
set bwords(p) 1
set bwords(pflag) o

#How long time to last ? must be in minutes.
set bwords(mins) 15

bind ctcp -|- * blocked:words2

proc blocked:words2 {nick uhost handle dest keyword text} {
 if {[validchan $dest]} { blocked:words $nick $uhost $handle $dest $text }
}

proc blocked:words {nick uhost handle chan text} {
global botnick bwords
 set word [join [lindex [split $text] 0]]
  if {![string match "*+bwords*" [channel info $chan]]} { return 0 }
  if {[matchattr $handle $bwords(pflag)|$bwords(pflag) $chan] && $bwords(p)==1} { return 0 }
  foreach w [split $bwords(words) " "] {
   if {[string match [join $w] [join $word]]} {
    set nck [split [getchanhost $nick] "@"]
    set b1 [split [lindex $nck 1] "\."]
    set domain [lindex $b1 [expr [llength $b1]-2]].[lindex $b1 [expr [llength $b1]-1]]
    set banmask *![lindex $nck 0]@*.$domain
    newchanban $chan $banmask $botnick "Used $word at $chan - $bwords(mins) mins ban ([strftime %m-%d-%Y @ %H:%M])" $bwords(mins)
    putlog "Banned $nick@$chan for using $word."
    return 0
   }
  }
}

putlog "Wordkick - 1.0 release version by ArNz|8o8"