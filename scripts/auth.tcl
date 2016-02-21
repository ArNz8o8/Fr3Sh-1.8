###
## Name:            auth.tcl v0.02.01
## Author:          krimson
## Info:            Auth with X/Q on UnderNet/QuakeNet upon connect and sets usermodes on bot before joining channels
#
## Features:
#            This script makes the bot login automatically with X/Q from UnderNet/QuakeNet
#            immediately after connecting to the server. It also performs definable usermodes
#            before logging in.
#
## Thanks to:       caesar @ undernet #botlending
#
## Contact:
#            mail:  krimsonlord@yahoo.com
#            irc:   krimson@undernet/quakenet#botlending 
#
## Setup:
#            change the values in "set data" with your user and password
#            after that, all you have to do is copy the script in scripts/ dir 
#            and load it AT THE END of eggdrop.conf
#            ike this:
#                "source scripts/auth.tcl" 
#
## Changelog:
#
#        v0.02.01 - bugfix release
#        v0.02.00 - rewritten most of the code
#                 - now using namespace to prevent variable collision
#                 - now checking if X/Q exists in userfile with +f - if not, add them with +f flag
#        v0.01.02 - changed auto-detection of network - now detecting directly from irc server upon connect
#                 - added on join event (in case X/Q was split, the bot now auths when they join a channel the bot is on)
#        v0.01.01 - minor event bug fixes
#                 - simplified the procedures
#        v0.01.00 - added auto-detection of network name from eggdrop's config file
#                 - rewritten verification process
#                 - the eggdrop doesn't .die anymore if it's on the wrong network. it just skips the whole script and leaves a warning in logs
#                 - added another failed event (in case the server the bot is on is split from the rest of the network and X or Q is gone missing, the bot will join all channels)
#        v0.00.03 - removed secondary auth attempts
#                 - added failed event (in case the bot doesn't login), so that it won't stay out of all channels forever.
#        v0.00.02 - fixed endless looping of auth attempts (if it happend to not auth from the first try)
#                 - extended script for quakenet
###

namespace eval services:auth:00201 {

###
#  Begin Config
###

## set the username and password the bot will use (space separated)
 set data "USERNAME PASSWORD"

## set the modes applied on connection
 set modes "+ix-wds"

###
#  END Config
###

#########################################
#!!!!!!DO NOT EDIT AFTER THIS LINE!!!!!!#
#########################################

if {[llength $data] != 2} return

set services(user) [lindex $data 0]
set services(password) [lindex $data 1]

        proc switch:active {arg} {
        if {![llength $arg]} { 
            return 
        } elseif {!$arg} {
            set mode "-inactive"
        } else {
            set mode "+inactive"
        }
        foreach chan [channels] {
            channel set $chan $mode
    }
    }
    bind raw - 001 [namespace current]::on:connect
    
    proc on:connect {from keyword text} { 
        variable services
            switch -- "[string tolower [lindex $text 4]]" {
                "undernet" { set services(nick) "X"
                             set services(host) "X!cservice@undernet.org"
                             set services(login) "X@channels.undernet.org"
                             set services(word) "login"
                             set services(success) "AUTHENTICATION SUCCESSFUL*"
                             set services(failed) "AUTHENTICATION FAILED*"
                             set services(status) "Successfully LOGGED in to X"
                             check:serv
                            }
                "quakenet" { set services(nick) "Q"
                             set services(host) "Q!TheQBot@CServe.quakenet.org"
                             set services(login) "Q@CServe.quakenet.org"
                             set services(word) "auth"
                             set services(success) "AUTH'd successfully*"
                             set services(failed) "Username or password incorrect*"
                             set services(status) "Successfully AUTH'd with Q"
                             check:serv
                            }
                default { putlog "Eggdrop not connected to Quakenet or Undernet. Skipping auth.tcl..." }
            } 
    }
    
    proc check:serv {args} {
        variable services
            
            if {![matchattr $services(nick) f]} {
                if {![validuser $services(nick)]} { 
                    adduser $services(nick) $services(host)
                    putlog "Didn't find $services(nick) in userlist. Succesfuly added $services(nick) to userlist"
                }
                    chattr $services(nick) +f
                    putlog "$services(nick) didn't have +f flag. Succesfuly added flag +f to $services(nick)"
                }
        auth:attempt
    }
    
    proc auth:attempt {args} {
        global botnick; variable services; variable modes; variable data;
        
            putquick "MODE $botnick $modes"
            switch:active 1    
            
            putquick "PRIVMSG $services(login) :$services(word) $services(user) $services(password)" -next
            
            bind notc f|- "$services(success)" [namespace current]::auth:success
            bind raw - 401 [namespace current]::services:split
            bind notc f|- "$services(failed)" [namespace current]::auth:failed
    }

    proc auth:success {nick uhost hand text dest} {
        variable services
        
            if {$nick == $services(nick)} {
                unbind notc - "$services(success)" [namespace current]::auth:success
                unbind raw - 401 [namespace current]::services:split
                unbind raw - 001 [namespace current]::on:connect
                switch:active 0
                putlog "$services(status)"
            }
    }
    
    proc services:split {args} {
        variable services
            
            putlog "Services bot $services(nick) is split. Skipping auth and joining channels..."
            switch:active 0
            bind join f|- "* $services(host)" [namespace current]::auth:on:join
    }
            
    proc auth:on:join {nick uhost hand chan} {
        variable services; variable data

        putquick "PRIVMSG $services(login) :$services(word) $services(user) $services(password)"

    }
    
    proc auth:failed {args} {
        variable services
            if {[string match -nocase "[lindex $args 1]" "[lindex [split $services(host) !] 1]"]} {
            
                unbind raw - 401 [namespace current]::services:split
                unbind notc - "$services(failed)" [namespace current]::auth:failed
                switch:active 0
                putlog "Logging in to $services(nick) FAILED. Bogus user and/or pass. Rejoining chans..."
            }
    }
putlog "LOADED v0.02.01 by krimson"
}
