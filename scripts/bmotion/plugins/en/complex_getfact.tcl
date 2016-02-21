#
# vim: fdm=indent fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) Kevin Smith 2003
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

#
# Makes the bot return a random fact
#
# Usage:
#	!fact
#	botname what do you know
#	botname tell me something new

bMotion_plugin_add_complex "getfact1" "^!fact" 100 bMotion_plugin_complex_get_fact "en"
bMotion_plugin_add_complex "getfact2" "^%botnicks,?:? what do you know" 100 bMotion_plugin_complex_get_fact "en"
bMotion_plugin_add_complex "getfact3" "^%botnicks,?:? tell me something new" 100 bMotion_plugin_complex_get_fact "en"

proc bMotion_plugin_complex_get_fact { nick host handle channel text } {
	set intro "%VAR{get_fact_intros}"
	global bMotionFacts

	if [bMotion_redis_available] {
		set fact_keys [bMotion_redis_cmd keys "fact:what:*"]
		set key [pickRandom $fact_keys]
		set fact [bMotion_redis_cmd srandmember $key]
		regsub "(.+:)*(.+)" $key "\\2" key
		bMotionDoAction $channel $nick "%VAR{get_fact_intros} $key %={was:is} $fact"
		return 1
	}

	set items [array names bMotionFacts]
	#this gets a random item to give a fact about
	set i [lindex $items [rand [llength $items]]]
	if {[regexp "what,(.+)" $i matches item]} {
		#set item
	}
	#set property $bMotionFacts(what,$item)
	set property [lindex $bMotionFacts(what,$item) [rand [llength $bMotionFacts(what,$item)]]]
	#get a random name from the realnames of $nick
	set nick [bMotionGetRealName $nick]
	#give the people what they want!
	bMotionDoAction $channel $nick "$intro $item was $property"
	return 1
}

bMotion_abstract_register "get_fact_intros" {
  "I think I heard that"
  "last time I knew, "
  "it could be that"
  "ok, I'll tell you that"
  "well, don't tell anyone, but%REPEAT{3:7:.}"
}
