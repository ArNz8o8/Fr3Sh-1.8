# bMotion - Mood handling
#

###############################################################################
# bMotion - an 'AI' TCL script for eggdrops
# Copyright (C) James Michael Seward 2000-2008
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
###############################################################################

# value is the current mood value
# min in the lowest it can be
# max is the highest it can be
# target is where it drifts towards every tick
# callback is executed when it is changed
set BMOTION_MOOD_VALUE    0
set BMOTION_MOOD_MIN      1
set BMOTION_MOOD_MAX      2
set BMOTION_MOOD_TARGET   3
set BMOTION_MOOD_CALLBACK 4

# array to hold our data
if {![array exists bMotion_moods]} {
	array set bMotion_moods [list]
}

proc bMotion_mood_init { name initial min max target callback } {
	global bMotion_moods

	bMotion_putloglev 5 * "bMotion_mood_init $name $initial $min $max $target $callback"

	if {[llength [array get bMotion_moods $name]] > 0} {
		bMotion_putloglev d * "mood: ignoring mood init for $name"
		return
	}

	if {($initial < $min) || ($initial > $max)} {
		bMotion_putloglev d * "mood: ignoring mood init for $name; initial value is out of bounds"
		return
	}

	if {($target < $min) || ($target > $max)} {
		bMotion_putloglev d * "mood: ignoring mood init for $name; target value is out of bounds"
		return
	}

	if {$name == ""} {
		bMotion_putloglev d * "mood: ignoring mood init for empty name"
		return
	}

	if {$min >= $max} {
		bMotion_putloglev d * "mood: ignoring mood init for $name; invalid min/max"
		return
	}

	array set bMotion_moods [list $name [list $initial $min $max $target $callback] ]
	bMotion_putloglev d * "mood: initialised mood $name"
}


## MOOD ROUTINES _________________________________________________________________________________
proc bMotionGetHappy {} {
	bMotion_mood_adjust happy 1
}

proc bMotionGetSad {} {
	bMotion_mood_adjust happy -1
}

proc bMotionGetHorny {} {
	bMotion_mood_adjust horny 1
}

proc bMotionGetUnHorny {} {
	bMotion_mood_adjust horny -1
}

proc bMotionGetLonely {} {
	bMotion_mood_adjust lonely 1
}

proc bMotionGetUnLonely {} {
	bMotion_mood_adjust lonely -1
}

## Checkmood: checks the moods are within limits
proc checkmood {nick channel} {
	putlog "*** Call to checkmood"
	return

  global mood
  foreach r {happy horny lonely electricity stoned} {
    if {$r < -30} {
      set mood($r) -30
      bMotion_putloglev d * "bMotion: mood $r went OOB, resetting to -30"
    }
    if {$mood($r) > 30} {
      bMotion_putloglev d * "bMotion: mood $r went OOB, resetting to 30"
      set mood($r) 30
    }
  }
  if {$nick == ""} {return 0}

	if {($mood(happy) > 10) && ($mood(lonely) > 5) && ($mood(horny) > 5)} {
		mee $channel "replicates some tissues"
		mee $channel "locks [getPronoun] in the bathroom"
		set mood(horny) [expr $mood(horny) - 10]
		set mood(lonely) [expr $mood(lonely) -3]
	}
}


## Driftmood: Drifts all moods towards 0
proc driftmood {} {
	putlog "*** Call to driftmood"
	return 

  set driftSummary ""
  global mood mooddrifttimer moodtarget
  foreach r {happy horny lonely electricity stoned} {
    set drift 0
    set driftString ""
    if {$mood($r) > $moodtarget($r)} {
      set drift -1
      set driftString "$moodtarget($r)--($drift)-->$mood($r)"
    }
    if {$mood($r) < $moodtarget($r)} {
      set drift 2
      set driftString "$mood($r)--(+$drift)-->$moodtarget($r)"
    }
    if {$drift != 0} {
      set mood($r) [expr $mood($r) + $drift]
      set driftSummary "$driftSummary $r:($driftString) "
    }
  }
  if {$driftSummary != ""} {
    bMotion_putloglev d * "bMotion: drifted mood $driftSummary"
  }
  checkmood "" ""
  set mooddrifttimer 1

  timer 10 driftmood
  return 0
}

