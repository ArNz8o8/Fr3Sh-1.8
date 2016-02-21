#
#
# vim: fdm=indent fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2008
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

bMotion_plugin_add_complex "st-cloak" "^%botnicks:?,? cloak$" 100 "bMotion_plugin_complex_startrek_cloak" "en"
bMotion_plugin_add_complex "st-decloak" "^%botnicks:?,? decloak$" 100 "bMotion_plugin_complex_startrek_decloak" "en"
bMotion_plugin_add_complex "st-fire" "^%botnicks:?,? fire " 100 "bMotion_plugin_complex_startrek_fire" "en"
bMotion_plugin_add_complex "st-courtmartial" "^%botnicks:?,? courtmartial " 100 "bMotion_plugin_complex_startrek_courtmartial" "en"

#cloak
proc bMotion_plugin_complex_startrek_cloak { nick host handle channel text } {
  global bMotionInfo
  if {$bMotionInfo(cloaked) == 1} {
    bMotionDoAction $channel $nick "Already running cloaked, sir"
    return 1
  }
  set bMotionInfo(cloaked) 1
  bMotionDoAction $channel $nick "/shimmers and disappears from view..."
  return 1
}

#decloak
proc bMotion_plugin_complex_startrek_decloak { nick host handle channel text } {
  global bMotionInfo
  if {$bMotionInfo(cloaked) == 0} {
    bMotionDoAction $channel "" "Already decloaked, sir"
    return 1
  }
  set bMotionInfo(cloaked) 0
  bMotionDoAction $channel $nick "/shifts back into view"
  return 1
}

#fire
proc bMotion_plugin_complex_startrek_fire { nick host handle channel text } {
  global botnicks bMotionInfo
  if [regexp -nocase "$botnicks:?,? fire (.+) at (.+)" $text pop frogs weapon target] {
    set weapon [string tolower $weapon]
    if {![regexp "(phasers|torpedoe?|photon|quantum|cheesecake|everything)" $weapon]} {
      if {[string range $weapon [expr [string length $weapon] - 1] end] == "s"} {
        bMotionDoAction $channel $nick "I haven't got any '$weapon' ... I think they %VAR{fellOffs}."
      } else {
        bMotionDoAction $channel $nick "I haven't got any '$weapon' ... I think it %VAR{fellOffs}."
      }
      return 1
    }

    if [regexp -nocase $botnicks $target] {
      bMotionDoAction $channel $nick "Don't be so silly. Sir."
      return 1
    }

    if {$bMotionInfo(cloaked) == 1} {
      bMotionDoAction $channel "" "/swoops in on $target, decloaking on the way..."
    } else {
      bMotionDoAction $channel "" "/swoops in on $target"
    }

    if {$weapon == "phasers"} {
      global phaserFires
      bMotionDoAction $channel $target "%VAR{phaserFires}"
    }

    if [regexp "(torpedoe?s|photon|quantum)" $weapon] {
      global torpedoFires
      bMotionDoAction $channel $target "%VAR{torpedoFires}"
    }

    if {$weapon == "cheesecake"} {
      global cheesecakeFires
      bMotionDoAction $channel $target "%VAR{cheesecakeFires}"
    }

    if {$weapon == "everything"} {
      global everythingFires
      bMotionDoAction $channel $target "%VAR{everythingFires}"
    }

    if {$bMotionInfo(cloaked) == 1} {
      bMotionDoAction $channel "" "/recloaks"
    }
    return 1
  }
}

proc bMotion_plugin_complex_startrek_courtmartial { nick host handle channel text } {
  global botnicks bMotionInfo
  if [regexp -nocase "$botnicks:?,? courtmartial (.+?)( with banzai)?" $text pop frogs who banzai] {
    if [regexp -nocase "\\m$botnicks\\M" $who] {
      bMotionDoAction $channel "" "Duh."
      return 1
    }

    if {$banzai != ""} { set bMotionInfo(banzaiModeBrig) 1 } else { set bMotionInfo(banzaiModeBrig) 0 }

    if {[bMotion_plugins_settings_get "complex:startrek" "brig" $channel ""] != ""} {
      bMotionDoAction $channel $nick "I'm sorry Sir, I already have someone in the brig - please try again later, or empty the Recycle Bin."
			#utimer [expr $bMotionInfo(brigDelay) + 10] "bMotion_brig_flush $channel"
      return 1
    }

    if {![onchan $who $channel]} {
      bMotionDoAction $channel "" "Who?"
      puthelp "NOTICE $nick :Please specify the full nickname of someone in the channel (Couldn't find '$who')."
      return 1
    }

    bMotion_plugins_settings_set "complex:startrek" "brig" $channel "" $who

    if {$bMotionInfo(banzaiModeBrig) == 1} {
      bMotionDoAction $channel $who "%VAR{brigBanzais}"
      bMotionDoAction $channel $who "Rules simple. Simply decide if you think I'll find %% innocent."
      set bMotionInfo(brigInnocent) [list]
      set bMotionInfo(brigGuilty) [list]
      bind pub - "!bet" bMotionVoteHandler
      bMotionDoAction $channel $who "Place bets now! (\002!bet innocent\002 and \002!bet guilty\002, one bet per person)"
    }
    bMotionDoAction $channel $who "/throws %% in the brig to await charges"
    utimer $bMotionInfo(brigDelay) "bMotionDoBrig $channel"
    if {$bMotionInfo(banzaiModeBrig) == 1} {
      utimer [expr $bMotionInfo(brigDelay) / 2 + 7] "bMotionBanzaiBrigMidBet $channel"
    }
    return 1
  }
}


