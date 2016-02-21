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

bMotion_plugin_add_complex "smiley" {^[;:=]-?[)D>]$} 40 bMotion_plugin_complex_smiley "all"
bMotion_plugin_add_complex "smiley2" {^([\-^])_*[\-^];*$} 40 bMotion_plugin_complex_smiley "all"
bMotion_plugin_add_complex "smiley4" {^%botnicks [;:=]-?[)D>]$} 80 bMotion_plugin_complex_smiley2 "all"
bMotion_plugin_add_complex "smiley5" {^%botnicks ([\-^])_*[\-^];*$} 80 bMotion_plugin_complex_smiley2 "all"
bMotion_plugin_add_complex "smiley3" {^heh(ehe?)*$} 30 bMotion_plugin_complex_smiley "all"

proc bMotion_plugin_complex_smiley { nick host handle channel text } {
  if {![bMotion_interbot_me_next $channel]} { return 0 }

	if [bMotion_sufficient_gap 120 "complex:smiley" $channel] {
		if {[bMotion_mood_get happy] < 0} {
			return 0
		}

		bMotionDoAction $channel "" "%VAR{smiles}"
		bMotionGetHappy
		bMotionGetUnLonely
		return 1
	}
	return 0
}

proc bMotion_plugin_complex_smiley2 { nick host handle channel text } {
  if {![bMotion_interbot_me_next $channel]} { return 0 }

	if [bMotion_sufficient_gap 120 "complex:smiley" $channel] {
		if {[bMotion_mood_get happy] < 0} {
			return 0
		}

		bMotionDoAction $channel "" "%VAR{smiles}"
		bMotionGetHappy
		bMotionGetUnLonely
		return 1
	}
	return 0
}
