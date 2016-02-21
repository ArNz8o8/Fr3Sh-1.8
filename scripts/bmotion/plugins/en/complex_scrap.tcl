#
#
# vim: fdm=indent fdn=1

###############################################################################
# This is a bMotion plugin
# Copyright (C) Gregory Christiaan Sweetman 2002
#
# This program is covered by the GPL, please refer the to LICENCE file in the
# distribution; further information can be found in the headers of the scripts
# in the modules directory.
###############################################################################

#
# Causes the bot to give a basic description of a "scrapheap-challenge" type vehicle / construction
# Syntax : !scrap [ silly ] [ adult ]
#
# Output : [Quality] [Adjective [Adjective2]] [Power] Construction
# E.g. "Bent" "Steam Driven" "Barge"
#
# Silly switch will introduce strange descriptions, such as a "greasy lunar powered blamanche"
# Adult switch will introduce norty descriptions / devices.
#

bMotion_plugin_add_complex "scrap" "^!scrap" 100 bMotion_plugin_complex_scrap "en"

proc bMotion_plugin_complex_scrap { nick host handle channel text } {
  if [regexp -nocase "^!scrap( silly| adult| xxx)?( silly| adult| xxx)?$" $text blah silly1 silly2] {
    # output from output_english.tcl automatically corrects bad grammar of "a " followed by a vowel.
    set output "A "
    set outputtype 0
    if {($silly1 == " silly") || ($silly2 == " silly")} {
      set outputtype [expr $outputtype + 1]
    }
    if {($silly1 == " adult") || ($silly2 == " adult") || ($silly1 == " xxx") || ($silly2 == " xxx")} {
      set outputtype [expr $outputtype + 2]
    }

# outputtype = 0 <-- regular output
# outputtype = 1 <-- silly output
# outputtype = 2 <-- adult output
# outputtype = 3 <-- silly adult output

    # quality
    if [rand 2] {
      switch -exact $outputtype {
        0 {
          append output "%VAR{scrap_qualities} "
        }
        1 {
          append output "%VAR{scrap_silly_qualities} "
        }
        2 {
          append output "%VAR{scrap_adult_qualities} "
        }
        3 {
          append output "%VAR{scrap_silly_adult_qualities} "
        }
      }
    }

    # adjectives
    if [rand 2] {
      switch -exact $outputtype {
        0 {
          append output "%VAR{scrap_adjectives} "
          if [rand 2] {
            append output "%VAR{scrap_adjectives2} "
          }
        }
        1 {
          append output "%VAR{scrap_silly_adjectives} "
          if [rand 2] {
            append output "%VAR{scrap_silly_adjectives2} "
          }
        }
        2 {
          append output "%VAR{scrap_adult_adjectives} "
          if [rand 2] {
            append output "%VAR{scrap_adult_adjectives2} "
          }
        }
        3 {
          append output "%VAR{scrap_silly_adult_adjectives} "
          if [rand 2] {
            append output "%VAR{scrap_silly_adult_adjectives2} "
          }
        }
      }
    }

    # power
    if [rand 2] {
      switch -exact $outputtype {
        0 {
          append output "%VAR{scrap_power_adjectives} "
        }
        1 {
          append output "%VAR{scrap_silly_power_adjectives} "
        }
        2 {
          append output "%VAR{scrap_adult_power_adjectives} "
        }
        3 {
          append output "%VAR{scrap_silly_adult_power_adjectives} "
        }
      }
    }

    # construction
    switch -exact $outputtype {
      0 {
        append output "%VAR{scrap_construction} "
      }
      1 {
        append output "%VAR{scrap_silly_construction} "
      }
      2 {
        append output "%VAR{scrap_adult_construction} "
      }
      3 {
        append output "%VAR{scrap_silly_adult_construction} "
      }
    }

    bMotionDoAction $channel "" $output
    return 1
  }
}

bMotion_abstract_register "scrap_qualities" {
  "broken"
  "cheap"
  "irrepairable"
  "novice"
  "shoddy"
  "poor"
  "bad"
  "very bad"
  "terrible"
  "average"
	"very average"
  "amateur"
  "passable"
  "ok"
  "good"
  "normal"
  "fair"
  "master crafted"
  "perfect"
  "expensive"
  "premium"
  "professional"
  "quality"
  "superior"
  "first rate"
  "super"
  "legendary"
  "excellent"
	"ultimate"
	"as-seen-on-TV"
	"professional"
	"pro"
}