### Supporting functions
proc bMotionBanzaiBrigMidBet { channel } {
  global bMotionInfo

  set nick [bMotion_plugins_settings_get "complex:startrek" "brig" $channel ""]
	if {$nick == ""} {
		return 0
	}

  bMotionDoAction $channel "" "%VAR{banzaiMidBets}"
  return 0
}

proc bMotionDoBrig { channel } {
  global bMotionInfo charges trekNouns punishments

  set nick [bMotion_plugins_settings_get "complex:startrek" "brig" $channel ""]
	if {$nick == ""} {
		return 0
	}

  if {![onchan $nick $channel]} {
    putlog "bMotion: Was trying to courtmartial $nick on $channel, but they're not there no more :("
    bMotion_plugins_settings_set "complex:startrek" "brig" $channel "" ""
    return 0
  }

  if {$bMotionInfo(banzaiModeBrig) == 1} {
    bMotionDoAction $channel "" "Betting ends!"
  }

  bMotionDoAction $channel $nick "%%, you are charged with %VAR{charges}, and %VAR{charges}"
	bMotion_plugins_settings_set "complex:startrek" "brig" $channel "" ""

  set guilty [rand 2]
  if {$guilty} {
    bMotionDoAction $channel "" "You have been found guilty, and are sentenced to %VAR{punishments}. And may God have mercy on your soul."
    if {$bMotionInfo(banzaiModeBrig) == 1} {
      if {[llength $bMotionInfo(brigGuilty)] > 0} {
        bMotionDoAction $channel $bMotionInfo(brigGuilty) "Congraturation go to big winner who are %%. Well done! Riches beyond your wildest dreams are yours to taking!"
      }
    }
  } else {
    bMotionDoAction $channel "" "You have been found innocent, have a nice day."
    if {$bMotionInfo(banzaiModeBrig) == 1} {
      if {[llength $bMotionInfo(brigInnocent)] > 0} {
        bMotionDoAction $channel $bMotionInfo(brigInnocent) "Congraturation go to big winner who are %%. Well done! Glory and fame are yours!"
      }
    }
  }

  if {$bMotionInfo(banzaiModeBrig) == 1} {
    set bMotionInfo(banzaiModeBrig) 0
  }
  return 0
}

# apparently we forgot someone was in the brig
proc bMotion_brig_flush { channel } {

  set nick [bMotion_plugins_settings_get "complex:startrek" "brig" $channel ""]
	if {$nick == ""} {
		return 0
	}

	bMotion_putloglev d * "Flushing brig..."

	bMotionDoAction $channel $nick "Whoops... I forgot %% was in the brig%|/sweeps corpse under the rug"
	bMotion_plugins_settings_set "complex:startrek" "brig" $channel "" ""
}

proc bMotionVoteHandler {nick host handle channel text} {
  set nick [bMotion_plugins_settings_get "complex:startrek" "brig" $channel ""]
	if {$nick == ""} {
    #unbind
    putlog "bMotion: Oops, need to unbind votes"
    unbind pub - "!bet" bMotionVoteHandler
    return 0
  }

  if {[lsearch $bMotionInfo(brigInnocent) $nick] != -1} {
    puthelp "NOTICE $nick :You have already bet."
    return 0
  }

  if {[lsearch $bMotionInfo(brigGuilty) $nick] != -1} {
    puthelp "NOTICE $nick :You have already bet."
    return 0
  }

  if [string match -nocase "innocent" $text] {
    lappend bMotionInfo(brigInnocent) $nick
    putlog "bMotion: Accepted innocent bet from $nick"
    return 0
  }

  if [string match -nocase "guilty" $text] {
    lappend bMotionInfo(brigGuilty) $nick
    putlog "bMotion: Accepted guilty bet from $nick"
    return 0
  }
  puthelp "NOTICE $nick: Syntax: !bet <guilty|innocent>"
}

bMotion_plugin_add_irc_event "brig" "nick" ".*" 100 "bMotion_plugins_complex_startrek_nick" "en"

proc bMotion_plugins_complex_startrek_nick { nick host handle channel newnick } {
	global bMotionChannels

	foreach chan $bMotionChannels {
		bMotion_putloglev 1 * "Checking $chan for $nick in the brig"
		if {[bMotion_plugins_settings_get "complex:startrek" "brig" $chan ""] == $nick} {
			bMotion_plugins_settings_set "complex:startrek" "brig" $chan "" $newnick
			bMotion_putloglev d * "Tracked $nick changing to $newnick while in the brig"
		}
	}
	return 0
}
