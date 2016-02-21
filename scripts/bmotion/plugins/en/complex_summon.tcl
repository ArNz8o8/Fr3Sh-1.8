# simsea's summoning script
#
# vim: fdm=indent fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) Andrew Payne 2000-2008
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

# random summoning callback
proc bMotion_plugin_complex_summon { nick host handle channel text } {
	global summon_privmsg_response
	global botnicks

	# bMotion_putloglev d * "bMotion: (summon) entering"
	# check to make sure we should bother
	if { ![bMotion_interbot_me_next $channel] } {
		return 2
	}

	# !summon name
	if [regexp -nocase "^!summon (.*)" $text blah name] {
		# need to clean off white space
		set name [string trim $name]
		# also need to check for multiple names
		if { [string first " " $name] != -1 } {
			bMotion_putloglev d * "bMotion: (summon) multiple names... skipping"
			# just ignore it?
			return 2
		}	
		# now we can do our main checks
		if { $name != "" && [string tolower $name] != [string tolower $nick] } {
			# summon the best we can
			if { ![onchan $name $channel] } {
 				# the botnick could be non-existent
 				if [regexp -nocase "^$botnicks\$" $name] {
 					bMotion_putloglev d * "bMotion: (summon) myself!"
 					bMotionDoAction $channel $nick "%VAR{summon_bot}"
 					return 1
 				}
				bMotion_putloglev d * "bMotion: (summon) answering for someone not here"
				bMotionDoAction $channel $name "%VAR{summon_channel_response_notthere}"
			} else {
 				# the botnick could exist but be shorthand
 				if {[isbotnick $name] || [regexp -nocase "$botnicks" $name]} {
 					bMotion_putloglev d * "bMotion: (summon) myself!"
  				bMotionDoAction $channel $nick "%VAR{summon_bot}"
  				return 1
  			}
				bMotion_putloglev d * "bMotion: (summon) answering for someone here"
				if [isbotnick $name] {
					bMotionDoAction $channel $nick "%VAR{summon_bot}"
					return 1
				}
				bMotionDoAction $channel $name "%VAR{summon_channel_response}"
				#set msg [pickRandom $summon_privmsg_response]
				set msg "%VAR{summon_privmsg_response}"
				set msg [bMotion_process_macros $channel $msg]
				set msg [bMotionDoInterpolation $msg $nick ""]
				# replacements (TODO: may not be needed after doInterpolation)
				regsub "%channel" $msg $channel msg
				regsub "%%" $msg $nick msg
				# notify
				puthelp "PRIVMSG $name :$msg"
			}
			return 1
		}
	}
	bMotion_putloglev d * "bMotion: (summon) $nick doesn't know what they're doing"
	# poke fun at the idiot
	bMotionDoAction $channel $nick "%VAR{summon_channel_idiot}"
	return 1
}

# register the summon callback
bMotion_plugin_add_complex "summon" "^!summon" 100 "bMotion_plugin_complex_summon" "en"

bMotion_abstract_register "summon_channel_response_notthere" {
	"yoooo hooooo! %%!"
	"hello there, %%?"
	"how should I know where %% is?"
	"%% isn't here and I'm comfortable... you look for them"
	"i bet you thought that was gonna work and %% was just gonna show up"
	"even if I knew where %% was, why would I help you?"
	"/searches all over the channel for %%"
}

bMotion_abstract_register "summon_channel_response" {
	"/prods at %% with %VAR{sillyThings}"
	"through my awesome powers of telepathy, I shall summon %%!!"
	"/uses a smoke signal to get %%'s attention"
	"/stands behind %% poking them in the back till they turn around"
	"yeh... where is %%?"
	"why do you want to talk to %%?"
	"*pager on desk goes off*%|oh, %OWNER{%%} pager%|better let them know we've got it%|!summon %%%|*pager on desk goes off*%|oh %VAR{unsmiles}"
}
bMotion_abstract_add_filter "summon_channel_response" "%noun"

bMotion_abstract_register "summon_privmsg_response" {
	"FYI: %% was looking for you on %channel"
	"just so you know %% was asking about you on %channel"
	"%% was too lazy to message you from %channel themselves so I had to"
	"life was good until %% started shouting for you on %channel"
	"once upon a time, in a land called %channel, %% was asking about you"
	"Oi! %channel now! %% looking for you!"
}
bMotion_abstract_add_filter "summon_privmsg_response" "%chan(?!nel)"

bMotion_abstract_register "summon_channel_idiot" {
	"ANNOUNCEMENT: %% is an idiot. That is all."
	"Pay no attention to %%, the village idiot."
	"oOoOooOO very good %%... now who are you looking for?"
	"DANGER%colen there's an idiot behind the wheel!"
	"/offers %% a quick guide in using stuff"
	"%me knows all... except for whatever %% was trying to accomplish"
	"%%: stop bothering me"
	"you know, %%, it's a miracle you made it past childhood"
	"it's not your fault, %%, you must have walked into a door"
}

bMotion_abstract_register "summon_bot" {
	"oh! here i am!"
	"sup"
	"hello, yes?"
	"spluh"
	"<%%> good news everyone! I'm a horse's butt!"
}