bMotion_abstract_register "scrap_adjectives" {
  "broken down"
  "greasy"
  "dirty"
  "bent"
  "blunt"
  "rusty"
  "battered"
  "bashed"
  "riveted"
  "working"
  "damaged"
  "forsaken"
  "chipped"
  "loose"
  "second hand"
  "splintered"
  "worn"
  "balanced"
  "engineered"
  "sharp"
  "polished"
  "composite"
  "layered"
  "over-tuned"
  "mammoth"
  "oscillating"
  "tiny"
  "small"
  "medium sized"
  "large"
  "huge"
  "massive"
  "miniscule"
  "stiff"
  "flexible"
	"brand new"
	"power assisted"
  "dirt driving"
  "muck mulching"
  "pete ploughing"
  "corn collecting"
  "metal mashing"
  "welly wanging"
  "creek crossing"
  "ditch digging"
  "rough riding"
  "remote controlled"
  "fully automatic"
  "semi automatic"
	"gritty"
"abandoned"
"able"
"absolute"
"adorable"
"adventurous"
"academic"
"acceptable"
"acclaimed"
"accomplished"
"accurate"
"aching"
"acidic"
"acrobatic"
"active"
"actual"
"adept"
"admirable"
"admired"
"adolescent"
"adorable"
"adored"
"advanced"
"afraid"
"affectionate"
"aged"
"aggravating"
"aggressive"
"agile"
"agitated"
"agonizing"
"agreeable"
"ajar"
"alarmed"
"alarming"
"alert"
"alienated"
"alive"
"all"
"altruistic"
"amazing"
"ambitious"
"ample"
"amused"
"amusing"
"anchored"
"ancient"
"angelic"
"angry"
"anguished"
"animated"
"annual"
"another"
"antique"
"anxious"
"any"
"apprehensive"
"appropriate"
"apt"
"arctic"
"arid"
"aromatic"
"artistic"
"ashamed"
"assured"
"astonishing"
"athletic"
"attached"
"attentive"
"attractive"
"austere"
"authentic"
"authorized"
"automatic"
"avaricious"
"average"
"aware"
"awesome"
"awful"
"awkward"
"babyish"
"bad"
"back"
"baggy"
"bare"
"barren"
"basic"
"beautiful"
"belated"
"beloved"
"beneficial"
"better"
"best"
"bewitched"
"big"
"big-hearted"
"biodegradable"
"bite-sized"
"bitter"
"black"
"black-and-white"
"bland"
"blank"
"blaring"
"bleak"
"blind"
"blissful"
"blond"
"blue"
"blushing"
"bogus"
"boiling"
"bold"
"bony"
"boring"
"bossy"
"both"
"bouncy"
"bountiful"
"bowed"
"brave"
"breakable"
"brief"
"bright"
"brilliant"
"brisk"
"broken"
"bronze"
"brown"
"bruised"
"bubbly"
"bulky"
"bumpy"
"buoyant"
"burdensome"
"burly"
"bustling"
"busy"
"buttery"
"buzzing"
"calculating"
"calm"
"candid"
"canine"
"capital"
"carefree"
"careful"
"careless"
"caring"
"cautious"
"cavernous"
"celebrated"
"charming"
"cheap"
"cheerful"
"cheery"
"chief"
"chilly"
"chubby"
"circular"
"classic"
"clean"
"clear"
"clear-cut"
"clever"
"close"
"closed"
"cloudy"
"clueless"
"clumsy"
"cluttered"
"coarse"
"cold"
"colorful"
"colorless"
"colossal"
"comfortable"
"common"
"compassionate"
"competent"
"complete"
"complex"
"complicated"
"composed"
"concerned"
"concrete"
"confused"
"conscious"
"considerate"
"constant"
"content"
"conventional"
"cooked"
"cool"
"cooperative"
"coordinated"
"corny"
"corrupt"
"costly"
"courageous"
"courteous"
"crafty"
"crazy"
"creamy"
"creative"
"creepy"
"criminal"
"crisp"
"critical"
"crooked"
"crowded"
"cruel"
"crushing"
"cuddly"
"cultivated"
"cultured"
"cumbersome"
"curly"
"curvy"
"cute"
"cylindrical"
"damaged"
"damp"
"dangerous"
"dapper"
"daring"
"darling"
"dark"
"dazzling"
"dead"
"deadly"
"deafening"
"dear"
"dearest"
"decent"
"decimal"
"decisive"
"deep"
"defenseless"
"defensive"
"defiant"
"deficient"
"definite"
"definitive"
"delayed"
"delectable"
"delicious"
"delightful"
"delirious"
"demanding"
"dense"
"dental"
"dependable"
"dependent"
"descriptive"
"deserted"
"detailed"
"determined"
"devoted"
"different"
"difficult"
"digital"
"diligent"
"dim"
"dimpled"
"dimwitted"
"direct"
"disastrous"
"discrete"
"disfigured"
"disgusting"
"disloyal"
"dismal"
"distant"
"downright"
"dreary"
"dirty"
"disguised"
"dishonest"
"dismal"
"distant"
"distinct"
"distorted"
"dizzy"
"dopey"
"doting"
"double"
"downright"
"drab"
"drafty"
"dramatic"
"dreary"
"droopy"
"dry"
"dual"
"dull"
"dutiful"
"each"
"eager"
"earnest"
"early"
"easy"
"easy-going"
"ecstatic"
"edible"
"educated"
"elaborate"
"elastic"
"elated"
"elderly"
"electric"
"elegant"
"elementary"
"elliptical"
"embarrassed"
"embellished"
"eminent"
"emotional"
"empty"
"enchanted"
"enchanting"
"energetic"
"enlightened"
"enormous"
"enraged"
"entire"
"envious"
"equal"
"equatorial"
"essential"
"esteemed"
"ethical"
"euphoric"
"even"
"evergreen"
"everlasting"
"every"
"evil"
"exalted"
"excellent"
"exemplary"
"exhausted"
"excitable"
"excited"
"exciting"
"exotic"
"expensive"
"experienced"
"expert"
"extraneous"
"extroverted"
"extra-large"
"extra-small"
"fabulous"
"failing"
"faint"
"fair"
"faithful"
"fake"
"false"
"familiar"
"famous"
"fancy"
"fantastic"
"far"
"faraway"
"far-flung"
"far-off"
"fast"
"fat"
"fatal"
"fatherly"
"favorable"
"favorite"
"fearful"
"fearless"
"feisty"
"feline"
"female"
"feminine"
"few"
"fickle"
"filthy"
"fine"
"finished"
"firm"
"first"
"firsthand"
"fitting"
"fixed"
"flaky"
"flamboyant"
"flashy"
"flat"
"flawed"
"flawless"
"flickering"
"flimsy"
"flippant"
"flowery"
"fluffy"
"fluid"
"flustered"
"focused"
"fond"
"foolhardy"
"foolish"
"forceful"
"forked"
"formal"
"forsaken"
"forthright"
"fortunate"
"fragrant"
"frail"
"frank"
"frayed"
"free"
"French"
"fresh"
"frequent"
"friendly"
"frightened"
"frightening"
"frigid"
"frilly"
"frizzy"
"frivolous"
"front"
"frosty"
"frozen"
"frugal"
"fruitful"
"full"
"fumbling"
"functional"
"funny"
"fussy"
"fuzzy"
"gargantuan"
"gaseous"
"general"
"generous"
"gentle"
"genuine"
"giant"
"giddy"
"gigantic"
"gifted"
"giving"
"glamorous"
"glaring"
"glass"
"gleaming"
"gleeful"
"glistening"
"glittering"
"gloomy"
"glorious"
"glossy"
"glum"
"golden"
"good"
"good-natured"
"gorgeous"
"graceful"
"gracious"
"grand"
"grandiose"
"granular"
"grateful"
"grave"
"gray"
"great"
"greedy"
"green"
"gregarious"
"grim"
"grimy"
"gripping"
"grizzled"
"gross"
"grotesque"
"grouchy"
"grounded"
"growing"
"growling"
"grown"
"grubby"
"gruesome"
"grumpy"
"guilty"
"gullible"
"gummy"
"hairy"
"half"
"handmade"
"handsome"
"handy"
"happy"
"happy-go-lucky"
"hard"
"hard-to-find"
"harmful"
"harmless"
"harmonious"
"harsh"
"hasty"
"hateful"
"haunting"
"healthy"
"heartfelt"
"hearty"
"heavenly"
"heavy"
"hefty"
"helpful"
"helpless"
"hidden"
"hideous"
"high"
"high-level"
"hilarious"
"hoarse"
"hollow"
"homely"
"honest"
"honorable"
"honored"
"hopeful"
"horrible"
"hospitable"
"hot"
"huge"
"humble"
"humiliating"
"humming"
"humongous"
"hungry"
"hurtful"
"husky"
"icky"
"icy"
"ideal"
"idealistic"
"identical"
"idle"
"idiotic"
"idolized"
"ignorant"
"ill"
"illegal"
"ill-fated"
"ill-informed"
"illiterate"
"illustrious"
"imaginary"
"imaginative"
"immaculate"
"immaterial"
"immediate"
"immense"
"impassioned"
"impeccable"
"impartial"
"imperfect"
"imperturbable"
"impish"
"impolite"
"important"
"impossible"
"impractical"
"impressionable"
"impressive"
"improbable"
"impure"
"inborn"
"incomparable"
"incompatible"
"incomplete"
"inconsequential"
"incredible"
"indelible"
"inexperienced"
"indolent"
"infamous"
"infantile"
"infatuated"
"inferior"
"infinite"
"informal"
"innocent"
"insecure"
"insidious"
"insignificant"
"insistent"
"instructive"
"insubstantial"
"intelligent"
"intent"
"intentional"
"interesting"
"internal"
"international"
"intrepid"
"ironclad"
"irresponsible"
"irritating"
"itchy"
"jaded"
"jagged"
"jam-packed"
"jaunty"
"jealous"
"jittery"
"joint"
"jolly"
"jovial"
"joyful"
"joyous"
"jubilant"
"judicious"
"juicy"
"jumbo"
"junior"
"jumpy"
"juvenile"
"kaleidoscopic"
"keen"
"key"
"kind"
"kindhearted"
"kindly"
"klutzy"
"knobby"
"knotty"
"knowledgeable"
"knowing"
"known"
"kooky"
"kosher"
"lame"
"lanky"
"large"
"last"
"lasting"
"late"
"lavish"
"lawful"
"lazy"
"leading"
"lean"
"leafy"
"left"
"legal"
"legitimate"
"light"
"lighthearted"
"likable"
"likely"
"limited"
"limp"
"limping"
"linear"
"lined"
"liquid"
"little"
"live"
"lively"
"livid"
"loathsome"
"lone"
"lonely"
"long"
"long-term"
"loose"
"lopsided"
"lost"
"loud"
"lovable"
"lovely"
"loving"
"low"
"loyal"
"lucky"
"lumbering"
"luminous"
"lumpy"
"lustrous"
"luxurious"
"mad"
"made-up"
"magnificent"
"majestic"
"major"
"male"
"mammoth"
"married"
"marvelous"
"masculine"
"massive"
"mature"
"meager"
"mealy"
"mean"
"measly"
"meaty"
"medical"
"mediocre"
"medium"
"meek"
"mellow"
"melodic"
"memorable"
"menacing"
"merry"
"messy"
"metallic"
"mild"
"milky"
"mindless"
"miniature"
"minor"
"minty"
"miserable"
"miserly"
"misguided"
"misty"
"mixed"
"modern"
"modest"
"moist"
"monstrous"
"monthly"
"monumental"
"moral"
"mortified"
"motherly"
"motionless"
"mountainous"
"muddy"
"muffled"
"multicolored"
"mundane"
"murky"
"mushy"
"musty"
"muted"
"mysterious"
"naive"
"narrow"
"nasty"
"natural"
"naughty"
"nautical"
"near"
"neat"
"necessary"
"needy"
"negative"
"neglected"
"negligible"
"neighboring"
"nervous"
"new"
"next"
"nice"
"nifty"
"nimble"
"nippy"
"nocturnal"
"noisy"
"nonstop"
"normal"
"notable"
"noted"
"noteworthy"
"novel"
"noxious"
"numb"
"nutritious"
"nutty"
"obedient"
"obese"
"oblong"
"oily"
"oblong"
"obvious"
"occasional"
"odd"
"oddball"
"offbeat"
"offensive"
"official"
"old"
"old-fashioned"
"only"
"open"
"optimal"
"optimistic"
"opulent"
"orange"
"orderly"
"organic"
"ornate"
"ornery"
"ordinary"
"original"
"other"
"our"
"outlying"
"outgoing"
"outlandish"
"outrageous"
"outstanding"
"oval"
"overcooked"
"overdue"
"overjoyed"
"onerlooked"
"palatable"
"pale"
"paltry"
"parallel"
"parched"
"partial"
"passionate"
"past"
"pastel"
"peaceful"
"peppery"
"perfect"
"perfumed"
"periodic"
"perky"
"personal"
"pertinent"
"pesky"
"pessimistic"
"petty"
"phony"
"physical"
"piercing"
"pink"
"pitiful"
"plain"
"plaintive"
"plastic"
"playful"
"pleasant"
"pleased"
"pleasing"
"plump"
"plush"
"polished"
"polite"
"political"
"pointed"
"pointless"
"poised"
"poor"
"popular"
"portly"
"posh"
"positive"
"possible"
"potable"
"powerful"
"powerless"
"practical"
"precious"
"present"
"prestigious"
"pretty"
"precious"
"previous"
"pricey"
"prickly"
"primary"
"prime"
"pristine"
"private"
"prize"
"probable"
"productive"
"profitable"
"profuse"
"proper"
"proud"
"prudent"
"punctual"
"pungent"
"puny"
"pure"
"purple"
"pushy"
"putrid"
"puzzled"
"puzzling"
"quaint"
"qualified"
"quarrelsome"
"quarterly"
"queasy"
"querulous"
"questionable"
"quick"
"quick-witted"
"quiet"
"quintessential"
"quirky"
"quixotic"
"quizzical"
"radiant"
"ragged"
"rapid"
"rare"
"rash"
"raw"
"recent"
"reckless"
"rectangular"
"ready"
"real"
"realistic"
"reasonable"
"red"
"reflecting"
"regal"
"regular"
"reliable"
"relieved"
"remarkable"
"remorseful"
"remote"
"repentant"
"required"
"respectful"
"responsible"
"repulsive"
"revolving"
"rewarding"
"rich"
"rigid"
"right"
"ringed"
"ripe"
"roasted"
"robust"
"rosy"
"rotating"
"rotten"
"rough"
"round"
"rowdy"
"royal"
"rubbery"
"rundown"
"ruddy"
"rude"
"runny"
"rural"
"rusty"
"sad"
"safe"
"salty"
"same"
"sandy"
"sane"
"sarcastic"
"sardonic"
"satisfied"
"scaly"
"scarce"
"scared"
"scary"
"scented"
"scholarly"
"scientific"
"scornful"
"scratchy"
"scrawny"
"second"
"secondary"
"second-hand"
"secret"
"self-assured"
"self-reliant"
"selfish"
"sentimental"
"separate"
"serene"
"serious"
"serpentine"
"several"
"severe"
"shabby"
"shadowy"
"shady"
"shallow"
"shameful"
"shameless"
"sharp"
"shimmering"
"shiny"
"shocked"
"shocking"
"shoddy"
"short"
"short-term"
"showy"
"shrill"
"shy"
"sick"
"silent"
"silky"
"silly"
"silver"
"similar"
"simple"
"simplistic"
"sinful"
"single"
"sizzling"
"skeletal"
"skinny"
"sleepy"
"slight"
"slim"
"slimy"
"slippery"
"slow"
"slushy"
"small"
"smart"
"smoggy"
"smooth"
"smug"
"snappy"
"snarling"
"sneaky"
"sniveling"
"snoopy"
"sociable"
"soft"
"soggy"
"solid"
"somber"
"some"
"spherical"
"sophisticated"
"sore"
"sorrowful"
"soulful"
"soupy"
"sour"
"Spanish"
"sparkling"
"sparse"
"specific"
"spectacular"
"speedy"
"spicy"
"spiffy"
"spirited"
"spiteful"
"splendid"
"spotless"
"spotted"
"spry"
"square"
"squeaky"
"squiggly"
"stable"
"staid"
"stained"
"stale"
"standard"
"starchy"
"stark"
"starry"
"steep"
"sticky"
"stiff"
"stimulating"
"stingy"
"stormy"
"straight"
"strange"
"steel"
"strict"
"strident"
"striking"
"striped"
"strong"
"studious"
"stunning"
"stupendous"
"stupid"
"sturdy"
"stylish"
"subdued"
"submissive"
"substantial"
"subtle"
"suburban"
"sudden"
"sugary"
"sunny"
"super"
"superb"
"superficial"
"superior"
"supportive"
"sure-footed"
"surprised"
"suspicious"
"svelte"
"sweaty"
"sweet"
"sweltering"
"swift"
"sympathetic"
"tall"
"talkative"
"tame"
"tan"
"tangible"
"tart"
"tasty"
"tattered"
"taut"
"tedious"
"teeming"
"tempting"
"tender"
"tense"
"tepid"
"terrible"
"terrific"
"testy"
"thankful"
"that"
"these"
"thick"
"thin"
"third"
"thirsty"
"this"
"thorough"
"thorny"
"those"
"thoughtful"
"threadbare"
"thrifty"
"thunderous"
"tidy"
"tight"
"timely"
"tinted"
"tiny"
"tired"
"torn"
"total"
"tough"
"traumatic"
"treasured"
"tremendous"
"tragic"
"trained"
"tremendous"
"triangular"
"tricky"
"trifling"
"trim"
"trivial"
"troubled"
"true"
"trusting"
"trustworthy"
"trusty"
"truthful"
"tubby"
"turbulent"
"twin"
"ugly"
"ultimate"
"unacceptable"
"unaware"
"uncomfortable"
"uncommon"
"unconscious"
"understated"
"unequaled"
"uneven"
"unfinished"
"unfit"
"unfolded"
"unfortunate"
"unhappy"
"unhealthy"
"uniform"
"unimportant"
"unique"
"united"
"unkempt"
"unknown"
"unlawful"
"unlined"
"unlucky"
"unnatural"
"unpleasant"
"unrealistic"
"unripe"
"unruly"
"unselfish"
"unsightly"
"unsteady"
"unsung"
"untidy"
"untimely"
"untried"
"untrue"
"unused"
"unusual"
"unwelcome"
"unwieldy"
"unwilling"
"unwitting"
"unwritten"
"upbeat"
"upright"
"upset"
"urban"
"usable"
"used"
"useful"
"useless"
"utilized"
"utter"
"vacant"
"vague"
"vain"
"valid"
"valuable"
"vapid"
"variable"
"vast"
"velvety"
"venerated"
"vengeful"
"verifiable"
"vibrant"
"vicious"
"victorious"
"vigilant"
"vigorous"
"villainous"
"violet"
"violent"
"virtual"
"virtuous"
"visible"
"vital"
"vivacious"
"vivid"
"voluminous"
"wan"
"warlike"
"warm"
"warmhearted"
"warped"
"wary"
"wasteful"
"watchful"
"waterlogged"
"watery"
"wavy"
"wealthy"
"weak"
"weary"
"webbed"
"wee"
"weekly"
"weepy"
"weighty"
"weird"
"welcome"
"well-documented"
"well-groomed"
"well-informed"
"well-lit"
"well-made"
"well-off"
"well-to-do"
"well-worn"
"wet"
"which"
"whimsical"
"whirlwind"
"whispered"
"white"
"whole"
"whopping"
"wicked"
"wide"
"wide-eyed"
"wiggly"
"wild"
"willing"
"wilted"
"winding"
"windy"
"winged"
"wiry"
"wise"
"witty"
"wobbly"
"woeful"
"wonderful"
"wooden"
"woozy"
"wordy"
"worldly"
"worn"
"worried"
"worrisome"
"worse"
"worst"
"worthless"
"worthwhile"
"worthy"
"wrathful"
"wretched"
"writhing"
"wrong"
"wry"
"yawning"
"yearly"
"yellow"
"yellowish"
"young"
"youthful"
"yummy"
}
bMotion_abstract_add_filter "scrap_adjectives" "mamoth"

