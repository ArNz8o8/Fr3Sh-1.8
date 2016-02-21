#
#
# vim: fdm=indent fdn=1
#

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2008
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################


# transform things in a fashion similar to people who work at demon internet

proc bMotion_plugin_output_demon { channel line } {
	bMotion_putloglev 4 * "bMotion_plugin_output_demon $channel $line"

	set newLine ""

	#split words
	set line [string trim $line]
	set words [split $line " "]

	foreach word $words {

		regsub -all {c?k\M} $word {q} word

		regsub -all {o([b-df-hj-np-tv-xz])e(s|ing)?\M} $word {oa\1\2} word

		# undo one -> oan (only if entire word)
		if {$word == "oan"} {
			set word "one"
		}

		#other special cases to fix
		set word [string map -nocase { boaxs boxes soam some someoan someone oq ok } $word]

		# [@     enid] i can not be represented by mere regexps.
		set word [string map -nocase { chiq chyq } $word]

		# doesn't really work right
		#regsub -all {le(s)?\M} $word {al\1} word

		# moving on...
		set word [string map -nocase { ain ane } $word]
		regsub -all {([a-z][aeiou])ck\M} $word {\1q} word
		regsub -all "don'?t" $word "doan" word
		regsub -all "didn'?t" $word "din" word
		append newLine "$word "
	}

	set line [string map { senior seior junior juior genius geious } $line]

	set line [string trim $newLine]

	return $line
}

bMotion_plugin_add_output "demon" bMotion_plugin_output_demon 0 "en" 11
