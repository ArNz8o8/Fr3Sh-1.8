#### MegaHAL admin script - by ArNz|8o8
### Moved most binds, because they where obsolete on Megahal 3.5

# bind pub o|o !megahal-off pub_!megahal-off
# bind pub o|o !megahal-on pub_!megahal-on
# bind pub o|o !learnall-off pub_!learnall-off
# bind pub o|o !learnall-on pub_!learnall-on
# bind pub o|o !freespeak-off pub_!freespeak-off
# bind pub o|o !freespeak-on pub_!freespeak-on
# bind pub o|o !megahalall-off pub_!megahalall-off
# bind pub o|o !megahalall-on pub_!megahalall-on
# bind pub o|o !$botnick-off pub_!megahalall-off
# bind pub o|o !$botnick-on pub_!megahalall-on
bind pub o|o !megahalinfo pub_megahalinfo

proc pub_!megahal-off {nick host hand chan arg} {
  if {[channel get $chan megahal] == 1} {
    channel set $chan -megahal
    puthelp "PRIVMSG $chan :Megahal is deactivated." } {
    puthelp "PRIVMSG $chan :Megahal is already deactivated."
  }
}
proc pub_!megahal-on {nick host hand chan arg} {
  if {[channel get $chan megahal] == 0} {
    channel set $chan +megahal
    puthelp "PRIVMSG $chan  :Megahal is activated." } {
    puthelp "PRIVMSG $chan  :Megahal is already deactiveted."
  }
}
proc pub_!learnall-off {nick host hand chan arg} {
  if {[channel get $chan learnall] == 1} {
    channel set $chan -learnall
    puthelp "PRIVMSG $chan  :Megahal learnall is deactivated." } {
    puthelp "PRIVMSG $chan  :Megahal learnall is already deactivated."
  }
}
proc pub_!learnall-on {nick host hand chan arg} {
  if {[channel get $chan learnall] == 0} {
    channel set $chan +learnall
    puthelp "PRIVMSG $chan  :Megahal learnall is activated." } {
    puthelp "PRIVMSG $chan  :Megahal learnall is already deactiveted."
  }
}
proc pub_!freespeak-off {nick host hand chan arg} {
  if {[channel get $chan freespeak] == 1} {
    channel set $chan -freespeak
    puthelp "PRIVMSG $chan  :Megahal freespeak is deactivated." } {
    puthelp "PRIVMSG $chan  :Megahal freespeak is already deactivated."
  }
}
proc pub_!freespeak-on {nick host hand chan arg} {
  if {[channel get $chan freespeak] == 0} {
    channel set $chan +freespeak
    puthelp "PRIVMSG $chan  :Megahal freespeak is activated." } {
    puthelp "PRIVMSG $chan  :Megahal freespeak is already deactiveted."
  }
}
proc pub_!megahalall-off {nick host hand chan arg} {
    channel set $chan -freespeak -megahal -learnall
    puthelp "PRIVMSG $chan  :Megahal is complete deactivated."
}
proc pub_!megahalall-on {nick host hand chan arg} {
    channel set $chan +freespeak +megahal +learnall
    puthelp "PRIVMSG $chan  :Megahal is complete activated."
}

proc pub_megahalinfo {nick uhost hand chan arg} {
  puthelp "PRIVMSG $chan :Fr3Sh is an Eggdrop v1.8.0+infiniteinfo with MegaHAL/bMotion and is maintained by ArNz|8o8" 
}

putlog "Megahal_admin.tcl Ver: 0.1 Loaded, Made by ArNz|8o8"