bMotion_abstract_register "scrap_power_adjectives" {
  "super powered"
  "steam powered"
  "wind powered"
  "solar powered"
  "diesel powered"
  "electric"
  "hydraulic"
  "pneumatic"
  "motorised"
  "manual"
  "mechanical"
  "kinetic"
  "clockwork"
  "electronic"
  "biological"
  "unpowered"
  "spring loaded"
  "winched"
  "chain driven"
  "pressurised"
	"nuclear"
	"atomic"
}

bMotion_abstract_register "scrap_construction" {
  "barge"
  "submarine"
  "torpedo"
  "tractor"
  "combine harvestor"
  "bolt cutter"
  "generator"
  "digger"
  "monowheel"
  "hovercraft"
  "car crusher"
  "train"
  "railroad racer"
  "tug"
  "rifle"
  "air cannon"
  "drag racer"
  "liquid transporter"
  "cable car"
  "monorail"
  "motorbike"
  "wood cutter"
  "raft"
  "jet-ski"
  "crop duster"
  "aeroplane"
  "glider"
  "helicopter"
  "monster truck"
  "grenade launcher"
  "golf-ball-driver"
  "satellite"
  "go kart"
  "scooter"
  "bunker"
  "pillbox"
  "4X4"
  "landing craft"
  "dodgem"
  "pistol"
  "signal flare"
  "wagon"
  "bus"
  "APC"
  "rocket"
  "keyboard"
  "projector"
  "fan"
  "sword"
  "shield"
  "sledge"
  "lorry"
  "truck"
  "catapult"
  "missile"
  "gyroscope"
}


