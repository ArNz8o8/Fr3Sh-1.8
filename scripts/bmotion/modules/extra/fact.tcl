# bMotion facts module
# $Id$
#
# vim: foldmethod=indent:foldcolumn=2:fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) James Michael Seward 2000-2002
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

# maximum number of things about which facts can be known
	if { [bMotion_setting_get "factsMaxItems"] != "" } {
		set bMotion_facts_max_items [bMotion_setting_get "factsMaxItems"]
	} else {
		set bMotion_facts_max_items 500
	}

# maximum number of facts to know about an item
	if { [bMotion_setting_get "factsMaxFacts"] != "" } {
		set bMotion_facts_max_facts [bMotion_setting_get "factsMaxFacts"]
	} else {
		set bMotion_facts_max_facts 20
	}

#work out where we're storing facts
	if {[bMotion_setting_get "factsFile"] == ""} {
		set bMotion_facts_file "$bMotionLocal/facts/facts.txt"
	} else {
		set bMotion_facts_file [bMotion_setting_get "factsFile"]
	}

# initialise
	if {![info exists bMotionFacts]} {
		set bMotionFacts(what,bmotion) [list "a very nice script"]
	}

proc bMotion_facts_load { } {
	if [bMotion_redis_available] {
		bMotion_putloglev 4 * "Not running bMotion_facts_load as we're using redis"
		return
	}

  global bMotionFacts bMotion_facts_file
	global bMotion_testing

	if {$bMotion_testing == 1} {
		return 0
	}

  bMotion_putloglev 1 * "Attempting to load $bMotion_facts_file"

  if {![file exists "$bMotion_facts_file"]} {
		bMotion_putloglev d * "facts file $bMotion_facts_file doesn't exist"
    return
  }

  set fileHandle [open "$bMotion_facts_file" "r"]
  set line [gets $fileHandle]

  set needResave 0
  set count 0

  while {![eof $fileHandle]} {
    if {$line != ""} {
      regexp {([^ ]+) (.+)} $line matches item fact
      if {![info exists bMotionFacts($item)]} {
        set bMotionFacts($item) [list]
      }
		 lappend bMotionFacts($item) $fact

      incr count


      if {[expr $count % 1000] == 0} {

      bMotion_putloglev d * "  still loading facts: $count ..."

      }
    }
    set line [gets $fileHandle]
  }

	#now de-dupe the lists
	set factnodes [array names bMotionFacts]
	foreach node $factnodes {
		set count [llength $bMotionFacts($node)]
		set bMotionFacts($node) [lsort -unique $bMotionFacts($node)]
		set newcount [llength $bMotionFacts($node)]
		if {$newcount < $count} {
			bMotion_putloglev 3 * "saved [expr $count - $newcount] items from $node"
		}
	}

  if {[info exists fileHandle]} {
    close $fileHandle
  }

  if {$needReSave} {
    bMotion_facts_save
  }
}

proc bMotion_facts_save { } {
	if [bMotion_redis_available] {
		putloglev 4 * "not running bMotion_facts_save as we're using redis"
		return
	}

  global bMotionFacts bMotion_facts_file
  global bMotion_facts_max_facts
  global bMotion_facts_max_items

  set tidy 0
  set tidyfact 0
  set count 0

  bMotion_putloglev 1 * "Saving facts to $bMotion_facts_file"

  set factsDir [file dirname $bMotion_facts_file]
  if { ![file exists $factsDir] } {
    bMotion_putloglev 1 * "Creating facts directory $factsDir"
    file mkdir $factsDir
  }

  set fileHandle [open "$bMotion_facts_file" "w"]

  set items [array names bMotionFacts]
  if {[llength $items] > $bMotion_facts_max_items} {
    bMotion_putloglev d * "Too many items are known ([llength $items] > $bMotion_facts_max_items), tidying up"
    set tidy 1
  }
  foreach item $items {
    if {$tidy} {
      if {[rand 100]< 10} {
        #clear array entry
        unset bMotionFacts($item)
        incr count
        continue
      }
    }
    if {[llength $bMotionFacts($item)] > $bMotion_facts_max_facts} {
      set tidyfact 1
    } else {
      set tidyfact 0
    }
    foreach fact $bMotionFacts($item) {
      if {$tidyfact} {
        if {[rand 100] < 10} {
          #less critical so we won't waste time trying to delete from memory too :)
          continue
        }
        puts $fileHandle "$item $fact"
      } else {
        # don't tidy, just dump it straight to the file
        puts $fileHandle "$item $fact"
      }  
    }
  }
  if {$tidy} {
    bMotion_putloglev d * "$count facts have been forgo.. los... delet... thingy *dribbles*"
  }
  close $fileHandle
}