proc bMotion_mood_drift_timer { } {
	timer 10 bMotion_mood_drift_timer
	bMotion_mood_drift
}

proc bMotion_mood_drift { } {
	global bMotion_moods
	global BMOTION_MOOD_VALUE BMOTION_MOOD_MIN BMOTION_MOOD_MAX BMOTION_MOOD_TARGET BMOTION_MOOD_CALLBACK

	set names [array names bMotion_moods]
	foreach mood $names {
		set mood_info $bMotion_moods($mood)
		set target [lindex $mood_info $BMOTION_MOOD_TARGET]
		set value [lindex $mood_info $BMOTION_MOOD_VALUE]

		if {$value == $target} {
			bMotion_putloglev 2 * "mood: mood $mood is at target value of $target"
			continue
		}

		if {$value < $target} {
			bMotion_putloglev 1 * "mood: mood $mood needs drifting up: $value < $target"
			incr value
		} else {
			bMotion_putloglev 1 * "mood: mood $mood needs drifting down: $value > $target"
			incr value -1
		}

		set mood_info [lreplace $mood_info $BMOTION_MOOD_VALUE $BMOTION_MOOD_VALUE $value]
		bMotion_putloglev 1 * "mood: mood $mood is now $mood_info"
		set bMotion_moods($mood) $mood_info 
	}
}


proc bMotion_mood_adjust { name change } {
	global bMotion_moods
	global BMOTION_MOOD_VALUE BMOTION_MOOD_MIN BMOTION_MOOD_MAX BMOTION_MOOD_TARGET BMOTION_MOOD_CALLBACK

	if {[llength [array get bMotion_moods $name]] == 0} {
		bMotion_putloglev d * "mood: ignoring mood change for $name"
		return
	}

	set mood_info $bMotion_moods($name)
	set value [lindex $mood_info $BMOTION_MOOD_VALUE]
	set min [lindex $mood_info $BMOTION_MOOD_MIN]
	set max [lindex $mood_info $BMOTION_MOOD_MAX]
	set callback [lindex $mood_info $BMOTION_MOOD_CALLBACK]

	bMotion_putloglev d * "mood: adjusting $name from $value by $change"
	incr value $change
	
	if {$value > $max} {
		bMotion_putloglev 1 * "mood: $name went too high; capping to $max"
		set value $max
	}

	if {$value < $min} {
		bMotion_putloglev 1 * "mood: $name went too low; capping to $min"
		set value $min
	}

	set mood_info [lreplace $mood_info $BMOTION_MOOD_VALUE $BMOTION_MOOD_VALUE $value]
	set bMotion_moods($name) $mood_info

	if {[llength [info procs $callback]] > 0} {
		bMotion_putloglev d * "mood: running callback $callback for $name"
		catch {
			$callback
		}
	}
}

## moodTimerStart: Used to start the mood drift timer when the script initialises
## and other timers now, too
proc moodTimerStart {} {
  global mooddrifttimer
	if  {![info exists mooddrifttimer]} {
		timer 10 driftmood
    timer [expr [rand 30] + 3] doRandomStuff
		set mooddrifttimer 1
	}
	timer 10 bMotion_mood_drift_timer
}


## moodHander: DCC .mood
proc moodhandler {handle idx arg} {
  putidx $idx "Please use .bmotion mood"
}


## pubm_moodHandler: !mood
proc pubm_moodhandler {nick host handle channel text} {
  if {![matchattr $handle n]} {
    return 0
  }

  global botnick

  bMotionDoAction $channel $nick "%%: Please use .bmotion $botnick mood"
  return 0
}