bMotion_abstract_register "scrap_silly_qualities_t" {
  "weird"
  "strange"
  "bizzare"
  "alien"
  "mysterious"
  "elven"
  "orcish"
  "goblinoid"
  "magical"
	"spooky"
}

bMotion_abstract_register "scrap_silly_adjectives_t" {
  "spotty"
  "funny"
  "furry"
  "wobbly"
  "bouncy"
  "cuddly"
  "cute"
  "sweet"
  "ugly"
  "multi-coloured"
  "anti -"
  "inflatable"
  "virtual"

  "mighty morphing"
  "wacky racing"
  "rib tickling"
  "thigh slapping"
  "artificially intelligent"
  "manic mining"
}

bMotion_abstract_register "scrap_silly_power_adjectives_t" {
  "lunar powered"
  "psychicly charged"
  "hamster powered"
  "soul powered"
  "%ruser powered"
  "%VAR{sillyThings} driven"
  "pure evil"
  "plasma powered"
}

bMotion_abstract_register "scrap_silly_construction_t" {
  "blamanche"
  "fork"
  "knife"
  "plate"
  "spoon"
  "party popper"
  "zord"
  "mega zord"
  "turbo mega power zord"
  "transformer"
  "beanie baby"
  "unicycle"
  "baby"
  "welly wanger"
  "football"
  "website"
  "server"
  "daemon"
  "imp"
  "angel"
  "ATAT"
  "star destroyer"
  "starship"
  "space station"
  "probe"
  "%ruser"
  "megaphone"
  "postbox"
  "starbase"
  "rabbit"
  "cartoon character"
  "prom dress"
  "hula skirt"
  "dunce's cap"
  "crown"
  "cocktail machine"
  "beer keg"
  "action hero"
  "taunt"
  "teleporter"
  "phaser"
  "disruptor"
  "beam of light"
  "quark"
  "neutrino"
  "tachyon"
  "postcard"
  "printing press"
  "cash printing machine"
"air conditioner"
"alarm clock"
"answering machine"
"BBQ grill"
"barbecue grill"
"blender"
"blowdryer"
"burglar alarm"
"calculator"
"camera"
"can opener"
"CD player"
"ceiling fan"
"cell phone"
"clock"
"clothes dryer"
"clothes washer"
"coffee grinder"
"coffee maker"
"computer"
"convection oven"
"copier"
"crock pot"
"curling iron"
"dishwasher"
"doorbell"
"dryer"
"edger"
"espresso maker"
"fan"
"fax machine"
"fire alarm"
"fire extinguisher"
"fireplace"
"flashlight"
"flatscreen TV"
"food processor"
"freezer"
"furnace"
"garage door"
"garbage disposal"
"GPS"
"grill"
"hair clippers"
"hair dryer"
"headphones"
"heater"
"hood"
"hot plate"
"humidifier"
"ice cream maker"
"iron"
"kerosene heater"
"lamp"
"lantern"
"laptop"
"lawn mower"
"leaf blower"
"microwave oven"
"mousetrap"
"MP3 player"
"oven"
"percolator"
"pressure cooker"
"printer"
"radio"
"record player"
"refrigerator"
"rotisserie"
"scanner"
"sewing machine"
"smoke detector"
"stapler"
"stereo"
"telephone"
"television"
"timer"
"toaster"
"toaster oven"
"torch"
"trash compactor"
"trimmer"
"TV"
"vacuum cleaner"
"vaporizer"
"VCR"
"video camera"
"video game machine"
"waffle iron"
"walkie-talkie"
"washing machine"
"watch"
"water heater"
}
bMotion_abstract_add_filter "scrap_silly_construction_t" "coktail machine"