proc bMotion_facts_auto_save { min hr a b c } {
	if [bMotion_redis_available] {
		return
	}
  putlog "bMotion: autosaving facts..."
  bMotion_facts_save
}

proc bMotion_facts_forget_all { fact } {
	if [bMotion_redis_available] {
		putlog "warning: bMotion_redis_available not implemented yet for redis"
		return
	}
  global bMotionFacts bMotionLocal

  #drop the array element
  unset bMotionFacts($fact)

  #resave to delete
  bMotion_facts_save
}

# save facts every hour
bind time - "01 * * * *" bMotion_facts_auto_save

# load facts at startup
catch {
  if {$bMotion_loading == 1} {
    bMotion_putloglev d * "autoloading facts..."
    bMotion_facts_load
  }
}

proc bMotion_plugin_management_fact { handle { arg "" }} {
  global bMotionFacts

  #fact show <type> <name>
  if [regexp -nocase {show ([^ ]+) ([^ ]+)} $arg matches t name] {
		if [bMotion_redis_available] {
			set known [bMotion_redis_cmd smembers fact:$t:$name]
		} else {
			set known $bMotionFacts($t,$name)
		}
    bMotion_putadmin "Known '$t' facts about: $name"
    set count 0
    foreach fact $known {
      bMotion_putadmin "$count: $fact"
      incr count
    }
    return 0
  }

  #status
  if [regexp -nocase {status} $arg] {
		set itemcount 0
		set factcount 0

		if [bMotion_redis_available] {
			set keys [bMotion_redis_cmd keys "fact:*"]
			foreach key $keys {
				incr itemcount
				incr factcount [bMotion_redis_cmd scard $key]
			}
		} else {
			set items [lsort [array names bMotionFacts]]
			foreach item $items {
				incr itemcount
				incr factcount [llength $bMotionFacts($item)]
			}
		}
    bMotion_putadmin "Total: $factcount facts about $itemcount items"
    return 0
  }

  if [regexp -nocase {list (.+)} $arg matches re] {
  	bMotion_putadmin "Items matching /$re/:"
  	bMotion_putadmin "  <not implemented yet>"
  	return 0
  }

  if [regexp -nocase {purge (.+)} $arg matches re] {
  	bMotion_putadmin "Deleting items matching /$re/:"
  	bMotion_putadmin "  <not implemented yet>"
  	return 0
  }

  if [regexp -nocase {delete ([^ ]+) (.+)} $arg matches item re] {
  	bMotion_putadmin "Deleting facts matching /$re/ from item $item:"
  	bMotion_putadmin "  <not implemented yet>"
  	return 0
  }

  #all else fails, list help
  bMotion_putadmin {use: fact [show <type> <name>|status]}
  return 0
}

proc bMotion_plugin_management_fact_help { } {
	bMotion_putadmin "Manage the fact subsystem:"
	bMotion_putadmin "  .bmotion fact status"
	bMotion_putadmin "    Show a summary of facts (lots of output!)"
	bMotion_putadmin "  .bmotion fact show <type> <key>"
	bMotion_putadmin "    Show defined values for <key>"
	bMotion_putadmin "    Currently <type> is only 'what'"
	#bMotion_putadmin "  .bmotion fact list <regexp>"
	#bMotion_putadmin "    List all items matching the regexp"
	#bMotion_putadmin "  .bmotion fact purge <regexp>"
	#bMotion_putadmin "    Deletes ALL facts known about ALL mataching items"
	#bMotion_putadmin "  .bmotion fact delete <item> <regexp>"
	#bMotion_putadmin "    Deletes all matching facts about <item>"
}

# register the plugin
if {$bMotion_testing == 0} {
	bMotion_plugin_add_management "fact" "^fact" n "bMotion_plugin_management_fact" "any" bMotion_plugin_management_fact_help
}

putlog "loaded fact module"
