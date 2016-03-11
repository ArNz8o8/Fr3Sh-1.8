## Verkeerd woord script 1.0a release - by ArNz|8o8
## Minimaal G flag nodig voor geen ban

# Stel slecht woord in
set badwords { 
"kanker"
"kk"
"telfort"
"nigger"
}

# Ban reden
set badreason "Don't.. Just don't."

# Ban tijd
set bwduration 2

### Begin Script:

## Bind all input from channels
bind pubm - * filter_bad_words

### Borrowed from awyeahs tcl scripts###
proc ccodes:filter {str} {
  regsub -all -- {\003([0-9]{1,2}(,[0-9]{1,2})?)?|\017|\037|\002|\026|\006|\007} $str "" str
  return $str
}

## Starting Process
proc filter_bad_words {nick uhost handle channel args} {
 global badwords badreason banmask botnick bwduration
 set args [ccodes:filter $args] 
  set handle [nick2hand $nick]
   set banmask "*![lindex [split $uhost @] 0]@[lindex [split $uhost @] 1]" 
	foreach badword [string tolower $badwords] {     
	if {[string match *$badword* [string tolower $args]]}  {
       if {[matchattr $handle +g]} {
           putlog "-Verkeerd woord- $nick ($handle) with +g flag said $args on $channel"
       } elseif {[matchattr $handle +o]} {
           putlog "-Verkeerd woord- $nick ($handle) with +o flag said $args on $channel"
       } else {
           putlog "-Verkeerd woord- KICKED $nick on $channel matched by $args"
           putquick "KICK $channel $nick :Used a thou-shall-not word in $args. $badreason"
           newchanban $channel $banmask $botnick $badreason $bwduration
       }
    }
  }
}
bind pubm - * filter_bad_words

putlog "Verkeerd woord script 1.0a release by ArNz|8o8 loaded"