bMotion_abstract_register "scrap_adult_qualities_t" {
  "well formed"
  "well rounded"
  "slinky"
  "slender"
  "slim"
  "voluptuous"
  "bound"
  "minging"
  "doggish"
}

bMotion_abstract_register "scrap_adult_adjectives_t" {
  "norty"
  "vary norty"
  "sexy"
  "horny"
  "firm"
  "supple"
  "sticky"
  "moist"
  "wet"
  "sweaty"
  "hot"
  "steamy"
  "licking"
  "tight"
  "curvy"
  "undulating"
  "gyrating"
  "shafting"
  "vibrating"
  "lubricating"
  "tasty"
  "fondling"
  "cuddling"
  "masturbating"
  "shagging"
  "fucking"
  "screwing"
  "bulging"
  "tight"
  "loose"
  "pole dancing"
  "stripping"
	"arousing"
	"exciting"
	"gentle"
	"ENORMOUS"
	"creepy"
	"damp"
	"hot"
	"warm"
	"substantial"
	"anal"
	"3D"
	"HD"
	"homosexual"
	"heterosexual"
	"wanking"
	"lactating"
	"vaginal"
	"racist"
	"dumping"
	"mongy"
	"nude"
	"barfing"
}
bMotion_abstract_add_filter "scrap_adult_adjectives_t" "girating"