# management command
proc bMotion_mood_admin { handle { arg "" } } {
	global bMotion_moods
	global BMOTION_MOOD_VALUE BMOTION_MOOD_MIN BMOTION_MOOD_MAX BMOTION_MOOD_TARGET BMOTION_MOOD_CALLBACK

	if {($arg == "") || ($arg == "status")} {
		#output our mood
		bMotion_putadmin "Current mood status:"
		set names [array names bMotion_moods]
		foreach mood $names {
			set value [lindex $bMotion_moods($mood) $BMOTION_MOOD_VALUE]
			bMotion_putadmin "  $mood: $value"
		}
		return 0
	}

	if {$arg == "info"} {
		#output our mood
		bMotion_putadmin "Current mood configuration:"
		set names [array names bMotion_moods]
		foreach mood $names {
			set mood_info $bMotion_moods($mood)
			set value [lindex $mood_info $BMOTION_MOOD_VALUE]
			set min [lindex $mood_info $BMOTION_MOOD_MIN]
			set max [lindex $mood_info $BMOTION_MOOD_MAX]
			set callback [lindex $mood_info $BMOTION_MOOD_CALLBACK]
			set target [lindex $mood_info $BMOTION_MOOD_TARGET]

			if {$callback == ""} {
				set callback "(none)"
			}

			bMotion_putadmin "  $mood: $min < $value < $max; target $target; callback $callback"
		}
		return 0
	}

	if {$arg == "drift"} {
		bMotion_putadmin "Drifting mood values..."
		bMotion_mood_drift
		return 0
	}

	if {[regexp -nocase {set ([^ ]+) ([0-9]+)} $arg matches moodname moodval]} {
		set value [bMotion_mood_set $moodname $moodval]

		if {$value == ""} {
			bMotion_putadmin "Unknown mood"
			return 0
		}
		
		bMotion_putadmin "Value for mood $moodname is now $value"

		return 0
	}

	bMotion_putadmin "use: mood \[status|info|drift|set <name> <value>\]"
	return 0
}

proc bMotion_mood_set { name newvalue } {
	global bMotion_moods
	global BMOTION_MOOD_VALUE BMOTION_MOOD_MIN BMOTION_MOOD_MAX BMOTION_MOOD_TARGET BMOTION_MOOD_CALLBACK

	if {[llength [array get bMotion_moods $name]] == 0} {
		return ""
	}

	set mood_info $bMotion_moods($name)
	set mood_info [lreplace $mood_info $BMOTION_MOOD_VALUE $BMOTION_MOOD_VALUE $newvalue]
	set bMotion_moods($name) $mood_info

	return [lindex $bMotion_moods($name) $BMOTION_MOOD_VALUE]
}

proc bMotion_mood_get { name } {
	global bMotion_moods
	global BMOTION_MOOD_VALUE BMOTION_MOOD_MIN BMOTION_MOOD_MAX BMOTION_MOOD_TARGET BMOTION_MOOD_CALLBACK

	if {[llength [array get bMotion_moods $name]] == 0} {
		return ""
	}

	return [lindex $bMotion_moods($name) $BMOTION_MOOD_VALUE]
}

# management help callback
proc bMotion_mood_admin_help { } {
	bMotion_putadmin "Controls the mood system:"
	bMotion_putadmin "  .bmotion mood [status]"
	bMotion_putadmin "    View a list of all moods and their values"
	bMotion_putadmin "  .bmotion mood set <name> <value>"
	bMotion_putadmin "    Set mood <name> to <value>. The neutral value is usually 0. Max/min is (-)30."
	bMotion_putadmin "  .bmotion mood drift"
	bMotion_putadmin "    Runs a mood tick."
	bMotion_putadmin "  .bmotion mood info"
	bMotion_putadmin "    Shows internal mood configuration"
}

if {$bMotion_testing == 0} {
	bMotion_plugin_add_management "mood" "^mood" n bMotion_mood_admin "any" bMotion_mood_admin_help
}

bMotion_mood_init happy 0 -30 30 0 bMotion_mood_change_happy
bMotion_mood_init horny 0 -30 30 0 bMotion_mood_change_horny
bMotion_mood_init lonely 0 -30 30 5 bMotion_mood_change_lonely
bMotion_mood_init electricity 0 -30 30 2 bMotion_mood_change_electricity
bMotion_mood_init stoned 0 -30 30 0 bMotion_mood_change_stoned

bMotion_putloglev d * "bMotion: mood module loaded"
