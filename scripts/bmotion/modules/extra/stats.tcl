## bMotion Stats and Update Module
##
## This module loads, but is disabled by default.
## To enable it, please turn on one or both for the next
## two settings (stats_enabled and stats_version).
##
## If you turn on stats_version only, the bot will connect
## to stats.bmotion.net and request the latest version number.
## If your version is lower, it'll let you know.
##
## If you turn on stats_enabled only, the bot will connect
## to stats.bmotion.net and send some simple stats about itself
## for my curiosity only. It will send the eggdrop version,
## the TCL version, and the bMotion version.
## It will optionally send (you can choose) it's nick, network,
## admin, and bmotion settings. See the settings below to change
## what is sent.
##
## If you turn on both options, it'll do all the above in one
## connection. Connections are made once a week at a random time
##
## No other information about your bot is recorded. I recommend you
## look through the code if you want to make sure I'm not sending
## other sneaky stuff :)
##
## /JMS

### CONFIG: now set in settings.tcl; this bit just sets the defaults
### Don't change these any more, edit your settings file :)

## enable sending of stats etc
if {![info exists bMotion_stats_enabled]} {
	set bMotion_stats_enabled 0
}

## enable version checking (doesn't need stats to be sent)
if {![info exists bMotion_stats_version]} {
	set bMotion_stats_version 0
}


## what can we send (if stats_enabled is 1)
# this is the bot's nick
if {![info exists bMotion_stats_send]} {
	set bMotion_stats_send(botnick) 1
	# the admin info ('admin' in config)
	set bMotion_stats_send(admin) 1
	# the network name ('network' in config)
	set bMotion_stats_send(network) 1
	# bmotion's gender/orientation
	set bMotion_stats_send(bminfo) 1
}

### END USER CONFIG

##server (leave this)
set bMotion_stats_server "stats.bmotion.net"
set bMotion_stats_port 1337

### END SCRIPT CONFIG
### (stop editing here, but feel free to review :)

set bMotion_stats_latest ""
set bMotion_stats_time 0

proc bMotion_stats_send { } {
	bMotion_putloglev 4 * "bMotion_stats_send"
	global bMotion_stats_server bMotion_stats_port
	global bMotion_stats_enabled bMotion_stats_version
	global bMotion_stats_latest

	if {!($bMotion_stats_enabled || $bMotion_stats_version)} {
		return 0
	}

	set idx [connect $bMotion_stats_server $bMotion_stats_port]
	if {$idx} {
	  putlog "bMotion: successfully connected to stats server $bMotion_stats_server"
	  control $idx bMotion_stats_handler
	} else {
	  putlog "bMotion: unable to connect to stats server :("
	}
}

proc bMotion_stats_code { text } {
	bMotion_putloglev 4 * "bMotion_stats_code ($text)"
	set code ""
	regexp {^([0-9]+) } $text match code
	return $code
}