bMotion_abstract_register "scrap_adult_power_adjectives_t" {
  "jizz powered"
  "love juice powered"
  "sweat powered"
  "motion powered"
  "grunt powered"
  "cum powered"
}

bMotion_abstract_register "scrap_adult_construction_t" {
  "dildo"
  "love doll"
  "vibrator"
  "whip"
  "melon"
  "shaft"
  "gyrator"
  "stroking device"
  "n0rty bits"
  "nipple tweaker"
  "underwear"
  "suction pump"
  "sheep"
  "rump"
  "penis"
  "cunt"
  "tit"
  "arse"
  "tongue"
  "lip"
  "mouth"
  "teenager"
  "prostitute"
  "rent-boy"
  "whore"
  "wench"
  "bitch"
  "mistress"
  "box"
  "dominatrix"
	"butt plug"
	"nipple clamp"
	"gigolo"
	"jockstrap"
	"knickers"
	"pants"
	"handcuffs"
	"bone"
	"dog"
	"condom"
	"shit"
	"anus"
	"blowjob"
	"gentials"
	"fart"
	"dick"
}
bMotion_abstract_add_filter "scrap_adult_construction_t" "girator"

#create the big lists :)
bMotion_abstract_register "scrap_silly_qualities" {
  "%VAR{scrap_qualities}"
  "%VAR{scrap_silly_qualities_t}"
}
bMotion_abstract_register "scrap_silly_power_adjectives" {
  "%VAR{scrap_power_adjectives}"
  "%VAR{scrap_silly_power_adjectives_t}"
}
bMotion_abstract_register "scrap_silly_adjectives" {
  "%VAR{scrap_adjectives}"
  "%VAR{scrap_silly_adjectives_t}"
}
bMotion_abstract_register "scrap_silly_construction" {
  "%VAR{scrap_construction}"
  "%VAR{scrap_silly_construction_t}"
}

