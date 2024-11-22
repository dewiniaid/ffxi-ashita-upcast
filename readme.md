# Upcast

Upcast is an Ashita4 addon that can automatically upscale spells and Dancer job abilities based off of your current 
level -- possibly factoring which spells are already in cooldown.  This can be useful in a variety of contexts, such 
as:

* Sharing a macro set across multiple mage jobs -- automatically selecting the 'Best' Thunder spell based off whether 
  you are a BLM or RDM
* Automatically rescaling spells if you are levelsynced to a friend or doing a BCNM or ENM fight
* Having a single macro that casts Thunder VI, V, IV, III, II, or just Thunder depending on what all is in cooldown

Upcast should work with:

* All numbered spells (those ending with a Roman Numeral, including tier 1 versions of the same)
* All numbered Trusts, as an extension of the above that's likely not useful
* All numbered ninjutsu (those ending with Ichi, Ni, and San)
* All tiers of Mazurka, Mambo, Madrigal, Elegy, March, and Prelude *(even though they aren't numbered)*
* All tiers of Curing Waltz, Divine Waltz, and Chocobo Jig *(even though they're not magic)*

## Usage

Type: `/upcast [options] "Base Spell" <t>`  
or: `/up [options] "Base Spell" <t>`

`"Base Spell"` is the most simplified form of spell you're casting.  For numbered spells, this is the spell with no 
number like "Thunder" or "Utsusemi".  For Bard songs, this is e.g. "Mazurka" or "Mambo", *not* "Chocobo Mazurka" or
"Sheepfoe Mambo".  Any spell or job ability that Upcast doesn't automatically tier up will be sent to the game as-is.

Like moot commands, you can omit the quotation marks if the base spell is a single word.  Unlike most commands, it is
case-insensitive -- `/upcast fire` and `/upcast Fire` are the same.

You can omit the `<t>`, in which case /upcast will default to `<t>` if it thinks your current target is a valid option 
and `<me>` if it doesn't.

`[options]` is a list of zero or more space-separated options, which can be any of the following:

* `cd` - Try to cast the highest version of the spell even if it is currently in cooldown/recast time.  (If you omit 
  this, Upcast will cast a downranked version of a spell if the selected rank is in recast time.
    
* `wr` - In addition to casting the selected spell, do `/recast "Final Spell Name"`.  This is my preference, since it
  gives clear feedback whether the macro actually registered me pushing the button or not sometimes.
  
* `ro` - *Only* do `/recast "Final Spell Name"`, don't actually cast anything.  This is useful for testing or checking
  for your own reference what the highest level of a spell is without digging through a magic menu. 
  
* `-1`, `-2`, `-3`, etc. - Skip the *N* highest available tiers of the spell.  For example, if your highest available 
  cure is Cure III, `/upcast -1 Cure` will cast Cure II.
  
Upcast commands are sent as regular `/ma` or `/ja` commands and don't inject packets, so plugins like Shorthand may
still modify the final result.