proc bMotion_stats_handler { idx text } {
	bMotion_putloglev 4 * "bMotion_stats_handler ($idx, $text)"
	global bMotion_stats_id bMotion_stats_key
	global bMotion_stats_send bMotionVersion
	global bMotion_stats_version bMotion_stats_enabled
	global bMotion_stats_latest owner

	if {$text == ""} {
		putlog "bMotion: stats server disconnected me"
	}

	set code [bMotion_stats_code $text]
	#putlog "code is $code"
	if {$code == 250} {
		putlog "bMotion: communicating with stats server..."
		if {$bMotion_stats_version == 1} {
			#send version request
			bMotion_putloglev 1 * "sending version request"
			putidx $idx "version"
		}

		if {$bMotion_stats_enabled == 1} {
		bMotion_putloglev 1 * "sending stats..."
		putidx $idx "bm_ver: $bMotionVersion"
		putidx $idx "egg_ver: unknown"
		putidx $idx "tcl_ver: [info patchlevel]"

		#optional stuff
		if {$bMotion_stats_send(botnick)} {
			global botnick
			putidx $idx "botnick: $botnick"
		}

		if {$bMotion_stats_send(admin)} {
			global admin
			putidx $idx "owner: $admin"
		}

		if {$bMotion_stats_send(network)} {
			global network
			putidx $idx "network: $network"
		}

		if {$bMotion_stats_send(bminfo)} {
			global bMotionInfo
			putidx $idx "bm_gender: $bMotionInfo(gender)"
			putidx $idx "bm_orient: $bMotionInfo(orientation)"
		}

		if {$bMotion_stats_id != ""} {
			#we have an id already, send it
			putidx $idx "id: $bMotion_stats_id"
			putidx $idx "key: $bMotion_stats_key"
		}
		putidx $idx "done"
		}
	}

	if {$code == 251} {
		bMotion_putloglev 1 * "server is creating a new ID for me"
	}

	if {$code == 252} {
		if [regexp "252 id: (.+)" $text matches id] {
			bMotion_putloglev 1 * "my new id is $id"
			set bMotion_stats_id $id
		}
		if [regexp "252 key: (.+)" $text matches key] {
			bMotion_putloglev 1 * "my new key is $key"
			set bMotion_stats_key $key
		}
	}

	if {$code == 253} {
		bMotion_putloglev 1 * "server has saved my stats"
		bMotion_stats_write
	}

	if {$code == 230} {
		bMotion_putloglev 1 * "communication complete"
		putlog "bMotion: stats sent successfully"
		return 1
	}

	if {$code == 256} {
		bMotion_putloglev 1 * "got version update: $text"
		regexp "latest version is (.+)" $text matches bMotion_stats_latest
		bMotion_stats_write
		bMotion_stats_version_cmp
		if {$bMotion_stats_enabled == 0} {
			#we're only doing version checking
			bMotion_putloglev 1 * "closing version-only connection"
			putidx $idx "omg u suck"
		}
		return 0
	}

	if {$code == 550} {
		bMotion_putloglev 1 * "error: no sql, aborting"
		putlog "bMotion: stats failed to send"
		return 1
	}

	if {$code == 510} {
		bMotion_putloglev 1 * "error: server didn't like our input, aborting"
		putlog "bMotion: stats failed to send"
		return 1
	}

	if {$code == 551} {
		bMotion_putloglev 1 * "error: server couldn't generate an id, aborting"
		putlog "bMotion: stats failed to send"
		return 1
	}

	if {$code == 552} {
		bMotion_putloglev 1 * "error: server couldn't save stats, aborting"
		putlog "bMotion: stats failed to send"
		return 1
	}

	return 0
}

proc bMotion_stats_load { } {
	global bMotionModules bMotion_stats_id bMotion_stats_time bMotion_stats_key
	global bMotionLocal

	set line ""

	set bMotion_stats_time 0

	# look for a stats file in the local dir first
	set statsFile "$bMotionLocal/stats.txt"

	if {![file exists $statsFile]} {
		# try in the old location
		set statsFile "$bMotionModules/stats.txt"
	}

	catch {
		set fileHandle [open "$bMotionModules/stats.txt" "r"]
		set line [gets $fileHandle]
	}

	if {$line != ""} {
		set bMotion_stats_time $line
		set bMotion_stats_id [gets $fileHandle]
		set bMotion_stats_key [gets $fileHandle]
	}

	catch {
		close $fileHandle
	}
}

proc bMotion_stats_check { force } {
	bMotion_putloglev 4 * "bMotion_stats_check ($force)"
	global bMotionModules bMotion_stats_id bMotion_stats_key
	global bMotion_stats_time

	bMotion_stats_load

	if {$bMotion_stats_time > 0} {
		set now [clock seconds]
		set diff [expr $now - $bMotion_stats_time]
		if {$force || ($diff > 604800)} {
			putlog "bMotion: last stats run was $diff seconds ago, resending..."
			bMotion_stats_send
		}
	} else {
		#no file
		putlog "bMotion: new installation, need to send stats/check version..."
		bMotion_stats_send
	}
}

proc bMotion_stats_write { } {
	bMotion_putloglev 4 * "bMotion_stats_write"
	global bMotion_stats_id bMotion_stats_key bMotionModules
	global bMotionLocal

	set fileHandle [open "$bMotionLocal/stats.txt" "w"]

	puts $fileHandle [clock seconds]
	puts $fileHandle $bMotion_stats_id
	puts $fileHandle $bMotion_stats_key
	close $fileHandle
}

proc bMotion_stats_delbind { } {
	bMotion_putloglev 4 * "bMotion_stats_delbind"
	#find our bind and delete it from the timeline
	set binds [binds time]
	foreach bind $binds {
		if {[lindex $bind 4] == "bMotion_stats_auto"} {
			#this is us
			unbind time - [lindex $bind 2] bMotion_stats_auto
		}
	}
}