bMotion_abstract_register "scrap_adult_qualities" {
  "%VAR{scrap_qualities}"
  "%VAR{scrap_adult_qualities_t}"
}
bMotion_abstract_register "scrap_adult_power_adjectives" {
  "%VAR{scrap_power_adjectives}"
  "%VAR{scrap_adult_power_adjectives_t}"
}
bMotion_abstract_register "scrap_adult_adjectives" {
  "%VAR{scrap_adjectives}"
  "%VAR{scrap_adult_adjectives_t}"
}
bMotion_abstract_register "scrap_adult_construction" {
  "%VAR{scrap_construction}"
  "%VAR{scrap_adult_construction_t}"
}

bMotion_abstract_register "scrap_silly_adult_qualities" {
  "%VAR{scrap_qualities}"
  "%VAR{scrap_silly_qualities_t}"
}
bMotion_abstract_register "scrap_silly_adult_power_adjectives" {
  "%VAR{scrap_power_adjectives}"
  "%VAR{scrap_silly_power_adjectives_t}"
}
bMotion_abstract_register "scrap_silly_adult_adjectives" {
  "%VAR{scrap_adjectives}"
  "%VAR{scrap_silly_adjectives_t}"
}
bMotion_abstract_register "scrap_silly_adult_construction" {
  "%VAR{scrap_construction}"
  "%VAR{scrap_silly_construction_t}"
}

#duplicate for second adjectives
bMotion_abstract_register "scrap_silly_adjectives2" {
  "%VAR{scrap_silly_adjectives}"
}
bMotion_abstract_register "scrap_adult_adjectives2" {
  "%VAR{scrap_adult_adjectives}"
}
bMotion_abstract_register "scrap_silly_adult_adjectives2" {
  "%VAR{scrap_silly_adult_adjectives}"
}
bMotion_abstract_register "scrap_adjectives2" {
  "%VAR{scrap_adjectives}"
}