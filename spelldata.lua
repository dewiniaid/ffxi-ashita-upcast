local tieredSpells = T{
    ["addle"] = {286, 884},
    ["aera"] = {832, 833, 867},
    ["aero"] = {154, 155, 156, 157, 158, 851},
    ["aeroga"] = {184, 185, 186, 187, 188},
    ["anemohelix"] = {280, 887},
    ["arciela"] = {965, 1017},
    ["army's paeon"] = {378, 379, 380, 381, 382, 383, 384, 385},
    ["aspir"] = {247, 248, 881},
    ["aurorastorm"] = {119, 864},
    ["banish"] = {28, 29, 30, 31, 32},
    ["banishga"] = {38, 39, 40, 41, 42},
    ["bio"] = {230, 231, 232, 233, 234},
    ["blind"] = {254, 276},
    ["blizzaga"] = {179, 180, 181, 182, 183},
    ["blizzara"] = {830, 831, 866},
    ["blizzard"] = {149, 150, 151, 152, 153, 850},
    ["burst"] = {212, 213},
    ["cryohelix"] = {282, 889},
    ["cura"] = {93, 474, 475},
    ["curaga"] = {7, 8, 9, 10, 11},
    ["cure"] = {1, 2, 3, 4, 5, 6},
    ["dark carol"] = {445, 453},
    ["dark threnody"] = {461, 878},
    ["dia"] = {23, 24, 25, 26, 27},
    ["diaga"] = {33, 34, 35, 36, 37},
    ["distract"] = {841, 842, 882},
    ["dokumori"] = {350, 351, 352},
    ["doton"] = {329, 330, 331},
    ["drain"] = {245, 246, 880},
    ["earth carol"] = {441, 449},
    ["earth threnody"] = {457, 874},
    ["enaero"] = {102, 314},
    ["enblizzard"] = {101, 313},
    ["endark"] = {311, 856},
    ["enfire"] = {100, 312},
    ["enlight"] = {310, 855},
    ["enstone"] = {103, 315},
    ["enthunder"] = {104, 316},
    ["enwater"] = {105, 317},
    ["fira"] = {828, 829, 865},
    ["firaga"] = {174, 175, 176, 177, 178},
    ["fire"] = {144, 145, 146, 147, 148, 849},
    ["fire carol"] = {438, 446},
    ["fire threnody"] = {454, 871},
    ["firestorm"] = {115, 860},
    ["flare"] = {204, 205},
    ["flood"] = {214, 215},
    ["flurry"] = {845, 846},
    ["foe lullaby"] = {463, 471},
    ["foe requiem"] = {368, 369, 370, 371, 372, 373, 374, 375},
    ["frazzle"] = {843, 844, 883},
    ["freeze"] = {206, 207},
    ["geohelix"] = {278, 885},
    ["gravity"] = {216, 217},
    ["hailstorm"] = {116, 861},
    ["haste"] = {57, 511},
    ["hojo"] = {344, 345, 346},
    ["holy"] = {21, 22},
    ["horde lullaby"] = {376, 377},
    ["huton"] = {326, 327, 328},
    ["hydrohelix"] = {279, 886},
    ["hyoton"] = {323, 324, 325},
    ["ice carol"] = {439, 447},
    ["ice threnody"] = {455, 872},
    ["ingrid"] = {921, 1016},
    ["ionohelix"] = {283, 890},
    ["iroha"] = {997, 1018},
    ["jubaku"] = {341, 342, 343},
    ["katon"] = {320, 321, 322},
    ["knight's minne"] = {389, 390, 391, 392, 393},
    ["kurayami"] = {347, 348, 349},
    ["light carol"] = {444, 452},
    ["light threnody"] = {460, 877},
    ["lightning carol"] = {442, 450},
    ["lilisette"] = {945, 1013},
    ["lion"] = {907, 1009},
    ["ltng. threnody"] = {458, 875},
    ["luminohelix"] = {285, 892},
    ["mage's ballad"] = {386, 387, 388},
    ["meteor"] = {218, 244},
    ["mumor"] = {946, 1015},
    ["nashmeira"] = {923, 1012},
    ["noctohelix"] = {284, 891},
    ["paralyze"] = {58, 80},
    ["phalanx"] = {106, 107},
    ["poison"] = {220, 221, 222, 223, 224},
    ["poisonga"] = {225, 226, 227, 228, 229},
    ["prishe"] = {913, 1011},
    ["protect"] = {43, 44, 45, 46, 47},
    ["protectra"] = {125, 126, 127, 128, 129},
    ["pyrohelix"] = {281, 888},
    ["quake"] = {210, 211},
    ["rainstorm"] = {113, 858},
    ["raise"] = {12, 13, 140},
    ["raiton"] = {332, 333, 334},
    ["refresh"] = {109, 473, 894},
    ["regen"] = {108, 110, 111, 477, 504},
    ["reraise"] = {135, 141, 142, 848},
    ["sandstorm"] = {99, 857},
    ["shantotto"] = {896, 1019},
    ["shell"] = {48, 49, 50, 51, 52},
    ["shellra"] = {130, 131, 132, 133, 134},
    ["sleep"] = {253, 259},
    ["sleepga"] = {273, 274},
    ["slow"] = {56, 79},
    ["stone"] = {159, 160, 161, 162, 163, 852},
    ["stonega"] = {189, 190, 191, 192, 193},
    ["stonera"] = {834, 835, 868},
    ["suiton"] = {335, 336, 337},
    ["temper"] = {493, 895},
    ["tenzen"] = {908, 1014},
    ["thundaga"] = {194, 195, 196, 197, 198},
    ["thundara"] = {836, 837, 869},
    ["thunder"] = {164, 165, 166, 167, 168, 853},
    ["thunderstorm"] = {117, 862},
    ["tonko"] = {353, 354},
    ["tornado"] = {208, 209},
    ["tractor"] = {264, 265},
    ["utsusemi"] = {338, 339, 340},
    ["valor minuet"] = {394, 395, 396, 397, 398},
    ["voidstorm"] = {118, 863},
    ["warp"] = {261, 262},
    ["water"] = {169, 170, 171, 172, 173, 854},
    ["water carol"] = {443, 451},
    ["water threnody"] = {459, 876},
    ["watera"] = {838, 839, 870},
    ["waterga"] = {199, 200, 201, 202, 203},
    ["wind carol"] = {440, 448},
    ["wind threnody"] = {456, 873},
    ["windstorm"] = {114, 859},
    ["zeid"] = {906, 1010},
    ["mazurka"] = {467, 465},
    ["mambo"] = {403, 405},
    ["madrigal"] = {399, 400},
    ["elegy"] = {421, 422, 423},
    ["march"] = {419, 420, 417},
    ["prelude"] = {401, 402},
}

return tieredSpells