proc bMotion_stats_auto { minute hour day month year } {
	bMotion_putloglev 4 * "bMotion_stats_auto ($minute $hour $day $month $year)"
	bMotion_stats_check 0
}

proc bMotion_stats_version_cmp { } {
	bMotion_putloglev 4 * "bMotion_stats_version_cmp"
	global bMotionVersion
	global bMotion_stats_latest

	bMotion_putloglev 1 * "comparing versions, mine = $bMotionVersion, latest = $bMotion_stats_latest"

	#explode our version
	regexp {([0-9]+)\.([0-9]+)\.([0-9]+)} $bMotionVersion matches my_maj my_min my_rev

	#explode latest
	regexp {([0-9]+)\.([0-9]+)\.([0-9]+)} $bMotion_stats_latest matches lat_maj lat_min lat_rev

	bMotion_putloglev 1 * "parsed my version to $my_maj $my_min $my_rev"
	bMotion_putloglev 1 * "parsed latest to $lat_maj $lat_min $lat_rev"

	#multiply
	set my_version [expr $my_maj * 100 + $my_min * 10 + $my_rev]
	set lat_version [expr $lat_maj * 100 + $lat_min * 10 + $lat_rev]

	bMotion_putloglev 1 * "calculated versions are $my_version and $lat_version"

	#compare!
	if {$lat_version > $my_version} {
		putlog "NEW VERSION OF bMOTION AVAILABLE: $bMotion_stats_latest"
		global owner
		catch {
			storenote "bMotion" $owner "A new version of bMotion is available ($bMotionVersion < $bMotion_stats_latest)" -1
		}

	}
}

### these are our admin commands
proc bMotion_stats_admin { handle { arg "" } } {
	global bMotion_stats_key bMotion_stats_id
	global bMotion_stats_enabled bMotion_stats_version
	global bMotion_stats_time

	bMotion_stats_load

	if {($arg == "stats") || ($arg == "status")} {
		bMotion_putadmin "Stats module:"
		if {$bMotion_stats_enabled} {
			bMotion_putadmin "  sending stats: yes"
		} else {
			bMotion_putadmin "  sending stats: no"
		}

		if {$bMotion_stats_version} {
			bMotion_putadmin "  checking version: yes"
		} else {
			bMotion_putadmin "  checking version: no"
		}

		if {$bMotion_stats_key != ""} {
			bMotion_putadmin "  id: $bMotion_stats_id (key: $bMotion_stats_key)"
		} else {
			bMotion_putadmin "  no id is stored"
		}

		if {$bMotion_stats_time > 0} {
			bMotion_putadmin "  last stats run was [expr [clock seconds] - $bMotion_stats_time] seconds ago ([clock format $bMotion_stats_time])"
		} else {
			bMotion_putadmin "  last stats run never or unknown"
		}

		#find our bind and delete it from the timeline
		set binds [binds time]
		foreach bind $binds {
			if {[lindex $bind 4] == "bMotion_stats_auto"} {
				#this is us
				bMotion_putadmin "  next stats run at [lindex [lindex $bind 2] 1]:[lindex [lindex $bind 2] 0]"
			}
		}

		return 0
	}

	if {($arg == "check") || ($arg == "go")} {
		bMotion_putadmin "checking stats are up to date..."
		bMotion_stats_check 0
		return 0
	}
}

proc bMotion_stats_help { } {
	bMotion_putadmin "Interact with the stats module."
	bMotion_putadmin "  .bmotion stats status"
	bMotion_putadmin "    Show the status of the stats module, including if it's enabled,"
	bMotion_putadmin "    if it's checking for updates, your bots unique ID, when the last"
	bMotion_putadmin "    stats run took place, and when the next one will."
	bMotion_putadmin "  .bmotion stats go"
	bMotion_putadmin "    Immediately perform a stats run (if needed)"
	bMotion_putadmin "(See settings.tcl and modules/extra/stats.tcl for config and information."
}

if {$bMotion_testing == 0} {
	bMotion_plugin_add_management "stats" "^stats" n bMotion_stats_admin "any" "bMotion_stats_help"
}

#init
set bMotion_stats_id ""
set bMotion_stats_key ""

#check daily to see if we should send stats
bMotion_stats_delbind
set min [expr int(rand() * 58 + 1)]
set hour [expr int(rand() * 22 + 1)]
bind time - "$min $hour * * *" bMotion_stats_auto

#make sure we're synced
if {$bMotion_testing == 0} {
	bMotion_stats_check 0
}

