-- Lenora | CBRO


-- Services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local STATTRAK_INPUT_ACTION = "Lenora_StatTrakSubmit"

pcall(function()
    ContextActionService:UnbindAction(STATTRAK_INPUT_ACTION)
end)

local Env = getgenv()

-- don't run twice
if rawget(Env, "__LenoraRuntimeToken") ~= nil then
    warn("[Lenora] Lenora is already running in this session.")
    return
end

Env.__LenoraStop = nil
Env.__CounterBloxCustomStop = nil

local RunId = {}
Env.__LenoraRuntimeToken = RunId

-- Items

local KNIFE_TYPES = {
    "Bayonet",
    "Bearded Axe",
    "Butterfly Knife",
    "Cleaver",
    "Crowbar",
    "Falchion Classic",
    "Falchion Knife",
    "Flip Knife",
    "Gut Knife",
    "Huntsman Knife",
    "Karambit",
    "M9 Bayonet",
    "Banana",
    "Sickle",
    "Sickle Classic",
}

local GLOVE_TYPES = {
    "Fingerless Glove",
    "Handwraps",
    "Sports Glove",
    "Strapped Glove",
}

local KNIFE_NAME_SET = {}
local GLOVE_NAME_SET = {}

for _, name in KNIFE_TYPES do
    KNIFE_NAME_SET[name] = true
end

for _, name in GLOVE_TYPES do
    GLOVE_NAME_SET[name] = true
end

-- Knife models

local KNIFE_MODEL_REMAP = {
    ["Banana"]     = "Karambit",
    ["Crowbar"]    = "Karambit",
    ["Flip Knife"] = "Karambit",
}

-- Skin list

local BACKUP_SKIN_CATALOG = {
    -- AK-47
    "AK47_Ace",          "AK47_BloxersClub",  "AK47_Bloodboom",    "AK47_Clown",
    "AK47_Code Orange",  "AK47_Eve",          "AK47_Galaxy Corpse","AK47_Ghost",
    "AK47_Gifted",       "AK47_Glo",          "AK47_Godess",       "AK47_Hallows",
    "AK47_Halo",         "AK47_Hypersonic",   "AK47_Inversion",    "AK47_Jester",
    "AK47_Maker",        "AK47_Mean Green",   "AK47_Neonline",     "AK47_Outlaws",
    "AK47_Outrunner",    "AK47_Patch",        "AK47_Plated",       "AK47_Precision",
    "AK47_Quantum",      "AK47_Quicktime",    "AK47_Scapter",      "AK47_Scythe",
    "AK47_Secret Santa", "AK47_Shooting Star","AK47_Skin Committee","AK47_Spooky",
    "AK47_Super Weeb",   "AK47_Survivor",     "AK47_Toxic Nitro",  "AK47_Trinity",
    "AK47_Ugly Sweater", "AK47_VAV",          "AK47_Variant Camo", "AK47_Weeb",
    "AK47_Yltude",

    -- AUG
    "AUG_Chilly Night",  "AUG_Dream Hound",   "AUG_Enlisted",      "AUG_Equalizer",
    "AUG_Graffiti",      "AUG_Homestead",     "AUG_Maker",         "AUG_Mystique",
    "AUG_NightHawk",     "AUG_Phoenix",       "AUG_Soldier",       "AUG_Sunsthetic",

    -- AWP
    "AWP_Abaddon",       "AWP_Autumness",     "AWP_Blastech",      "AWP_BloxersClub",
    "AWP_Bloodborne",    "AWP_Coffin Biter",  "AWP_Dark Damascus", "AWP_Darkness",
    "AWP_Desert Camo",   "AWP_Difference",    "AWP_Dragon",        "AWP_Forever",
    "AWP_Grepkin",       "AWP_Grim",          "AWP_Hika",          "AWP_Illusion",
    "AWP_Instinct",      "AWP_JTF2",          "AWP_Kumanjayi",     "AWP_Lunar",
    "AWP_Nerf",          "AWP_Northern Lights","AWP_Oriental",     "AWP_Pear Tree",
    "AWP_Pink Vision",   "AWP_Pinkie",        "AWP_Pumpkin Piercer","AWP_Quicktime",
    "AWP_Racer",         "AWP_Regina",        "AWP_Retroactive",   "AWP_Scapter",
    "AWP_Silence",       "AWP_Toxic Nitro",   "AWP_Venomus",       "AWP_Weeb",

    -- Bizon
    "Bizon_Autumic",     "Bizon_Festive",     "Bizon_Oblivion",    "Bizon_Saint Nick",
    "Bizon_Sergeant",    "Bizon_Shattered",

    -- CZ
    "CZ_Designed",       "CZ_Festive",        "CZ_Hallow",         "CZ_Holidays",
    "CZ_Lightning",      "CZ_Orange Web",     "CZ_Spectre",

    -- Desert Eagle
    "DesertEagle_Ababa",        "DesertEagle_Blue Fur",     "DesertEagle_BloxersClub",
    "DesertEagle_Cold Truth",   "DesertEagle_Cool Blue",    "DesertEagle_Crystal",
    "DesertEagle_Demon Eyes",   "DesertEagle_DropX",        "DesertEagle_Glittery",
    "DesertEagle_Grim",         "DesertEagle_Guapo",        "DesertEagle_Heat",
    "DesertEagle_Honor-bound",  "DesertEagle_Independence", "DesertEagle_Krystallos",
    "DesertEagle_Pumpkin Buster","DesertEagle_Racer",       "DesertEagle_Regal Eclipse",
    "DesertEagle_ROLVe",        "DesertEagle_Scapter",      "DesertEagle_Skin Committee",
    "DesertEagle_Survivor",     "DesertEagle_TC",           "DesertEagle_Weeb",
    "DesertEagle_Xmas",

    -- Dual Berettas
    "DualBerettas_Bio-Hive",    "DualBerettas_Carbonized",  "DualBerettas_Dusty Manor",
    "DualBerettas_Floral",      "DualBerettas_Hexline",     "DualBerettas_Neon web",
    "DualBerettas_Old Fashioned","DualBerettas_Xmas",

    -- FAMAS
    "Famas_Abstract",    "Famas_Blossom",     "Famas_Catstellation","Famas_Centipede",
    "Famas_Cogged",      "Famas_Goliath",     "Famas_Haunted Forest","Famas_Imprisioned",
    "Famas_KugaX",       "Famas_Medic",       "Famas_MK11",         "Famas_Redux",
    "Famas_Shocker",     "Famas_Toxic Rain",

    -- Five-SeveN
    "FiveSeven_Accelerator",  "FiveSeven_Autumn Fade",  "FiveSeven_Creator's Eye",
    "FiveSeven_Danjo",        "FiveSeven_Fluid",        "FiveSeven_Gifted",
    "FiveSeven_Midnight Ride","FiveSeven_Mr. Anatomy",  "FiveSeven_Stigma",
    "FiveSeven_Sub Zero",     "FiveSeven_Summer",

    -- G3SG1
    "G3SG1_Amethyst",    "G3SG1_Autumn",      "G3SG1_Foliage",     "G3SG1_Hex",
    "G3SG1_Holly Bound", "G3SG1_Mahogany",

    -- Galil AR
    "Galil_Frosted",     "Galil_Hardware",    "Galil_Hardware 2",  "Galil_Toxicity",
    "Galil_Vortex",      "Galil_Worn",

    -- Glock
    "Glock_Angler",      "Glock_Anubis",      "Glock_Biotrip",     "Glock_BloxersClub",
    "Glock_Day Dreamer", "Glock_Desert Camo", "Glock_Gravestomper","Glock_Hallows",
    "Glock_Lantern",     "Glock_Midnight Tiger","Glock_Money Maker","Glock_RSL",
    "Glock_Rush",        "Glock_Scapter",     "Glock_Spacedust",   "Glock_Tarnish",
    "Glock_Underwater",  "Glock_Wetland",     "Glock_White Sauce",

    -- M249
    "M249_Aggressor",    "M249_Halloween Treats","M249_Lantern",   "M249_P2020",
    "M249_Spooky",       "M249_Wolf",

    -- M4A1-S
    "M4A1_Animatic",     "M4A1_BloxersClub",  "M4A1_Burning",      "M4A1_Desert Camo",
    "M4A1_Heavens Gate", "M4A1_Impulse",      "M4A1_Jester",       "M4A1_Lunar",
    "M4A1_Necropolis",   "M4A1_Nightmare",    "M4A1_Tecnician",    "M4A1_Toucan",
    "M4A1_Wastelander",

    -- M4A4
    "M4A4_Agony",        "M4A4_BOT[S]",       "M4A4_Candyskull",   "M4A4_Dark Damascus",
    "M4A4_Darkness",     "M4A4_Delinquent",   "M4A4_Desert Camo",  "M4A4_Devil",
    "M4A4_Endline",      "M4A4_Flashy Ride",  "M4A4_Ice Cap",      "M4A4_Jester",
    "M4A4_King",         "M4A4_Mistletoe",    "M4A4_Pinkie",       "M4A4_Pinkvision",
    "M4A4_Pondside",     "M4A4_Precision",    "M4A4_Quicktime",    "M4A4_Racer",
    "M4A4_RayTrack",     "M4A4_Scapter",      "M4A4_Stardust",     "M4A4_Toy Soldier",

    -- MAC-10
    "MAC10_Artists Intent","MAC10_Blaze",      "MAC10_Cursed Tree", "MAC10_Devil",
    "MAC10_Energy",      "MAC10_Golden Rings", "MAC10_Pimpin",      "MAC10_Scythe",
    "MAC10_Skeleboney",  "MAC10_Toxic",        "MAC10_Turbo",       "MAC10_Wetland",

    -- MAG-7
    "MAG7_Bombshell",    "MAG7_C4UTION",      "MAG7_Frosty",       "MAG7_Molten",
    "MAG7_Outbreak",     "MAG7_Striped",

    -- MP7
    "MP7_Calaxian",      "MP7_Cogged",        "MP7_Goo",           "MP7_Holiday",
    "MP7_Industrial",    "MP7_Reindeer",      "MP7_Silent Ops",    "MP7_Sunshot",
    "MP7_Trauma",        "MP7-SD_Equalizer",

    -- MP9
    "MP9_Blueroyal",     "MP9_Cob Web",       "MP9_Control",       "MP9_Cookie Man",
    "MP9_Curse",         "MP9_Decked Halls",  "MP9_SnowTime",      "MP9_Vaporwave",
    "MP9_Velvita",       "MP9_Wilderness",

    -- Negev
    "Negev_Default",     "Negev_Midnightbones","Negev_Quazar",     "Negev_Striped",
    "Negev_Wetland",     "Negev_Winterfell",

    -- Nova
    "Nova_Black Ice",    "Nova_Cookie",       "Nova_Defective",    "Nova_Oath",
    "Nova_Paradise",     "Nova_Sharkesh",     "Nova_Starry Night", "Nova_Terraformer",
    "Nova_Tiger",        "Nova_Tricked",

    -- P2000
    "P2000_Apathy",      "P2000_Camo Dipped", "P2000_Candycorn",   "P2000_Comet",
    "P2000_Dark Beast",  "P2000_Golden Age",  "P2000_Lunar",       "P2000_Pinkie",
    "P2000_Ruby",        "P2000_Silence",     "P2000_Spirit Box",

    -- P250
    "P250_Amber",        "P250_BloxersClub",  "P250_Bomber",       "P250_Equinox",
    "P250_Frosted",      "P250_Goldish",      "P250_Green Web",    "P250_Grim",
    "P250_Midnight",     "P250_Shark",        "P250_Solstice",     "P250_TC250",

    -- P90
    "P90_Argus",         "P90_Curse",         "P90_Demon Within",  "P90_Elegant",
    "P90_Krampus",       "P90_Northern Lights","P90_P-Chan",       "P90_Pine",
    "P90_Redcopy",       "P90_Skulls",

    -- R8 Revolver
    "R8_Exquisite",      "R8_Hunter",         "R8_Spades",         "R8_TG",
    "R8_Violet",

    -- Sawed-Off
    "SawedOff_Casino",   "SawedOff_Colorboom","SawedOff_Executioner","SawedOff_Opal",
    "SawedOff_Spooky",   "SawedOff_Sullys Blacklight",

    -- SSG 08 (Scout)
    "Scout_Coffin Biter","Scout_Darkness",    "Scout_Flowing Mists","Scout_Hellborn",
    "Scout_Hot Cocoa",   "Scout_Lunar",       "Scout_Monstruo",    "Scout_Neon Regulation",
    "Scout_Posh",        "Scout_Pulse",       "Scout_Railgun",     "Scout_Theory",
    "Scout_Xmas",

    -- SG 553
    "SG_Control",        "SG_Drop-Out",       "SG_DropX",          "SG_Dummy",
    "SG_Kitty Cat",      "SG_Knighthood",     "SG_Magma",          "SG_NR8",
    "SG_Variant Camo",   "SG_Yltude",

    -- Tec-9
    "Tec9_Charger",      "Tec9_Gift Wrapped", "Tec9_Ironline",     "Tec9_Performer",
    "Tec9_Phol",         "Tec9_Samurai",      "Tec9_Seasoned",     "Tec9_Skintech",
    "Tec9_Stocking Stuffer","Tec9_Whispers",

    -- UMP-45
    "UMP_Death Grip",    "UMP_Gum Drop",      "UMP_Magma",         "UMP_Militia Camo",
    "UMP_Molten",        "UMP_Orbit",         "UMP_Redline",

    -- USP-S
    "USP_Blossom",       "USP_BloxersClub",   "USP_Crimson",       "USP_Dizzy",
    "USP_Frostbite",     "USP_Holiday",       "USP_Jade Dream",    "USP_Kraken",
    "USP_Nighttown",     "USP_Paradise",      "USP_Racing",        "USP_Skull",
    "USP_Survivor",      "USP_Unseen",        "USP_Worlds Away",   "USP_Yellowbelly",

    -- XM1014
    "XM_Artic",          "XM_Atomic",         "XM_Campfire",       "XM_Endless Night",
    "XM_MK11",           "XM_Predator",       "XM_Red",            "XM_Spectrum",

    -- Bayonet
    "Bayonet_Aequalis",  "Bayonet_Banner",    "Bayonet_BloxersClub","Bayonet_Candy Cane",
    "Bayonet_Ciro",      "Bayonet_Consumed",  "Bayonet_Cosmos",    "Bayonet_Crow",
    "Bayonet_Dark Damascus","Bayonet_Decor",  "Bayonet_Delinquent","Bayonet_Digital",
    "Bayonet_Easy-Bake", "Bayonet_Egg Shell", "Bayonet_Festive",   "Bayonet_Frozen Dream",
    "Bayonet_Geo Blade", "Bayonet_Ghastly",   "Bayonet_Goo",       "Bayonet_Grim",
    "Bayonet_Hallows",   "Bayonet_Haunted",   "Bayonet_Intertwine","Bayonet_Kill or Treat",
    "Bayonet_Kimura",    "Bayonet_Mariposa",  "Bayonet_Marbleized","Bayonet_Naval",
    "Bayonet_Neonic",    "Bayonet_Racer",     "Bayonet_RSL",       "Bayonet_Sapphire",
    "Bayonet_Silent Night","Bayonet_Splattered","Bayonet_Stock",   "Bayonet_Topaz",
    "Bayonet_Tropical",  "Bayonet_Twitch",    "Bayonet_UFO",       "Bayonet_Wetland",
    "Bayonet_Worn",      "Bayonet_Wrapped",

    -- Bearded Axe
    "Bearded Axe_Beast", "Bearded Axe_Splattered", "Bearded Axe_Stock",

    -- Butterfly Knife
    "Butterfly Knife_Argus",      "Butterfly Knife_Aurora",     "Butterfly Knife_BloxersClub",
    "Butterfly Knife_Bloodwidow", "Butterfly Knife_Consumed",   "Butterfly Knife_Cosmos",
    "Butterfly Knife_Crimson Tiger","Butterfly Knife_Crippled Fade","Butterfly Knife_Dark Damascus",
    "Butterfly Knife_Digital",    "Butterfly Knife_Egg Shell",  "Butterfly Knife_Freedom",
    "Butterfly Knife_Frozen Dream","Butterfly Knife_Goo",       "Butterfly Knife_Grim",
    "Butterfly Knife_Hallows",    "Butterfly Knife_Icicle",     "Butterfly Knife_Inversion",
    "Butterfly Knife_Jade Dream", "Butterfly Knife_Marbleized", "Butterfly Knife_Naval",
    "Butterfly Knife_Neonic",     "Butterfly Knife_Reaper",     "Butterfly Knife_Ruby",
    "Butterfly Knife_Scapter",    "Butterfly Knife_Snowfall",   "Butterfly Knife_Splattered",
    "Butterfly Knife_Spooky",     "Butterfly Knife_Stock",      "Butterfly Knife_Topaz",
    "Butterfly Knife_Tropical",   "Butterfly Knife_Twitch",     "Butterfly Knife_Wetland",
    "Butterfly Knife_White Boss", "Butterfly Knife_Worn",       "Butterfly Knife_Wrapped",

    -- Cleaver & Crowbar
    "Cleaver_Spider",    "Cleaver_Splattered", "Cleaver_Stock",
    "Crowbar_Stock",

    -- Falchion
    "Falchion Classic_Late Night", "Falchion Classic_Stock",
    "Falchion Knife_Bloodwidow",  "Falchion Knife_Chosen",      "Falchion Knife_Cocoa",
    "Falchion Knife_Coal",        "Falchion Knife_Consumed",    "Falchion Knife_Cosmos",
    "Falchion Knife_Crimson Tiger","Falchion Knife_Crippled Fade","Falchion Knife_Dark Damascus",
    "Falchion Knife_Digital",     "Falchion Knife_Egg Shell",   "Falchion Knife_Festive",
    "Falchion Knife_Freedom",     "Falchion Knife_Frozen Dream","Falchion Knife_Goo",
    "Falchion Knife_Grim",        "Falchion Knife_Hallows",     "Falchion Knife_Inversion",
    "Falchion Knife_Kimura",      "Falchion Knife_Late Night",  "Falchion Knife_Marbleized",
    "Falchion Knife_Naval",       "Falchion Knife_Neonic",      "Falchion Knife_Pumpkin",
    "Falchion Knife_Racer",       "Falchion Knife_Ruby",        "Falchion Knife_Splattered",
    "Falchion Knife_Stock",       "Falchion Knife_Topaz",       "Falchion Knife_Toxic Nitro",
    "Falchion Knife_Tropical",    "Falchion Knife_Twilight",    "Falchion Knife_Wetland",
    "Falchion Knife_Worn",        "Falchion Knife_Wrapped",     "Falchion Knife_Zombie",

    -- Flip Knife
    "Flip Knife_Stock",

    -- Gut Knife
    "Gut Knife_Banner",      "Gut Knife_Cob Web",     "Gut Knife_Consumed",
    "Gut Knife_Cosmos",      "Gut Knife_Crimson Tiger","Gut Knife_Crippled Fade",
    "Gut Knife_Dark Damascus","Gut Knife_Digital",     "Gut Knife_Egg Shell",
    "Gut Knife_Frozen Dream","Gut Knife_Geo Blade",   "Gut Knife_Goo",
    "Gut Knife_Grim",        "Gut Knife_Hallows",     "Gut Knife_Holly",
    "Gut Knife_Lurker",      "Gut Knife_Marbleized",  "Gut Knife_Naval",
    "Gut Knife_Neonic",      "Gut Knife_Present",     "Gut Knife_Ruby",
    "Gut Knife_Rusty",       "Gut Knife_Splattered",  "Gut Knife_Topaz",
    "Gut Knife_Tropical",    "Gut Knife_Wetland",     "Gut Knife_Worn",
    "Gut Knife_Wrapped",     "Gut Knife_Stock",

    -- Huntsman Knife
    "Huntsman Knife_Aurora",      "Huntsman Knife_Bloodwidow",  "Huntsman Knife_Ciro",
    "Huntsman Knife_Consumed",    "Huntsman Knife_Cosmos",      "Huntsman Knife_Cozy",
    "Huntsman Knife_Crimson Tiger","Huntsman Knife_Crippled Fade","Huntsman Knife_Dark Damascus",
    "Huntsman Knife_Digital",     "Huntsman Knife_Drop-Out",    "Huntsman Knife_Egg Shell",
    "Huntsman Knife_Frozen Dream","Huntsman Knife_Geo Blade",   "Huntsman Knife_Goo",
    "Huntsman Knife_Grim",        "Huntsman Knife_Hallows",     "Huntsman Knife_Honor Fade",
    "Huntsman Knife_Marbleized",  "Huntsman Knife_Monster",     "Huntsman Knife_Naval",
    "Huntsman Knife_Ruby",        "Huntsman Knife_Splattered",  "Huntsman Knife_Spookiness",
    "Huntsman Knife_Spirit",      "Huntsman Knife_Stock",       "Huntsman Knife_Tropical",
    "Huntsman Knife_Twitch",      "Huntsman Knife_Wetland",     "Huntsman Knife_Worn",
    "Huntsman Knife_Wrapped",

    -- Karambit
    "Karambit_Bloodwidow",   "Karambit_Ciro",        "Karambit_Cob Web",
    "Karambit_Consumed",     "Karambit_Cosmos",      "Karambit_Crimson Tiger",
    "Karambit_Crippled Fade","Karambit_Dark Damascus","Karambit_Death Wish",
    "Karambit_Digital",      "Karambit_Drop-Out",    "Karambit_Egg Shell",
    "Karambit_Festive",      "Karambit_Frozen Dream","Karambit_Ghost",
    "Karambit_Glossed",      "Karambit_Gold",        "Karambit_Goo",
    "Karambit_Grim",         "Karambit_Hallows",     "Karambit_Jade Dream",
    "Karambit_Jester",       "Karambit_Lantern",     "Karambit_Liberty Camo",
    "Karambit_Marbleized",   "Karambit_Naval",       "Karambit_Neonic",
    "Karambit_Peppermint",   "Karambit_Pizza",       "Karambit_Quicktime",
    "Karambit_Racer",        "Karambit_Ruby",        "Karambit_Scapter",
    "Karambit_Splattered",   "Karambit_Stock",       "Karambit_Topaz",
    "Karambit_Tropical",     "Karambit_Twitch",      "Karambit_Wetland",
    "Karambit_Worn",

    -- Sickle
    "Sickle_Crimson",    "Sickle_Hallows",    "Sickle_Hieroglyphs","Sickle_Mummy",
    "Sickle_Psychadelic","Sickle_Reaper",     "Sickle_Splattered", "Sickle_Static",
    "Sickle_Stock",
    "Sickle Classic_Mummy","Sickle Classic_Splattered","Sickle Classic_Stock",

    -- Banana
    "Banana_Stock",

    -- M9 Bayonet
    "M9 Bayonet_Stock",

    -- Fingerless Glove
    "Fingerless Glove_Crystal",    "Fingerless Glove_Digital",
    "Fingerless Glove_Kimura",     "Fingerless Glove_Patch",
    "Fingerless Glove_Scapter",    "Fingerless Glove_Spookiness",

    -- Handwraps
    "Handwraps_Dark Damascus",  "Handwraps_Ghoul Hex",   "Handwraps_Green Hex",
    "Handwraps_Guts",           "Handwraps_MMA",         "Handwraps_Microbes",
    "Handwraps_Mummy",          "Handwraps_Orange Hex",  "Handwraps_Phantom Hex",
    "Handwraps_Purple Hex",     "Handwraps_Spector Hex", "Handwraps_Toxic Nitro",
    "Handwraps_Wetland",        "Handwraps_Wraps",       "Handwraps_Yellow Hazard",

    -- Sports Glove
    "Sports Glove_Blood Web",  "Sports Glove_Calamity",  "Sports Glove_CottonTail",
    "Sports Glove_Dark Damascus","Sports Glove_Dead Prey","Sports Glove_Hallows",
    "Sports Glove_Hazard",     "Sports Glove_Majesty",   "Sports Glove_Pumpkin",
    "Sports Glove_Royal",      "Sports Glove_RSL",       "Sports Glove_Skulls",
    "Sports Glove_Twitch",     "Sports Glove_Weeb",

    -- Strapped Glove
    "Strapped Glove_BloxersClub","Strapped Glove_Cob Web", "Strapped Glove_Drop-Out",
    "Strapped Glove_Grim",       "Strapped Glove_Kringle", "Strapped Glove_Molten",
    "Strapped Glove_Racer",      "Strapped Glove_Wisk",
}

-- Old skins

local ASSET_URL_FORMAT = "http://www.roblox.com/asset/?id=%d"

local LEGACY_ASSETS = {

    -- Weapon Skins

    ["Glock_White Sauce"] = {
        ["Handle2"]              = 12539294019,
        ["Mag3"]                 = 12539294019,
        ["Slide2"]               = 12539294019,
        ["WorldModel_Handle2"]   = 12539294019,
        ["WorldModel_Mag2"]      = 12539294019,
        ["WorldModel_Main"]      = 12539294019,
        ["WorldModel_Slide2"]    = 12539294019,
        ["WorldModel_meshtype"]  = 12539294019,
    },

    ["Glock_Scapter"] = {
        ["Handle2"]              = 12547951862,
        ["Mag3"]                 = 12547951862,
        ["Slide2"]               = 12547951862,
        ["WorldModel_Handle2"]   = 12547951862,
        ["WorldModel_Mag2"]      = 12547951862,
        ["WorldModel_Main"]      = 12547951862,
        ["WorldModel_Slide2"]    = 12547951862,
        ["WorldModel_meshtype"]  = 12547951862,
    },

    ["AK47_Scapter"] = {
        ["Handle"]               = 2214315787,
        ["Bolt"]                 = 2214315787,
        ["Mag"]                  = 2214315787,
        ["WorldModel_Bolt2"]     = 2214315787,
        ["WorldModel_Handle2"]   = 2214315787,
        ["WorldModel_Mag2"]      = 2214315787,
        ["WorldModel_Main"]      = 2214315787,
        ["WorldModel_meshtype"]  = 2214315787,
    },

    ["AWP_Scapter"] = {
        ["Barrel"]               = 2218460521,
        ["Handle"]               = 2218460521,
        ["Mag"]                  = 2218460521,
        ["Part"]                 = 2218460521,
        ["Slide"]                = 2218460521,
        ["Slide 2"]              = 2218460521,
        ["WorldModel_Bolt2"]     = 2218460521,
        ["WorldModel_Handle2"]   = 2218460521,
        ["WorldModel_Lever2"]    = 2218460521,
        ["WorldModel_Mag2"]      = 2218460521,
        ["WorldModel_Main"]      = 2218460521,
        ["WorldModel_Part2"]     = 2218460521,
        ["WorldModel_meshtype"]  = 2218460521,
    },

    ["Butterfly Knife_Scapter"] = {
        ["Butterfly_Blade"]      = 3220622680,
        ["Butterfly_LHandle"]    = 3220622680,
        ["Butterfly_RHandle"]    = 3220622680,
        ["WorldModel_Main"]      = 3220622680,
    },

    ["DesertEagle_ROLVe"] = {
        ["Handle"]               = 3180126057,
        ["Mag"]                  = 3180126057,
        ["Mag2"]                 = 3180126057,
        ["Slide"]                = 3180126057,
        ["WorldModel_Handle2"]   = 3180126057,
        ["WorldModel_Mag2"]      = 3180126057,
        ["WorldModel_Main"]      = 3180126057,
        ["WorldModel_Slide2"]    = 3180126057,
        ["WorldModel_meshtype"]  = 3180126057,
    },

    ["DesertEagle_Scapter"] = {
        ["Handle"]               = 2226675143,
        ["Mag"]                  = 2226675143,
        ["Mag2"]                 = 2226675143,
        ["Slide"]                = 2226675143,
        ["WorldModel_Handle2"]   = 2226675143,
        ["WorldModel_Mag2"]      = 2226675143,
        ["WorldModel_Main"]      = 2226675143,
        ["WorldModel_Slide2"]    = 2226675143,
        ["WorldModel_meshtype"]  = 2226675143,
    },

    ["FiveSeven_Mr. Anatomy"] = {
        ["Handle2"]              = 4204553743,
        ["Mag3"]                 = 4204553743,
        ["Slide2"]               = 4204553743,
        ["WorldModel_Handle2"]   = 4204553743,
        ["WorldModel_Mag2"]      = 4204553743,
        ["WorldModel_Slide2"]    = 4204553743,
        ["WorldModel_meshtype"]  = 4204553743,
    },

    ["Karambit_Scapter"] = {
        ["Handle"]                  = 90526455148882,
        ["WorldModel_Handle2"]      = 90526455148882,
        ["WorldModel_Handle2_mesh"] = 90526455148882,
    },

    ["Flip Knife_Stock"] = {
        ["Blade"]                = 2227416644,
        ["Handle"]               = 2227416644,
        ["WorldModel_Blade"]     = 2227416644,
        ["WorldModel_Handle2"]   = 2227416644,
        ["WorldModel_Main2"]     = 2227416644,
        ["WorldModel_meshtype"]  = 2227416644,
    },

    ["M4A4_Scapter"] = {
        ["Back"]                 = 12569981059,
        ["Barrel"]               = 12569981059,
        ["Bolt"]                 = 12569981059,
        ["Chamber"]              = 12569981059,
        ["Cover"]                = 12569981059,
        ["Handle"]               = 12569981059,
        ["Mag"]                  = 12569981059,
        ["Sight"]                = 12569981059,
        ["WorldModel_Bolt2"]     = 12569981059,
        ["WorldModel_Chamber"]   = 12569981059,
        ["WorldModel_Handle2"]   = 12569981059,
        ["WorldModel_Mag2"]      = 12569981059,
        ["WorldModel_Main"]      = 12569981059,
        ["WorldModel_Part"]      = 12569981059,
        ["WorldModel_meshtype"]  = 12569981059,
    },

    -- Glove Skins

    ["Fingerless Glove_Scapter"] = {
        __gloveSpecial = true,
        TextureId      = 2217790167,
        Type           = "Fingerless Glove",
    },

    ["Fingerless Glove_Blacura"] = {
        __gloveSpecial = true,
        TextureId = 104361826294745,
        Type = "Fingerless Glove",
    },
}

-- Config

local SAVE_PATH = "CounterBlox.json"

local function formatJson(value, depth)
    depth = depth or 0
    local indent      = string.rep("    ", depth)
    local innerIndent = string.rep("    ", depth + 1)

    if type(value) == "table" then
        local keys = {}
        for k in value do table.insert(keys, k) end
        table.sort(keys)
        if #keys == 0 then return "{}" end
        local lines = {}
        for _, k in keys do
            local encodedKey   = '"' .. tostring(k):gsub('"', '\\"') .. '"'
            local encodedValue = formatJson(value[k], depth + 1)
            table.insert(lines, innerIndent .. encodedKey .. ": " .. encodedValue)
        end
        return "{\n" .. table.concat(lines, ",\n") .. "\n" .. indent .. "}"
    elseif type(value) == "string" then
        return '"' .. value:gsub('\\', '\\\\'):gsub('"', '\\"') .. '"'
    elseif type(value) == "number" or type(value) == "boolean" then
        return tostring(value)
    else
        return "null"
    end
end

-- Game check

local function getDependencies()
    local RS = ReplicatedStorage
    local RF = ReplicatedFirst

    local eventsFolder = RS:FindFirstChild("Events")
    if not eventsFolder or not eventsFolder.Parent or not eventsFolder:IsA("Folder") then
        return nil, "ReplicatedStorage.Events [Folder]"
    end

    local ial = eventsFolder:FindFirstChild("InventoryAndLoadout")
    if not ial or not ial.Parent or not ial:IsA("RemoteEvent") then
        return nil, "ReplicatedStorage.Events.InventoryAndLoadout [RemoteEvent]"
    end

    local dataEvent = eventsFolder:FindFirstChild("DataEvent")
    if not dataEvent or not dataEvent.Parent or not dataEvent:IsA("RemoteEvent") then
        return nil, "ReplicatedStorage.Events.DataEvent [RemoteEvent]"
    end

    local SkinRoot = RS:FindFirstChild("Skins")
    if not SkinRoot or not SkinRoot.Parent or not SkinRoot:IsA("Folder") then
        return nil, "ReplicatedStorage.Skins [Folder]"
    end

    local weaponsFolder = RS:FindFirstChild("Weapons")
    if not weaponsFolder or not weaponsFolder.Parent or not weaponsFolder:IsA("Folder") then
        return nil, "ReplicatedStorage.Weapons [Folder]"
    end

    local modulesFolder = RS:FindFirstChild("Modules")
    local patchModule   = modulesFolder and modulesFolder:FindFirstChild("Patch")
    if not patchModule or not patchModule.Parent or not patchModule:IsA("ModuleScript") then
        return nil, "ReplicatedStorage.Modules.Patch [ModuleScript]"
    end

    local dataModule = RF:FindFirstChild("Data")
    if not dataModule or not dataModule.Parent or not dataModule:IsA("ModuleScript") then
        return nil, "ReplicatedFirst.Data [ModuleScript]"
    end

    return {
        eventsFolder  = eventsFolder,
        ial           = ial,
        dataEvent     = dataEvent,
        SkinRoot   = SkinRoot,
        weaponsFolder = weaponsFolder,
        patchModule   = patchModule,
        dataModule    = dataModule,
    }, nil
end

-- Game data

local LOAD_TIMEOUT = 15

local deps, failedDep = getDependencies()

local inventoryReady = false
if deps then
    local dataOk, dataModule = pcall(require, deps.dataModule)
    if dataOk and dataModule then
        local inventoryOk, inventory = pcall(function()
            return dataModule.GetData("Inventory")
        end)
        inventoryReady = inventoryOk and type(inventory) == "table"
    end
end

local alreadyLoaded = deps and inventoryReady

local GameData
local PatchApi
local eventsFolder
local LoadoutEvent
local dataEvent
local SkinRoot
local GloveRoot
local StatRemote

if not alreadyLoaded then
    local startTime = os.clock()
    local gateOk    = false

    while os.clock() - startTime < LOAD_TIMEOUT do
        deps, failedDep = getDependencies()

        if deps then
            local dataOk, dataModule = pcall(require, deps.dataModule)
            if dataOk and dataModule then
                local inventoryOk, inventory = pcall(function()
                    return dataModule.GetData("Inventory")
                end)
                if inventoryOk and type(inventory) == "table" then
                    local patchOk, patchModule = pcall(require, deps.patchModule)

                    GameData = dataModule
                    PatchApi = patchOk and patchModule or nil
                    eventsFolder = deps.eventsFolder
                    LoadoutEvent = deps.ial
                    dataEvent = deps.dataEvent
                    SkinRoot = deps.SkinRoot
                    GloveRoot = ReplicatedStorage:FindFirstChild("Gloves")
                    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
                    StatRemote          = remotesFolder and remotesFolder:FindFirstChild("Stat")

                    gateOk = true
                    break
                end
            end
        end

        task.wait(0.3)
    end

    if not gateOk then
        -- Diagnose exactly what failed
        local finalDeps, finalFail = getDependencies()
        warn("[Lenora] This version of Counter Blox is not compatible with Lenora.")
        if not finalDeps then
            warn("[Lenora] A required game object is missing or changed: " .. (finalFail or "unknown"))
            warn("[Lenora] Counter Blox may have changed its folders, remotes, modules, or inventory data.")
        else
            warn("[Lenora] A required game object is missing or changed: Data.GetData(\"Inventory\") [table]")
            warn("[Lenora] Counter Blox may have changed the inventory format.")
        end
        warn("[Lenora] Startup was cancelled before any hooks or loadout changes were made.")
        if rawget(Env, "__LenoraRuntimeToken") == RunId then
            Env.__LenoraRuntimeToken = nil
        end
        return  -- exit the script cleanly
    end
else
    local dataOk, dataModule = pcall(require, deps.dataModule)
    if not dataOk or not dataModule then
        warn("[Lenora] ReplicatedFirst.Data could not be opened.")
        warn("[Lenora] Startup was cancelled before any hooks or loadout changes were made.")
        if rawget(Env, "__LenoraRuntimeToken") == RunId then
            Env.__LenoraRuntimeToken = nil
        end
        return
    end
    local patchOk, patchModule = pcall(require, deps.patchModule)

    GameData = dataModule
    PatchApi = patchOk and patchModule or nil
    eventsFolder = deps.eventsFolder
    LoadoutEvent = deps.ial
    dataEvent = deps.dataEvent
    SkinRoot = deps.SkinRoot
    GloveRoot = ReplicatedStorage:FindFirstChild("Gloves")
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
    StatRemote          = remotesFolder and remotesFolder:FindFirstChild("Stat")

end

-- Runtime

local Unloaded = false
local removeCharacterGuard = nil
local removeSkinMapperHook = nil
local removeNamecallHook = nil
local Connections = {}

local function isCurrentRuntime()
    return not Unloaded and rawget(Env, "__LenoraRuntimeToken") == RunId
end

local function trackConnection(connection)
    if typeof(connection) == "RBXScriptConnection" then
        Connections[#Connections + 1] = connection
    end
    return connection
end

local function disconnectAll()
    for index = #Connections, 1, -1 do
        local connection = Connections[index]
        Connections[index] = nil
        if typeof(connection) == "RBXScriptConnection" then
            pcall(function() connection:Disconnect() end)
        end
    end
end

local function stopRuntime()
    if Unloaded then return end
    Unloaded = true

    if rawget(Env, "__LenoraRuntimeToken") == RunId then
        Env.__LenoraRuntimeToken = nil
    end

    pcall(function() ContextActionService:UnbindAction(STATTRAK_INPUT_ACTION) end)
    disconnectAll()

    if type(removeNamecallHook) == "function" then
        pcall(removeNamecallHook)
    end
    if type(removeCharacterGuard) == "function" then
        pcall(removeCharacterGuard)
    end
    if type(removeSkinMapperHook) == "function" then
        pcall(removeSkinMapperHook)
    end

    local dropRuntime = rawget(Env, "__LenoraDrops")
    if type(dropRuntime) == "table" and type(dropRuntime.stop) == "function" then
        pcall(dropRuntime.stop)
    end
end

Env.__LenoraStop = stopRuntime

local function dependencyChanged(desc)
    if Unloaded then return end
    stopRuntime()
    warn("[Lenora] A required game object changed while Lenora was running.")
    warn("[Lenora] Changed or missing object: " .. desc)
    warn("[Lenora] Lenora was disabled to avoid breaking the current loadout.")
end

local function watchDependency(instance, desc)
    trackConnection(instance.AncestryChanged:Connect(function()
        if not instance.Parent then
            dependencyChanged(desc)
        end
    end))
end

-- DataEvent can get replaced
local function getDataEvent(timeoutSeconds)
    local deadline = os.clock() + math.max(tonumber(timeoutSeconds) or 0, 0)

    repeat
        local events = ReplicatedStorage:FindFirstChild("Events")
        local current = events and events:FindFirstChild("DataEvent")
        if current and current:IsA("RemoteEvent") and current.Parent == events then
            eventsFolder = events
            dataEvent = current
            return current
        end

        if os.clock() >= deadline then
            break
        end
        task.wait()
    until Unloaded

    return nil
end

local function isCurrentDataEvent(instance)
    if typeof(instance) ~= "Instance" then
        return false
    end

    return instance == dataEvent
        or (instance.Parent == eventsFolder and instance.Name == "DataEvent")
end

trackConnection(eventsFolder.ChildRemoved:Connect(function(child)
    if child == dataEvent then
        dataEvent = nil
    end
end))

trackConnection(eventsFolder.ChildAdded:Connect(function(child)
    if child.Name == "DataEvent" and child:IsA("RemoteEvent") then
        dataEvent = child
    end
end))

watchDependency(eventsFolder,              "ReplicatedStorage.Events")
watchDependency(LoadoutEvent, "ReplicatedStorage.Events.InventoryAndLoadout")
watchDependency(SkinRoot,         "ReplicatedStorage.Skins")

-- State

local savePending = false
local CTItems   = {}
local TItems    = {}
local StatCounts  = {}
local StatOwners = {}
local NormalItems = {}
local StatVersions = {}

Env.__LenoraInventory = {
    hidden = false,
    hideQueued = false,
    visibilityVersion = 0,
    ready = false,
    serverItemIds = {},
    addedItemIds = {},
    protectedItemIds = {},
    protectedItemRecords = {},
    inventorySource = nil,
}

-- Data
local PatchDepth = {
    Inventory = 0,
    CTLoadout = 0,
    TLoadout = 0,
}

local patchApiChecked = false
local patchApiReady = false
local patchApiError = nil

local function deepCopy(value, seen)
    if type(value) ~= "table" then
        return value
    end

    seen = seen or {}
    if seen[value] then
        return seen[value]
    end

    local copy = {}
    seen[value] = copy
    for key, child in pairs(value) do
        copy[deepCopy(key, seen)] = deepCopy(child, seen)
    end
    return copy
end

local function tablesMatch(left, right)
    if type(PatchApi) ~= "table" or type(PatchApi.diff) ~= "function" then
        return false
    end

    local ok, difference = pcall(PatchApi.diff, left, right)
    return ok and difference == nil
end

local function checkPatch()
    if patchApiChecked then
        return patchApiReady
    end
    patchApiChecked = true

    if type(PatchApi) ~= "table"
        or type(PatchApi.diff) ~= "function"
        or type(PatchApi.apply) ~= "function" then
        patchApiError = "ReplicatedStorage.Modules.Patch is missing diff/apply"
        return false
    end

    local before = {
        [1] = {
            [1] = "Lenora_PatchProtocolTest",
            [2] = "StatTrak",
            [3] = 12345,
            [4] = 77,
        },
        Marker = true,
    }
    local desired = {
        [1] = { [1] = "Lenora_PatchProtocolTest" },
        Marker = false,
    }

    local okDiff, difference = pcall(PatchApi.diff, before, desired)
    if not okDiff or difference == nil then
        patchApiError = "Patch.diff could not encode nested field deletion"
        return false
    end

    local okApply, applied = pcall(PatchApi.apply, deepCopy(before), difference)
    if not okApply or type(applied) ~= "table" or not tablesMatch(applied, desired) then
        patchApiError = "Patch.apply did not reconstruct the requested table"
        return false
    end

    patchApiReady = true
    return true
end

local function applyPatch(label, current, desired)
    if Unloaded then return false, false end
    if label ~= "Inventory" and label ~= "CTLoadout" and label ~= "TLoadout" then
        return false, false
    end
    if type(current) ~= "table" or type(desired) ~= "table" then
        return false, false
    end
    if not checkPatch() then
        warn("[Lenora] The game data patch check failed: "
            .. tostring(patchApiError or "unknown"))
        return false, false
    end

    local okDiff, difference = pcall(PatchApi.diff, current, desired)
    if not okDiff then
        warn("[Lenora] Could not compare the current " .. label .. ": " .. tostring(difference))
        return false, false
    end
    if difference == nil then
        return true, false
    end
    if type(difference) ~= "table" then
        warn("[Lenora] The game returned an invalid " .. label .. " patch")
        return false, false
    end

    PatchDepth[label] = (PatchDepth[label] or 0) + 1
    local okEmit, emitError = pcall(function()
        firesignal(LoadoutEvent.OnClientEvent, label, difference)
    end)
    PatchDepth[label] -= 1

    if not okEmit then
        warn("[Lenora] Could not apply the " .. label .. " update: " .. tostring(emitError))
        return false, false
    end

    local live = GameData and GameData.GetData and GameData.GetData(label)
    if type(live) ~= "table" or not tablesMatch(live, desired) then
        warn("[Lenora] The " .. label .. " update did not reach the game data table.")
        return false, true
    end

    return true, true
end

local function editData(label, mutator)
    if Unloaded or type(mutator) ~= "function" then
        return false, false
    end

    local current = GameData and GameData.GetData and GameData.GetData(label)
    if type(current) ~= "table" then
        return false, false
    end

    local desired = deepCopy(current)
    local okMutate, mutateError = pcall(mutator, desired, current)
    if not okMutate then
        warn("[Lenora] Could not edit " .. label .. ": " .. tostring(mutateError))
        return false, false
    end

    return applyPatch(label, current, desired)
end

local function refreshInventoryView()
end

local function packItem(record)
    if type(record) ~= "table" or type(record[1]) ~= "string" or record[1] == "" then
        return nil
    end

    local out = { id = record[1] }
    if record[2] == "StatTrak" then
        out.statTrak = true
        out.owner = record[3]
        out.count = math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
    end
    return out
end

local function unpackItem(value)
    if type(value) == "string" then
        return { value }
    end
    if type(value) ~= "table" or type(value.id) ~= "string" or value.id == "" then
        return nil
    end
    if value.statTrak then
        return {
            [1] = value.id,
            [2] = "StatTrak",
            [3] = value.owner,
            [4] = math.clamp(math.floor(tonumber(value.count) or 0), 0, 999999),
        }
    end
    return { value.id }
end

local function saveConfig()
    if not isCurrentRuntime() or savePending then return end
    savePending = true
    local saveToken = RunId
    task.delay(0.1, function()
        savePending = false
        if Unloaded
            or rawget(Env, "__LenoraRuntimeToken") ~= saveToken then
            return
        end
        local data = { CT = {}, T = {}, StatTrak = {} }

        for slot, item in CTItems do
            local serialized = packItem(item)
            if serialized then data.CT[slot] = serialized end
        end
        for slot, item in TItems do
            local serialized = packItem(item)
            if serialized then data.T[slot] = serialized end
        end
        for itemId, count in StatCounts do
            data.StatTrak[itemId] = {
                owner = StatOwners[itemId],
                count = math.clamp(math.floor(tonumber(count) or 0), 0, 999999),
            }
        end

        pcall(writefile, SAVE_PATH, formatJson(data))
    end)
end

-- Skin assets

local legacyAssetsBuilt = false
local buildingLegacyAssets     = false
local skinDonors         = nil

local function getOrCreate(parent, className, name)
    local child = parent:FindFirstChild(name)
    if child and child.ClassName ~= className then
        child:Destroy()
        child = nil
    end
    if not child then
        child = Instance.new(className)
        child.Name = name
        child.Parent = parent
    end
    return child
end

local function copyVisuals(source, target)
    if source:IsA("StringValue") and target:IsA("StringValue") then
        if target.Value == "" and source.Value ~= "" then target.Value = source.Value end
    elseif source:IsA("ObjectValue") and target:IsA("ObjectValue") then
        if target.Value == nil and source.Value ~= nil then target.Value = source.Value end
    elseif source:IsA("NumberValue") and target:IsA("NumberValue") then
        if target.Value == 0 and source.Value ~= 0 then target.Value = source.Value end
    elseif source:IsA("IntValue") and target:IsA("IntValue") then
        if target.Value == 0 and source.Value ~= 0 then target.Value = source.Value end
    elseif source:IsA("SpecialMesh") and target:IsA("SpecialMesh") then
        if target.MeshId == "" and source.MeshId ~= "" then target.MeshId = source.MeshId end
        if target.TextureId == "" and source.TextureId ~= "" then target.TextureId = source.TextureId end
        if target.Scale == Vector3.new(1, 1, 1) and source.Scale ~= Vector3.new(1, 1, 1) then target.Scale = source.Scale end
        if target.Offset == Vector3.zero and source.Offset ~= Vector3.zero then target.Offset = source.Offset end
    elseif source:IsA("MeshPart") and target:IsA("MeshPart") then
        pcall(function() if target.TextureID == "" and source.TextureID ~= "" then target.TextureID = source.TextureID end end)
        pcall(function() if target.MeshId == "" and source.MeshId ~= "" then target.MeshId = source.MeshId end end)
        if target.Transparency == 0 and source.Transparency ~= 0 then target.Transparency = source.Transparency end
    elseif (source:IsA("Texture") or source:IsA("Decal")) and source.ClassName == target.ClassName then
        if target.Texture == "" and source.Texture ~= "" then target.Texture = source.Texture end
        if target.Transparency == 0 and source.Transparency ~= 0 then target.Transparency = source.Transparency end
    elseif source:IsA("SurfaceAppearance") and target:IsA("SurfaceAppearance") then
        for _, property in ipairs({ "ColorMap", "NormalMap", "RoughnessMap", "MetalnessMap", "TexturePack" }) do
            pcall(function()
                if tostring(target[property]) == "" and tostring(source[property]) ~= "" then
                    target[property] = source[property]
                end
            end)
        end
        pcall(function() target.AlphaMode = source.AlphaMode end)
        pcall(function() target.Color = source.Color end)
        pcall(function() target.EmissiveStrength = source.EmissiveStrength end)
        pcall(function() target.EmissiveTint = source.EmissiveTint end)
    end
end

local function mergeChildren(source, target)
    if not source or not target or source == target then return end
    copyVisuals(source, target)

    for _, child in ipairs(source:GetChildren()) do
        if child:IsA("Script") or child:IsA("LocalScript")
        or child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            continue
        end

        local existing = target:FindFirstChild(child.Name)
        if not existing or existing.ClassName ~= child.ClassName then
            if existing then existing:Destroy() end
            local ok, clone = pcall(function() return child:Clone() end)
            if ok and clone then clone.Parent = target end
        else
            mergeChildren(child, existing)
        end
    end
end

local function getSkinDonors()
    if skinDonors then return skinDonors end
    skinDonors = {}

    local roots = {
        ReplicatedStorage:FindFirstChild("LegacySkins"),
        ReplicatedStorage:FindFirstChild("OldSkins"),
        ReplicatedStorage:FindFirstChild("OLD_Skins"),
        ReplicatedStorage:FindFirstChild("SkinArchive"),
        ReplicatedStorage:FindFirstChild("SkinsArchive"),
        ReplicatedStorage:FindFirstChild("Knives"),
    }

    local function indexRoot(root)
        if not root then return end
        for _, typeFolder in ipairs(root:GetChildren()) do
            if typeFolder:IsA("Folder") or typeFolder:IsA("Model") then
                for _, skinFolder in ipairs(typeFolder:GetChildren()) do
                    if skinFolder:IsA("Folder") or skinFolder:IsA("Model") then
                        skinDonors[typeFolder.Name .. "_" .. skinFolder.Name] =
                            skinDonors[typeFolder.Name .. "_" .. skinFolder.Name] or skinFolder
                    end
                end
            end
        end
    end

    for _, root in ipairs(roots) do indexRoot(root) end

    if type(getnilinstances) == "function" then
        local ok, nilInstances = pcall(getnilinstances)
        if ok and type(nilInstances) == "table" then
            for _, instance in ipairs(nilInstances) do
                local parent = instance and instance.Parent
                if instance and parent and (instance:IsA("Folder") or instance:IsA("Model")) then
                    skinDonors[parent.Name .. "_" .. instance.Name] =
                        skinDonors[parent.Name .. "_" .. instance.Name] or instance
                end
            end
        end
    end

    return skinDonors
end

local function splitCatalogItem(itemId)
    local separator = tostring(itemId or ""):find("_", 1, true)
    if not separator then return tostring(itemId or ""), "" end
    return itemId:sub(1, separator - 1), itemId:sub(separator + 1)
end

local function ensureSkin(itemId)
    local weaponName, skinName = splitCatalogItem(itemId)
    if weaponName == "" or skinName == "" then return nil end

    local isGlove = GLOVE_NAME_SET[weaponName] == true
    local rootFolder = isGlove and GloveRoot or SkinRoot
    if not rootFolder then return nil end

    local typeFolder = rootFolder:FindFirstChild(weaponName)
    if not typeFolder then
        typeFolder = Instance.new("Folder")
        typeFolder.Name = weaponName
        typeFolder.Parent = rootFolder
    end

    local skinFolder = typeFolder:FindFirstChild(skinName)
    if not skinFolder then
        skinFolder = Instance.new("Folder")
        skinFolder.Name = skinName
        skinFolder.Parent = typeFolder
    end

    local donor = getSkinDonors()[itemId]
    if donor and donor ~= skinFolder then
        mergeChildren(donor, skinFolder)
    end

    return skinFolder, isGlove, weaponName
end

local function addLegacySkin(itemId, parts)
    local skinFolder, isGlove, weaponName = ensureSkin(itemId)
    if not skinFolder then return end

    if parts.__gloveSpecial then
        local mesh = getOrCreate(skinFolder, "SpecialMesh", "Textures")
        if mesh.TextureId == "" then
            mesh.TextureId = string.format(ASSET_URL_FORMAT, tonumber(parts.TextureId) or 0)
        end

        local typeValue = getOrCreate(skinFolder, "StringValue", "Type")
        if typeValue.Value == "" then typeValue.Value = tostring(parts.Type or weaponName) end
        return
    end

    local worldModel = nil
    if not isGlove then
        worldModel = getOrCreate(skinFolder, "Folder", "WorldModel")
    end

    for partName, assetId in pairs(parts) do
        if partName == "__gloveSpecial" or partName == "TextureId" or partName == "Type" then
            continue
        end

        local meshField = partName:sub(-5) == "_mesh"
        local realName = meshField and partName:sub(1, -6) or partName
        local parent = skinFolder

        if worldModel and realName:sub(1, 11) == "WorldModel_" then
            realName = realName:sub(12)
            parent = worldModel
        end

        local value = getOrCreate(parent, "StringValue", realName)
        if value.Value == "" then
            value.Value = string.format(ASSET_URL_FORMAT, tonumber(assetId) or 0)
        end

        if meshField then
            local meshType = getOrCreate(value, "StringValue", "meshtype")
            if meshType.Value == "" then
                meshType.Value = string.format(ASSET_URL_FORMAT, tonumber(assetId) or 0)
            end
        end
    end

    local donor = getSkinDonors()[itemId]
    if donor and donor ~= skinFolder then mergeChildren(donor, skinFolder) end
end

local function buildLegacySkins()
    if legacyAssetsBuilt then return end
    legacyAssetsBuilt = true
    buildingLegacyAssets = true

    getSkinDonors()

    for _, itemId in ipairs(BACKUP_SKIN_CATALOG) do
        ensureSkin(itemId)
    end

    for itemId, parts in pairs(LEGACY_ASSETS) do
        addLegacySkin(itemId, parts)
    end

    buildingLegacyAssets = false
end

-- Item helpers

local function getLoadoutSlot(itemId)
    for _, name in KNIFE_TYPES do
        if itemId:sub(1, #name) == name then return "Knife" end
    end
    for _, name in GLOVE_TYPES do
        if itemId:sub(1, #name) == name then return "Glove" end
    end
    return string.split(itemId, "_")[1]
end

-- Weapon flags

local function getOverrideFlags(slot, base)
    local t = base or slot

    if t == "USP" or t == "P2000" then return {} end

    if slot == "M4A1"      then return { M4A1Over  = true  } end
    if slot == "M4A4"      then return { M4A1Over  = false } end
    if slot == "MP7-SD"    then return { MP7SDOver = true  } end
    if slot == "MP7"       then return { MP7SDOver = false } end
    if t == "CZ"           then return { CZOver    = true  } end
    if t == "FiveSeven"    then return { CZOver    = false } end
    if t == "Tec9"         then return { CZOver    = false } end
    if t == "R8"           then return { R8Over    = true  } end
    if t == "DesertEagle"  then return { R8Over    = false } end
    if slot == "Knife"     then return { KnifeOver = true  } end
    if slot == "Glove"     then return { GloveOver = true  } end
    if slot == "CTKnife" or slot == "TKnife" then return { KnifeOver = false } end
    if slot == "CTGlove" or slot == "TGlove" then return { GloveOver = false } end
    return {}
end

-- Inventory

local function getOwnedItems(current)
    local owned = {}
    if type(current) ~= "table" then return owned end
    for _, item in current do
        if type(item) == "table" and item[1] then owned[item[1]] = true end
    end
    return owned
end

-- Knives

local function getItemId(record)
    return type(record) == "table" and tostring(record[1] or "") or tostring(record or "")
end

local function copyItem(record)
    local out = {}
    if type(record) == "table" then
        for key, value in pairs(record) do
            out[key] = value
        end
    end
    return out
end

local function sameItem(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end
    return tostring(a[1] or "") == tostring(b[1] or "")
        and a[2] == b[2]
        and a[3] == b[3]
        and tonumber(a[4]) == tonumber(b[4])
end

local function hasStatTrak(record)
    return type(record) == "table" and record[2] == "StatTrak"
end

local function cleanItem(record)
    local id = getItemId(record)
    if id == "" then
        return { "" }
    end

    if hasStatTrak(record) then
        return {
            [1] = id,
            [2] = "StatTrak",
            [3] = record[3],
            [4] = math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999),
        }
    end

    return { id }
end

local function getItemBase(itemId)
    return string.split(tostring(itemId or ""), "_")[1]
end

local function isStockTeamKnife(itemId)
    itemId = tostring(itemId or "")
    return itemId == "CTKnife_Stock" or itemId == "TKnife_Stock"
end

local function isKnifeItem(itemId)
    itemId = tostring(itemId or "")
    if isStockTeamKnife(itemId) then
        return true
    end
    return KNIFE_NAME_SET[getItemBase(itemId)] == true
end

local function normalizeSlot(slot, itemId)
    slot = tostring(slot or "")
    if slot == "CTKnife" or slot == "TKnife" or isKnifeItem(itemId) then
        return "Knife"
    end
    if slot == "CTGlove" or slot == "TGlove" then
        return "Glove"
    end
    return slot
end

local function getTeams(side)
    return side == "CT" or side == "Both", side == "T" or side == "Both"
end

-- USP / P2000

local countWatchers = setmetatable({}, { __mode = "k" })
local countWatcherItems = setmetatable({}, { __mode = "k" })
local countWatcherLastValues = setmetatable({}, { __mode = "k" })
local localCountWriteTargets = setmetatable({}, { __mode = "k" })
local lastObservedNativeCount = {}
local pendingStatTrakKills = {}
local nativeCountCredits = {}
local processedKillEvents = {}
local recordNativeKillIncrease
local skinMapper = nil
local mapSkinFunction = nil
local originalMapSkin = nil
local wrappedMapSkin = nil
local mapWorldModelFunction = nil
local lastMapperSearch = 0
local skinMapperHooked = false
local skinMapperWarningShown = false
local weaponRefreshGeneration = 0
local skinAnimationState = setmetatable({}, { __mode = "k" })
local counterSyncQueued = {}
local fixStatTrakItem

local function splitItemId(itemId)
    local separator = tostring(itemId or ""):find("_", 1, true)
    if not separator then return tostring(itemId or ""), "" end
    return itemId:sub(1, separator - 1), itemId:sub(separator + 1)
end

local function getTeamSkinFolder(team)
    local skinRoot = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("SkinFolder")
    return skinRoot and skinRoot:FindFirstChild(team .. "Folder")
end

local function getTeamSkinValue(team, slot, createMissing)
    local teamFolder = getTeamSkinFolder(team)
    if not teamFolder then return nil end

    local value = teamFolder:FindFirstChild(slot)
    if value and not value:IsA("ValueBase") then
        if not createMissing then return nil end
        value:Destroy()
        value = nil
    end

    if not value and createMissing then
        value = Instance.new("StringValue")
        value.Name = slot
        value.Parent = teamFolder
    end

    return value
end

local function getEquippedRecord(team, slot)
    local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
    if type(loadout) ~= "table" then return nil end
    return loadout[slot]
end

-- Viewmodel

Env.__LenoraCanApplyStatTrak = function()
    if Unloaded then return false end

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return false end

    local status = LocalPlayer:FindFirstChild("Status")
    local aliveValue = status and status:FindFirstChild("Alive")
    if aliveValue and aliveValue:IsA("BoolValue") and aliveValue.Value == false then
        return false
    end

    local teamValue = status and status:FindFirstChild("Team")
    if teamValue and tostring(teamValue.Value or "") == "Spectator" then
        return false
    end

    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local gui = playerGui and playerGui:FindFirstChild("GUI")
    local spectate = gui and gui:FindFirstChild("Spectate")
    if spectate and spectate:IsA("GuiObject") and spectate.Visible == true then
        return false
    end

    local camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    local subject = camera and camera.CameraSubject
    if subject then
        local subjectCharacter = nil
        if subject:IsA("Humanoid") then
            subjectCharacter = subject.Parent
        elseif subject:IsA("BasePart") then
            subjectCharacter = subject:FindFirstAncestorOfClass("Model")
        elseif subject:IsA("Model") then
            subjectCharacter = subject
        end

        local watchedPlayer = subjectCharacter
            and Players:GetPlayerFromCharacter(subjectCharacter)
        if watchedPlayer and watchedPlayer ~= LocalPlayer then
            return false
        end
    end

    if aliveValue and aliveValue:IsA("BoolValue") then
        return aliveValue.Value == true
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.Health > 0
end

local function updateWeaponCounter(model, count, itemId)
    if not model then return end

    local camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    local cameraArms = camera and camera:FindFirstChild("Arms")
    if cameraArms
        and (model == cameraArms or model:IsDescendantOf(cameraArms))
        and not Env.__LenoraCanApplyStatTrak() then
        return
    end
    local hiddenByNativeRule = itemId == "P2000_Spirit Box" or itemId == "Tec9_Whispers"
    local enabled = count ~= nil and not hiddenByNativeRule

    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant.Name == "StatClock" then
            local surface = descendant:FindFirstChildOfClass("SurfaceGui")
            if surface then
                surface.Enabled = enabled
                local label = surface:FindFirstChildWhichIsA("TextLabel", true)
                if label and enabled then
                    label.Text = string.format("%06i", math.clamp(math.floor(tonumber(count) or 0), 0, 999999))
                end
            end
        end
    end
end

local function getCurrentViewmodel()
    if not Env.__LenoraCanApplyStatTrak() then
        return nil
    end

    local camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
    return camera and camera:FindFirstChild("Arms")
end

local function getHeldWeaponName()
    local arms = getCurrentViewmodel()
    local value = arms and arms:FindFirstChild("toolname")
    return value and value:IsA("StringValue") and tostring(value.Value or "") or ""
end

local function getCurrentTeam()
    local status = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("Status")
    local teamValue = status and status:FindFirstChild("Team")
    local value = teamValue and tostring(teamValue.Value or "") or ""
    if value == "CT" or value == "T" then return value end

    local team = Players.LocalPlayer and Players.LocalPlayer.Team
    local name = team and tostring(team.Name or "") or ""
    local upper = name:upper()
    if upper == "CT" or upper:find("COUNTER", 1, true) or upper:find("CT", 1, true) then return "CT" end
    if upper == "T" or upper:find("TERROR", 1, true) then return "T" end
    return nil
end

local function getHeldItemRecord()
    local team = getCurrentTeam()
    local tool = getHeldWeaponName()
    if not team or tool == "" then return nil, nil, nil end

    local slot = isKnifeItem(tool) and "Knife" or normalizeSlot(getLoadoutSlot(tool .. "_Stock"), tool)
    local record = getEquippedRecord(team, slot)
    if type(record) ~= "table" or not record[1] then
        local loadout = GameData.GetData(team .. "Loadout")
        if type(loadout) == "table" then
            for candidateSlot, candidate in pairs(loadout) do
                if type(candidate) == "table" and candidate[1] then
                    local base = getItemBase(candidate[1])
                    if base == tool or (isKnifeItem(candidate[1]) and isKnifeItem(tool)) then
                        return candidate, team, normalizeSlot(candidateSlot, candidate[1])
                    end
                end
            end
        end
        return nil, team, slot
    end
    return record, team, slot
end

-- Skin mapper
local MAPPER_NAME_ALIASES = {
    ["glock18"] = "glock",
    ["usps"] = "usp",
    ["m4a1s"] = "m4a1",
    ["cz75auto"] = "cz",
    ["r8revolver"] = "r8",
    ["44magnum"] = "r8",
    ["sg553"] = "sg",
    ["ssg08"] = "scout",
    ["galilar"] = "galil",
    ["tec9"] = "tec9",
    ["fiveseven"] = "fiveseven",
    ["deserteagle"] = "deserteagle",
    ["dualberettas"] = "dualberettas",
    ["sawedoff"] = "sawedoff",
    ["mac10"] = "mac10",
    ["mp7sd"] = "mp7sd",
}

local function normalizeMapperWeapon(value)
    local token = tostring(value or ""):lower():gsub("[^%w]", "")
    return MAPPER_NAME_ALIASES[token] or token
end

local function getMapperSkinName(value)
    if typeof(value) == "Instance" then
        return tostring(value.Name or "")
    end
    return tostring(value or "")
end

local function getTrackedKillCount(itemId, preferredRecord)
    itemId = tostring(itemId or "")
    if itemId == "" then return nil end

    local best = nil
    local function include(value)
        local number = tonumber(value)
        if number == nil then return end
        number = math.clamp(math.floor(number), 0, 999999)
        best = best == nil and number or math.max(best, number)
    end

    include(StatCounts[itemId])
    if hasStatTrak(preferredRecord) and getItemId(preferredRecord) == itemId then
        include(preferredRecord[4])
    end

    local inventory = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(inventory) == "table" then
        for _, record in pairs(inventory) do
            if hasStatTrak(record) and getItemId(record) == itemId then
                include(record[4])
            end
        end
    end

    for _, team in ipairs({ "CT", "T" }) do
        local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
        if type(loadout) == "table" then
            for _, record in pairs(loadout) do
                if hasStatTrak(record) and getItemId(record) == itemId then
                    include(record[4])
                end
            end
        end
    end

    for _, desired in ipairs({ CTItems, TItems }) do
        for _, record in pairs(desired) do
            if hasStatTrak(record) and getItemId(record) == itemId then
                include(record[4])
            end
        end
    end

    return best
end

local function getMappedLoadoutRecord(model, skinArgument)
    if typeof(model) ~= "Instance" then return nil end
    if not Env.__LenoraCanApplyStatTrak() then
        return nil
    end

    local team = getCurrentTeam()
    if team ~= "CT" and team ~= "T" then return nil end

    local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
    if type(loadout) ~= "table" then return nil end

    local modelName = tostring(model.Name or "")
    if modelName == "Arms" then
        modelName = getHeldWeaponName()
    end
    local modelToken = normalizeMapperWeapon(modelName)
    if modelToken == "" then return nil end

    local dropRuntime = rawget(
        Env,
        "__LenoraDrops"
    )
    if type(dropRuntime) == "table"
        and type(dropRuntime.foreignHeldWeaponNames) == "table" then
        for foreignWeaponName in pairs(dropRuntime.foreignHeldWeaponNames) do
            if normalizeMapperWeapon(foreignWeaponName) == modelToken then
                return nil
            end
        end
    end

    local requestedSkin = getMapperSkinName(skinArgument)
    local matchRecord = nil
    local matchSlot = nil

    for rawSlot, record in pairs(loadout) do
        if type(record) == "table" and type(record[1]) == "string" and record[1] ~= "" then
            local itemId = getItemId(record)
            local base, skinName = splitItemId(itemId)
            if not GLOVE_NAME_SET[base] then
                local mappedBase = KNIFE_MODEL_REMAP[base] or base
                local baseMatches = normalizeMapperWeapon(mappedBase) == modelToken
                local skinMatches = requestedSkin == "" or tostring(skinName) == requestedSkin

                if baseMatches and skinMatches then
                    if matchRecord ~= nil and getItemId(matchRecord) ~= itemId then
                        return nil
                    end
                    matchRecord = record
                    matchSlot = normalizeSlot(rawSlot, itemId)
                end
            end
        end
    end

    return matchRecord, team, matchSlot
end

local function getCorrectedStatTrakCount(model, skinArgument, nativeCount)
    local record, team, slot = getMappedLoadoutRecord(model, skinArgument)
    if type(record) ~= "table" or not record[1] then
        return false, nativeCount, nil, team, slot
    end

    local itemId = getItemId(record)
    if not hasStatTrak(record) or NormalItems[itemId] == true then
        return true, nil, record, team, slot
    end

    local maintained = getTrackedKillCount(itemId, record)
    if maintained == nil then
        maintained = math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
    end

    return true, maintained, record, team, slot
end

local function hookNativeSkinMapper(mapper)
    if type(mapper) ~= "table" or type(mapper.MapSkin) ~= "function" then
        return false
    end

    local active = rawget(Env, "__LenoraSkinMapper")
    if type(active) == "table" and active.owner == mapper then
        if mapper.MapSkin == active.wrapper and active.wrapper == mapSkinFunction then
            originalMapSkin = active.original
            skinMapperHooked = true
            return true
        end
        if mapper.MapSkin == active.wrapper and type(active.original) == "function" then
            pcall(function() mapper.MapSkin = active.original end)
        end
        Env.__LenoraSkinMapper = nil
    end

    local original = mapper.MapSkin
    if type(original) ~= "function" then return false end

    local token = {}
    local wrapper
    wrapper = function(model, skinArgument, nativeCount, ...)
        if not Env.__LenoraCanApplyStatTrak() then
            return original(model, skinArgument, nativeCount, ...)
        end

        local matched, correctedCount, record =
            getCorrectedStatTrakCount(model, skinArgument, nativeCount)

        local results = table.pack(original(model, skinArgument, correctedCount, ...))

        if Env.__LenoraCanApplyStatTrak()
            and matched
            and typeof(model) == "Instance"
            and type(record) == "table" then
            updateWeaponCounter(model, correctedCount, getItemId(record))
        end

        return table.unpack(results, 1, results.n)
    end

    local installed = pcall(function()
        mapper.MapSkin = wrapper
    end)
    if not installed or mapper.MapSkin ~= wrapper then
        return false
    end

    originalMapSkin = original
    wrappedMapSkin = wrapper
    skinMapperHooked = true
    Env.__LenoraSkinMapper = {
        token = token,
        owner = mapper,
        original = original,
        wrapper = wrapper,
    }

    removeSkinMapperHook = function()
        local current = rawget(Env, "__LenoraSkinMapper")
        if type(current) == "table" and current.token == token then
            if current.owner and current.owner.MapSkin == current.wrapper then
                pcall(function() current.owner.MapSkin = current.original end)
            end
            Env.__LenoraSkinMapper = nil
        end
        skinMapperHooked = false
    end

    return true
end

local function findNativeSkinMapper(force)
    if mapSkinFunction and not force then return mapSkinFunction, mapWorldModelFunction, skinMapper end
    if not force and os.clock() - lastMapperSearch < 1 then
        return mapSkinFunction, mapWorldModelFunction, skinMapper
    end
    lastMapperSearch = os.clock()

    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, object in ipairs(objects) do
                if type(object) == "function" then
                    local functionName = nil
                    pcall(function()
                        if debug and debug.info then functionName = debug.info(object, "n") end
                    end)
                    if functionName == "usethatgun" and type(getupvalues) == "function" then
                        local upOk, upvalues = pcall(getupvalues, object)
                        if upOk and type(upvalues) == "table" then
                            for _, value in pairs(upvalues) do
                                if type(value) == "table" and type(value.MapSkin) == "function" then
                                    skinMapper = value
                                    hookNativeSkinMapper(value)
                                    mapSkinFunction = value.MapSkin
                                    mapWorldModelFunction = type(value.MapWorldModel) == "function" and value.MapWorldModel or nil
                                    return mapSkinFunction, mapWorldModelFunction, skinMapper
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for _, module in ipairs(ReplicatedStorage:GetDescendants()) do
        if module:IsA("ModuleScript") and (module.Name == "GetAndMap" or module.Name == "SkinMapper") then
            local ok, result = pcall(require, module)
            if ok and type(result) == "function" then
                mapSkinFunction = result
                skinMapper = nil
                return mapSkinFunction, nil, nil
            elseif ok and type(result) == "table" and type(result.MapSkin) == "function" then
                skinMapper = result
                hookNativeSkinMapper(result)
                mapSkinFunction = result.MapSkin
                mapWorldModelFunction = type(result.MapWorldModel) == "function" and result.MapWorldModel or nil
                return mapSkinFunction, mapWorldModelFunction, skinMapper
            end
        end
    end

    return nil, nil, nil
end

local function getSkinAssetFolder(record)
    local itemId = getItemId(record)
    local base, skin = splitItemId(itemId)
    local root = GLOVE_NAME_SET[base] and GloveRoot or SkinRoot
    local weaponFolder = root and root:FindFirstChild(base)
    return weaponFolder and weaponFolder:FindFirstChild(skin)
end

local function copyVisualNode(source, target)
    if not source or not target then return end

    if source:IsA("StringValue") and source.Name ~= "meshtype" then
        local value = tostring(source.Value or "")
        if target:IsA("MeshPart") then pcall(function() target.TextureID = value end) end
        local mesh = target:FindFirstChildOfClass("SpecialMesh")
        if mesh then pcall(function() mesh.TextureId = value end) end
        if target:IsA("Texture") or target:IsA("Decal") then pcall(function() target.Texture = value end) end

        local sourceAppearance = source:FindFirstChildOfClass("SurfaceAppearance")
        if sourceAppearance and target:IsA("BasePart") then
            local old = target:FindFirstChildOfClass("SurfaceAppearance")
            if old then old:Destroy() end
            sourceAppearance:Clone().Parent = target
        end

        local transparency = source:FindFirstChild("Transparency")
        if transparency
            and transparency:IsA("ValueBase")
            and target:IsA("BasePart")
            and target.Name ~= "Silencer2" then
            pcall(function() target.Transparency = tonumber(transparency.Value) or target.Transparency end)
        end
    elseif source:IsA("BasePart") and target:IsA("BasePart") then
        if target.Name ~= "Silencer2" then
            target.Transparency = source.Transparency
        end
        if source:IsA("MeshPart") and target:IsA("MeshPart") then
            pcall(function() target.TextureID = source.TextureID end)
        end
        local sourceAppearance = source:FindFirstChildOfClass("SurfaceAppearance")
        if sourceAppearance then
            local old = target:FindFirstChildOfClass("SurfaceAppearance")
            if old then old:Destroy() end
            sourceAppearance:Clone().Parent = target
        end
    end
end

local function normalizeAnimatedFrame(value)
    if type(value) == "number" then
        return "rbxassetid://" .. tostring(math.floor(value))
    end
    if type(value) ~= "string" or value == "" then return nil end
    if value:match("^%d+$") then return "rbxassetid://" .. value end
    return value
end

local function isVisibleWeaponPart(part)
    if not part:IsA("BasePart") then return false end
    local lower = part.Name:lower()
    return lower ~= "humanoidrootpart"
        and not lower:find("arm", 1, true)
        and not lower:find("glove", 1, true)
        and lower ~= "statclock"
end

local function copySurfaceAppearance(target, appearance)
    if not target or not target:IsA("BasePart") or not appearance then return end
    local old = target:FindFirstChildOfClass("SurfaceAppearance")
    if old then old:Destroy() end
    local clone = appearance:Clone()
    clone.Name = "SurfaceAppearance"
    clone.Parent = target
end

local function applyTextureSkinFrame(model, asset)
    asset = normalizeAnimatedFrame(asset)
    if not asset then return end
    for _, target in ipairs(model:GetDescendants()) do
        if target:IsA("MeshPart") and isVisibleWeaponPart(target) then
            pcall(function() target.TextureID = asset end)
        elseif target:IsA("SpecialMesh") and target.Parent and isVisibleWeaponPart(target.Parent) then
            pcall(function() target.TextureId = asset end)
        elseif target:IsA("Texture") or target:IsA("Decal") then
            local parent = target.Parent
            if parent and isVisibleWeaponPart(parent) then
                pcall(function() target.Texture = asset end)
            end
        end
    end
end

local function applyPbrFrame(model, frame)
    if not frame or not model then return end

    if frame:IsA("SurfaceAppearance") then
        for _, target in ipairs(model:GetDescendants()) do
            if isVisibleWeaponPart(target) then copySurfaceAppearance(target, frame) end
        end
        return
    end

    local defaultAppearance = frame:FindFirstChildOfClass("SurfaceAppearance")
    local mappedAny = false

    for _, source in ipairs(frame:GetChildren()) do
        if source:IsA("SurfaceAppearance") then
            local target = model:FindFirstChild(source.Name, true)
            if target and target:IsA("BasePart") then
                copySurfaceAppearance(target, source)
                mappedAny = true
            end
        elseif source:IsA("StringValue") or source:IsA("BasePart")
            or source:IsA("Folder") or source:IsA("Model") then
            local target = model:FindFirstChild(source.Name, true)
            if target then
                local appearance = source:FindFirstChildWhichIsA("SurfaceAppearance", true)
                if appearance and target:IsA("BasePart") then
                    copySurfaceAppearance(target, appearance)
                    mappedAny = true
                else
                    copyVisualNode(source, target)
                    mappedAny = true
                end
            end
        end
    end

    if defaultAppearance and not mappedAny then
        for _, target in ipairs(model:GetDescendants()) do
            if isVisibleWeaponPart(target) then copySurfaceAppearance(target, defaultAppearance) end
        end
    end
end

local function getSkinAnimationFrames(record)
    local skinFolder = getSkinAssetFolder(record)
    if not skinFolder then return nil end

    local candidates = { skinFolder:FindFirstChild("Animated") }
    local pbr = skinFolder:FindFirstChild("PBR")
    if pbr then table.insert(candidates, pbr:FindFirstChild("Animated")) end

    for _, animated in ipairs(candidates) do
        if animated then
            local metadata = {}
            if animated:IsA("ModuleScript") then
                local ok, result = pcall(require, animated)
                if ok and type(result) == "table" then metadata = result end
            end

            local frames = {}
            for _, value in ipairs(metadata) do
                local asset = normalizeAnimatedFrame(value)
                if asset then table.insert(frames, asset) end
            end

            local numbered = {}
            for _, child in ipairs(animated:GetChildren()) do
                local index = tonumber(child.Name)
                if index then table.insert(numbered, { index = index, frame = child }) end
            end
            table.sort(numbered, function(a, b) return a.index < b.index end)

            if #numbered > 0 then
                table.clear(frames)
                for _, entry in ipairs(numbered) do table.insert(frames, entry.frame) end
            end

            if #frames > 0 then
                return {
                    frames = frames,
                    delay = math.max(tonumber(metadata.delays or metadata.delay) or 0.04, 0.016),
                }
            end
        end
    end

    return nil
end

local function stopSkinAnimation(model)
    local state = skinAnimationState[model]
    if state then
        state.generation += 1
        skinAnimationState[model] = nil
    end
end

local function startSkinAnimation(model, record)
    stopSkinAnimation(model)
    local animation = getSkinAnimationFrames(record)
    if not animation or not model or not model.Parent then return end

    local state = { generation = 1 }
    skinAnimationState[model] = state
    local generation = state.generation
    local itemId = getItemId(record)

    task.spawn(function()
        local index = 1
        while not Unloaded and model.Parent
            and skinAnimationState[model] == state
            and state.generation == generation do
            local heldRecord = getHeldItemRecord()
            if model == getCurrentViewmodel()
                and (type(heldRecord) ~= "table" or heldRecord[1] ~= itemId) then
                break
            end

            local frame = animation.frames[index]
            if type(frame) == "string" then
                applyTextureSkinFrame(model, frame)
            elseif typeof(frame) == "Instance" then
                applyPbrFrame(model, frame)
            end

            index = index % #animation.frames + 1
            task.wait(animation.delay)
        end

        if skinAnimationState[model] == state then
            skinAnimationState[model] = nil
        end
    end)
end

local function applySkinFallback(model, record, worldModel)
    local skinFolder = getSkinAssetFolder(record)
    if not skinFolder or not model then return false end

    local sourceRoot = skinFolder
    if worldModel then
        sourceRoot = skinFolder:FindFirstChild("WorldModel") or skinFolder
    end

    for _, source in ipairs(sourceRoot:GetDescendants()) do
        if source:IsA("StringValue") and source.Name ~= "meshtype" then
            local target = model:FindFirstChild(source.Name, true)
            if target then copyVisualNode(source, target) end
        elseif source:IsA("BasePart") then
            local target = model:FindFirstChild(source.Name, true)
            if target then copyVisualNode(source, target) end
        elseif source:IsA("SurfaceAppearance") and source.Parent then
            local target = model:FindFirstChild(source.Parent.Name, true)
            if target and target:IsA("BasePart") then copySurfaceAppearance(target, source) end
        elseif (source:IsA("Texture") or source:IsA("Decal")) and source.Parent then
            local target = model:FindFirstChild(source.Parent.Name, true)
            if target and target:IsA("BasePart") then
                local clone = source:Clone()
                local old = target:FindFirstChild(source.Name)
                if old and old.ClassName == source.ClassName then old:Destroy() end
                clone.Parent = target
            end
        end
    end
    return true
end

local function mapSkinWithGame(model, record, worldModel)
    if not model or type(record) ~= "table" or not record[1] then return false end

    local silencerBefore = model:FindFirstChild("Silencer2", true)
    local silencerTransparency = silencerBefore
        and silencerBefore:IsA("BasePart")
        and silencerBefore.Transparency
        or nil

    local itemId = getItemId(record)
    local _, skinName = splitItemId(itemId)
    if skinName == "Stock" then skinName = "Stock" end
    local count = hasStatTrak(record) and math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999) or nil
    local skinFolder = getSkinAssetFolder(record)

    local mapSkin, mapWorld, owner = findNativeSkinMapper(false)
    local mapperFunction = worldModel and mapWorld or mapSkin
    local mapped = false

    if type(mapperFunction) == "function" then
        local attempts = {
            function() return mapperFunction(model, skinName, count) end,
            function() return mapperFunction(model, skinFolder, count) end,
            function() return mapperFunction(owner, model, skinName, count) end,
            function() return mapperFunction(owner, model, skinFolder, count) end,
        }
        for _, attempt in ipairs(attempts) do
            local ok = pcall(attempt)
            if ok then mapped = true break end
        end
    end

    if not mapped then
        mapped = applySkinFallback(model, record, worldModel)
        startSkinAnimation(model, record)
    else
        stopSkinAnimation(model)
    end

    if silencerTransparency ~= nil then
        local silencerAfter = model:FindFirstChild("Silencer2", true)
        if silencerAfter and silencerAfter:IsA("BasePart") then
            silencerAfter.Transparency = silencerTransparency
        end
    end

    updateWeaponCounter(model, count, itemId)
    return mapped
end

local weaponRefreshQueued = false
local weaponRefreshRecord = nil

local function getWeaponRefreshRemote(record)
    if Unloaded or type(record) ~= "table" or type(record[1]) ~= "string" or record[1] == "" then
        return nil
    end

    local liveRecord, team, slot = getHeldItemRecord()
    if type(liveRecord) ~= "table" or liveRecord[1] ~= record[1] then
        return nil
    end
    if team ~= "CT" and team ~= "T" then
        return nil
    end

    slot = normalizeSlot(slot, record[1])
    local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
    local equippedRecord = type(loadout) == "table" and loadout[slot] or nil
    if type(equippedRecord) ~= "table" or not sameItem(equippedRecord, record) then
        return nil
    end

    local value = getTeamSkinValue(team, slot)
    if not value or not value:IsA("ValueBase") then
        return nil
    end

    local _, skinName = splitItemId(record[1])
    if tostring(value.Value or "") ~= tostring(skinName or "") then
        return nil
    end

    if hasStatTrak(record) then
        local statFolder = value:FindFirstChild("StatTrak")
        local countValue = statFolder and statFolder:FindFirstChild("Count")
        if not countValue or not countValue:IsA("IntValue") then
            return nil
        end
        if countValue.Value ~= math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999) then
            return nil
        end
    elseif value:FindFirstChild("StatTrak") then
        return nil
    end

    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return nil
    end

    local events = ReplicatedStorage:FindFirstChild("Events")
    local resetRemote = events and events:FindFirstChild("resetweapons")
    if not resetRemote or not resetRemote:IsA("RemoteEvent") then
        return nil
    end

    local weapons = ReplicatedStorage:FindFirstChild("Weapons")
    local base = getItemBase(record[1])
    local nativeWeapon = KNIFE_MODEL_REMAP[base] or base
    if not weapons or not weapons:FindFirstChild(nativeWeapon) then
        return nil
    end

    return resetRemote
end

local function rebuildHeldWeapon(record, _replayNative)
    if Unloaded or type(record) ~= "table" or not record[1] then return end

    local heldRecord = getHeldItemRecord()
    if type(heldRecord) ~= "table" or heldRecord[1] ~= record[1] then
        return
    end

    local heldBase = getItemBase(record[1])
    if heldBase == "USP" or heldBase == "P2000" then
        return
    end

    weaponRefreshRecord = copyItem(record)
    if weaponRefreshQueued then return end
    weaponRefreshQueued = true

    task.delay(0.12, function()
        weaponRefreshQueued = false
        if Unloaded then return end

        local targetRecord = weaponRefreshRecord
        weaponRefreshRecord = nil
        local resetRemote = getWeaponRefreshRemote(targetRecord)
        if not resetRemote then return end

        local ok, err = pcall(function()
            firesignal(resetRemote.OnClientEvent)
        end)
        if not ok then
            warn("[Lenora] Could not rebuild the held weapon: " .. tostring(err))
        end
    end)
end

local function trackNativeKillCount(itemId, count, isLenoraWrite)
    itemId = tostring(itemId or "")
    if itemId == "" then return end

    count = math.clamp(math.floor(tonumber(count) or 0), 0, 999999)
    local previous = lastObservedNativeCount[itemId]
    if previous == nil then
        previous = tonumber(StatCounts[itemId])
    end
    previous = previous ~= nil
        and math.clamp(math.floor(previous), 0, 999999)
        or count

    lastObservedNativeCount[itemId] = count

    if not isLenoraWrite and count > previous and recordNativeKillIncrease then
        recordNativeKillIncrease(itemId, count - previous)
    end
end

local function watchKillCounter(countValue, itemId)
    if not countValue then return end

    itemId = tostring(itemId or "")
    if itemId == "" then return end

    countWatcherItems[countValue] = itemId
    countWatcherLastValues[countValue] =
        math.clamp(math.floor(tonumber(countValue.Value) or 0), 0, 999999)

    if countWatchers[countValue] then return end
    countWatchers[countValue] = true

    trackConnection(countValue:GetPropertyChangedSignal("Value"):Connect(function()
        if Unloaded then return end

        local watchedItemId = tostring(countWatcherItems[countValue] or "")
        if watchedItemId == "" then return end

        local count = math.clamp(math.floor(tonumber(countValue.Value) or 0), 0, 999999)
        local localTarget = localCountWriteTargets[countValue]
        local isLenoraWrite = localTarget ~= nil and tonumber(localTarget) == count
        if localTarget ~= nil then
            localCountWriteTargets[countValue] = nil
        end

        local maintained = getTrackedKillCount(watchedItemId)
        if not isLenoraWrite and maintained ~= nil and count < maintained then
            localCountWriteTargets[countValue] = maintained
            countWatcherLastValues[countValue] = maintained
            lastObservedNativeCount[watchedItemId] = maintained
            countValue.Value = maintained
            return
        end

        countWatcherLastValues[countValue] = count
        trackNativeKillCount(watchedItemId, count, isLenoraWrite)

        NormalItems[watchedItemId] = nil
        StatCounts[watchedItemId] = count
        local heldRecord = getHeldItemRecord()
        if type(heldRecord) == "table" and heldRecord[1] == watchedItemId then
            updateWeaponCounter(getCurrentViewmodel(), count, watchedItemId)
        end

        if not counterSyncQueued[watchedItemId] then
            counterSyncQueued[watchedItemId] = true
            task.defer(function()
                counterSyncQueued[watchedItemId] = nil
                if Unloaded then return end
                if fixStatTrakItem then fixStatTrakItem(watchedItemId, true) end
                saveConfig()
            end)
        end
    end))
end

local function setSkinFolderItem(team, slot, record)
    if type(record) ~= "table" or not record[1] then return end
    local itemId = getItemId(record)
    slot = normalizeSlot(slot, itemId)
    local value = getTeamSkinValue(team, slot, true)
    if not value or not value:IsA("ValueBase") then return end

    local _, skinName = splitItemId(itemId)
    pcall(function() value.Value = skinName end)

    local statFolder = value:FindFirstChild("StatTrak")
    if hasStatTrak(record) then
        if statFolder and not statFolder:IsA("Folder") then statFolder:Destroy(); statFolder = nil end
        if not statFolder then
            statFolder = Instance.new("Folder")
            statFolder.Name = "StatTrak"
            statFolder.Parent = value
        end

        local countValue = statFolder:FindFirstChild("Count")
        if countValue and not countValue:IsA("IntValue") then countValue:Destroy(); countValue = nil end
        if not countValue then
            countValue = Instance.new("IntValue")
            countValue.Name = "Count"
            countValue.Parent = statFolder
        end

        watchKillCounter(countValue, itemId)
        local targetCount = math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
        if countValue.Value ~= targetCount then
            localCountWriteTargets[countValue] = targetCount
            countValue.Value = targetCount
        else
            lastObservedNativeCount[itemId] = targetCount
        end
    elseif statFolder then
        statFolder:Destroy()
    end
end

local function clearSkinFolderItem(team, slot)
    local canonical = normalizeSlot(slot, nil)
    local seen = {}
    for _, candidate in ipairs({ tostring(slot or ""), canonical }) do
        if candidate ~= "" and not seen[candidate] then
            seen[candidate] = true
            local value = getTeamSkinValue(team, candidate, false)
            if value and value:IsA("ValueBase") then
                pcall(function() value.Value = "" end)
                local statFolder = value:FindFirstChild("StatTrak")
                if statFolder then statFolder:Destroy() end
            end
        end
    end
end

local function resetTeamKnife(team)
    if team ~= "CT" and team ~= "T" then return false end

    local stockId = team == "CT" and "CTKnife_Stock" or "TKnife_Stock"
    local ok = editData(team .. "Loadout", function(nextLoadout)
        nextLoadout.Knife = { stockId }
        nextLoadout.KnifeOver = false
    end)

    if team == "CT" then
        CTItems.Knife = nil
        CTItems.CTKnife = nil
        clearSkinFolderItem("CT", "Knife")
        clearSkinFolderItem("CT", "CTKnife")
    else
        TItems.Knife = nil
        TItems.TKnife = nil
        clearSkinFolderItem("T", "Knife")
        clearSkinFolderItem("T", "TKnife")
    end

    return ok
end

-- Loadout

local LocalPlayer = Players.LocalPlayer

-- Knife fix

local lastGoodKnifeState = {
    CT = nil,
    T = nil,
}
local knifeRepairQueued = {
    CT = false,
    T = false,
}

local function isValidKnifeRecord(record)
    return type(record) == "table"
        and type(record[1]) == "string"
        and record[1] ~= ""
end

local function hasSafeKnifeLoadout(loadout)
    return type(loadout) == "table"
        and (loadout.KnifeOver ~= true or isValidKnifeRecord(loadout.Knife))
end

local function getStockKnifeRecord(team)
    return { team == "CT" and "CTKnife_Stock" or "TKnife_Stock" }
end

local function rememberKnifeState(team, loadout)
    if team ~= "CT" and team ~= "T" then return false end
    if not hasSafeKnifeLoadout(loadout) then return false end

    if loadout.KnifeOver == true then
        lastGoodKnifeState[team] = {
            over = true,
            knife = copyItem(loadout.Knife),
        }
    else
        lastGoodKnifeState[team] = {
            over = false,
            knife = isValidKnifeRecord(loadout.Knife)
                and copyItem(loadout.Knife)
                or getStockKnifeRecord(team),
        }
    end
    return true
end

local function getPreferredKnifeState(team)
    local desired = team == "CT" and CTItems or TItems
    if type(desired) == "table" and isValidKnifeRecord(desired.Knife) then
        return {
            over = true,
            knife = copyItem(desired.Knife),
        }
    end

    local remembered = lastGoodKnifeState[team]
    if type(remembered) == "table" and isValidKnifeRecord(remembered.knife) then
        return {
            over = remembered.over == true,
            knife = copyItem(remembered.knife),
        }
    end

    return {
        over = false,
        knife = getStockKnifeRecord(team),
    }
end

local function repairKnifeLoadout(team, source, preferred)
    local safe = {}
    if type(source) == "table" then
        for key, value in pairs(source) do
            safe[key] = value
        end
    end

    preferred = preferred or getPreferredKnifeState(team)
    safe.Knife = copyItem(preferred.knife)
    safe.KnifeOver = preferred.over == true
    return safe, preferred
end

local function queueKnifeRepair(team, preferred)
    if Unloaded or knifeRepairQueued[team] then return end
    knifeRepairQueued[team] = true

    task.defer(function()
        knifeRepairQueued[team] = false
        if Unloaded then return end

        local label = team .. "Loadout"
        local live = GameData and GameData.GetData and GameData.GetData(label)
        if hasSafeKnifeLoadout(live) then
            rememberKnifeState(team, live)
            return
        end

        preferred = preferred or getPreferredKnifeState(team)
        local ok = editData(label, function(nextLoadout)
            nextLoadout.Knife = copyItem(preferred.knife)
            nextLoadout.KnifeOver = preferred.over == true
        end)

        if ok then
            local repaired = GameData and GameData.GetData and GameData.GetData(label)
            rememberKnifeState(team, repaired)
            if preferred.over == true then
                setSkinFolderItem(team, "Knife", preferred.knife)
            else
                clearSkinFolderItem(team, "Knife")
                clearSkinFolderItem(team, team .. "Knife")
            end
        end
    end)
end

local function hookCharacterKnifeSetup()
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local clientScript = playerGui and playerGui:FindFirstChild("Client")
    if not clientScript or not clientScript:IsA("LocalScript") then
        warn("[Lenora] Knife safety hook skipped because PlayerGui.Client was not found.")
        return false
    end

    local clientEnv
    if type(getsenv) == "function" then
        local okEnv, result = pcall(getsenv, clientScript)
        if okEnv and type(result) == "table" then
            clientEnv = result
        end
    end

    if not clientEnv and type(getconnections) == "function" and type(getfenv) == "function" then
        local okConnections, connections = pcall(getconnections, LocalPlayer.CharacterAdded)
        if okConnections and type(connections) == "table" then
            for _, connection in ipairs(connections) do
                local fn = connection and connection.Function
                if type(fn) == "function" then
                    local okCandidate, candidate = pcall(getfenv, fn)
                    if okCandidate
                        and type(candidate) == "table"
                        and rawget(candidate, "script") == clientScript
                        and type(rawget(candidate, "setcharacter")) == "function" then
                        clientEnv = candidate
                        break
                    end
                end
            end
        end
    end

    if type(clientEnv) ~= "table" then
        warn("[Lenora] Knife safety hook skipped because the client environment could not be read.")
        return false
    end

    local previous = rawget(clientEnv, "__LenoraCharacterGuard")
        or rawget(clientEnv, "__CounterBloxCustomSetCharacterGuard")
    local original = type(previous) == "table" and previous.original or rawget(clientEnv, "setcharacter")
    if type(original) ~= "function" then
        warn("[Lenora] Knife safety hook skipped because the game character setup function was not found.")
        return false
    end

    for _, team in ipairs({ "CT", "T" }) do
        local live = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
        rememberKnifeState(team, live)
    end

    local token = {}
    local function prepareTeam(team)
        local key = team .. "Loadout"
        local live = GameData and GameData.GetData and GameData.GetData(key)

        if hasSafeKnifeLoadout(live) then
            rememberKnifeState(team, live)
            clientEnv[key] = live
            return
        end

        local currentGlobal = rawget(clientEnv, key)
        local managed = team == "CT" and CTItems or TItems
        local preferred

        if type(managed) == "table" and isValidKnifeRecord(managed.Knife) then
            preferred = getPreferredKnifeState(team)
            local safe
            safe = repairKnifeLoadout(team, currentGlobal or live, preferred)
            clientEnv[key] = safe
        elseif hasSafeKnifeLoadout(currentGlobal) then
            rememberKnifeState(team, currentGlobal)
            preferred = lastGoodKnifeState[team]
            clientEnv[key] = currentGlobal
        else
            local safe
            safe, preferred = repairKnifeLoadout(team, currentGlobal or live)
            clientEnv[key] = safe
        end

        queueKnifeRepair(team, preferred)
    end

    local wrapper
    wrapper = function(...)
        if not Unloaded then
            prepareTeam("CT")
            prepareTeam("T")
        end
        return original(...)
    end

    local installed = pcall(function()
        clientEnv.setcharacter = wrapper
        clientEnv.__CounterBloxCustomSetCharacterGuard = nil
        clientEnv.__LenoraCharacterGuard = {
            token = token,
            original = original,
            wrapper = wrapper,
        }
    end)
    if not installed or rawget(clientEnv, "setcharacter") ~= wrapper then
        warn("[Lenora] Knife safety hook was rejected by the client environment.")
        return false
    end

    removeCharacterGuard = function()
        local active = rawget(clientEnv, "__LenoraCharacterGuard")
        if type(active) == "table" and active.token == token then
            if rawget(clientEnv, "setcharacter") == wrapper then
                clientEnv.setcharacter = original
            end
            clientEnv.__LenoraCharacterGuard = nil
            clientEnv.__CounterBloxCustomSetCharacterGuard = nil
        end
    end

    if type(GameData.ListenToChanges) == "function" then
        pcall(function()
            GameData.ListenToChanges("CTLoadout", function(loadout)
                if Unloaded then return end
                rememberKnifeState("CT", loadout)
            end)
        end)
        pcall(function()
            GameData.ListenToChanges("TLoadout", function(loadout)
                if Unloaded then return end
                rememberKnifeState("T", loadout)
            end)
        end)
    end

    return true
end

hookCharacterKnifeSetup()

local function refreshEquippedCounterVisual(_team, _slot, _record)
end

local function setTeamLoadoutItem(team, slot, record)
    if team ~= "CT" and team ~= "T" then return false end
    if type(record) ~= "table" or not record[1] then return false end

    local itemId = getItemId(record)
    local base = getItemBase(itemId)
    local cleanRecord = cleanItem(record)

    local ok = editData(team .. "Loadout", function(nextLoadout)
        nextLoadout[slot] = copyItem(cleanRecord)
        for key, value in pairs(getOverrideFlags(slot, base)) do
            nextLoadout[key] = value
        end
    end)

    if ok then
        setSkinFolderItem(team, slot, cleanRecord)
        refreshEquippedCounterVisual(team, slot, cleanRecord)
    end
    return ok
end

local function equipItemLocally(side, slot, itemRecord)
    if Unloaded then return false end
    if type(itemRecord) ~= "table" or type(itemRecord[1]) ~= "string" or itemRecord[1] == "" then
        return false
    end

    local itemId = getItemId(itemRecord)
    slot = normalizeSlot(slot, itemId)
    local doCT, doT = getTeams(side)

    if Env.__LenoraInventory.hidden
        and type(Env.__LenoraInventory.keepItemVisible) == "function" then
        Env.__LenoraInventory.keepItemVisible(itemId, itemRecord)
    end

    if slot == "Knife" and isStockTeamKnife(itemId) then
        if not doCT and not doT then
            doCT = itemId == "CTKnife_Stock"
            doT = itemId == "TKnife_Stock"
        end
        if doCT then resetTeamKnife("CT") end
        if doT then resetTeamKnife("T") end
        task.defer(saveConfig)
        if Env.__LenoraInventory.hidden
            and type(Env.__LenoraInventory.applyHiddenInventory) == "function" then
            task.defer(Env.__LenoraInventory.applyHiddenInventory)
        end
        return true
    end

    local cleanRecord = cleanItem(itemRecord)
    local changed = false

    if doCT then
        if slot == "Knife" then CTItems.CTKnife = nil end
        if slot == "Glove" then CTItems.CTGlove = nil end
        CTItems[slot] = copyItem(cleanRecord)
        changed = setTeamLoadoutItem("CT", slot, cleanRecord) or changed
    end

    if doT then
        if slot == "Knife" then TItems.TKnife = nil end
        if slot == "Glove" then TItems.TGlove = nil end
        TItems[slot] = copyItem(cleanRecord)
        changed = setTeamLoadoutItem("T", slot, cleanRecord) or changed
    end

    rebuildHeldWeapon(cleanRecord, true)
    task.defer(saveConfig)
    if Env.__LenoraInventory.hidden
        and type(Env.__LenoraInventory.applyHiddenInventory) == "function" then
        task.defer(Env.__LenoraInventory.applyHiddenInventory)
    end
    return changed
end

local function unequipItemLocally(side, slot)
    if Unloaded then return false end

    slot = normalizeSlot(slot, nil)
    local doCT, doT = getTeams(side)

    if slot == "Knife" then
        if doCT then resetTeamKnife("CT") end
        if doT then resetTeamKnife("T") end
        task.defer(saveConfig)
        return true
    end

    local function resetTeam(team)
        local stockId
        if slot == "Glove" then
            stockId = team == "CT" and "CTGlove_Stock" or "TGlove_Stock"
        else
            stockId = slot .. "_Stock"
        end

        local stockRecord = { stockId }
        local ok = editData(team .. "Loadout", function(nextLoadout)
            nextLoadout[slot] = copyItem(stockRecord)
            for key, value in pairs(getOverrideFlags(slot, getItemBase(stockId))) do
                nextLoadout[key] = value
            end
        end)

        if team == "CT" then CTItems[slot] = nil else TItems[slot] = nil end
        clearSkinFolderItem(team, slot)
        return ok
    end

    local changed = false
    if doCT then changed = resetTeam("CT") or changed end
    if doT then changed = resetTeam("T") or changed end
    task.defer(saveConfig)
    if Env.__LenoraInventory.hidden
        and type(Env.__LenoraInventory.applyHiddenInventory) == "function" then
        task.defer(Env.__LenoraInventory.applyHiddenInventory)
    end
    return changed
end


-- StatTrak


local function supportsStatTrak(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" then
        return false
    end
    if itemId == "CTKnife_Stock" or itemId == "TKnife_Stock" then
        return false
    end
    if itemId == "CTGlove_Stock" or itemId == "TGlove_Stock" then
        return false
    end
    if GLOVE_NAME_SET[getItemBase(itemId)] then
        return false
    end
    return true
end

local function makeStatTrakRecord(itemId, kills)
    itemId = tostring(itemId or "")
    local owner = StatOwners[itemId]

    if owner == nil then
        local current = GameData and GameData.GetData and GameData.GetData("Inventory")
        if type(current) == "table" then
            for _, record in pairs(current) do
                if type(record) == "table" and tostring(record[1] or "") == itemId and record[3] ~= nil then
                    owner = record[3]
                    break
                end
            end
        end
    end

    if owner == nil then
        owner = LocalPlayer and LocalPlayer.UserId or 0
    end

    StatOwners[itemId] = owner
    return {
        [1] = itemId,
        [2] = "StatTrak",
        [3] = owner,
        [4] = math.clamp(math.floor(tonumber(kills) or 0), 0, 999999),
    }
end

local function getCanonicalItem(itemId)
    local kills = StatCounts[tostring(itemId or "")]
    if kills ~= nil then
        return makeStatTrakRecord(itemId, kills)
    end
    return { tostring(itemId or "") }
end

local function refreshInventory()
    refreshInventoryView()
end

local function readStatTrak()
    local current = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(current) ~= "table" then
        return
    end

    for _, item in current do
        if hasStatTrak(item) and supportsStatTrak(item[1]) then
            local itemId = tostring(item[1])
            if not NormalItems[itemId] then
                StatOwners[itemId] = item[3]
                StatCounts[itemId] =
                    math.clamp(math.floor(tonumber(item[4]) or 0), 0, 999999)
            end
        end
    end
end

local function updateEquipped(itemId, mutationVersion)
    itemId = tostring(itemId or "")
    if itemId == "" then return end

    local newRecord = cleanItem(getCanonicalItem(itemId))

    local function patchTeam(team, desired)
        local dataName = team .. "Loadout"
        local current = GameData.GetData(dataName)
        if type(current) ~= "table" then return end

        local slots = {}
        for rawSlot, record in pairs(current) do
            if type(record) == "table" and tostring(record[1] or "") == itemId then
                slots[normalizeSlot(rawSlot, itemId)] = true
            end
        end
        for rawSlot, record in pairs(desired) do
            if type(record) == "table" and tostring(record[1] or "") == itemId then
                slots[normalizeSlot(rawSlot, itemId)] = true
            end
        end
        if next(slots) == nil then return end

        local ok = editData(dataName, function(nextLoadout)
            for slot in pairs(slots) do
                nextLoadout[slot] = copyItem(newRecord)
                for key, value in pairs(getOverrideFlags(slot, getItemBase(itemId))) do
                    nextLoadout[key] = value
                end
            end
        end)

        if ok and StatVersions[itemId] == mutationVersion then
            for slot in pairs(slots) do
                desired[slot] = copyItem(newRecord)
                setSkinFolderItem(team, slot, newRecord)
            end
        end
    end

    patchTeam("CT", CTItems)
    patchTeam("T", TItems)
end

fixStatTrakItem = function(itemId, countOnly)
    itemId = tostring(itemId or "")
    if itemId == "" or not supportsStatTrak(itemId) then
        return false
    end

    local current = GameData.GetData("Inventory")
    if type(current) ~= "table" then
        return false
    end

    StatVersions[itemId] = (StatVersions[itemId] or 0) + 1
    local mutationVersion = StatVersions[itemId]
    local newRecord = cleanItem(getCanonicalItem(itemId))

    if Env.__LenoraInventory.protectedItemIds[itemId] == true then
        Env.__LenoraInventory.protectedItemRecords[itemId] =
            copyItem(newRecord)
        if type(Env.__LenoraInventory.saveEquippedItemProtection) == "function" then
            Env.__LenoraInventory.saveEquippedItemProtection()
        end
    end

    local ok = editData("Inventory", function(nextInventory)
        local matchingNumeric = {}
        local matchingOther = {}

        for index, record in pairs(nextInventory) do
            if type(record) == "table" and tostring(record[1] or "") == itemId then
                if type(index) == "number" and index >= 1 and index % 1 == 0 then
                    matchingNumeric[#matchingNumeric + 1] = index
                else
                    matchingOther[#matchingOther + 1] = index
                end
            end
        end

        table.sort(matchingNumeric)
        local found = #matchingNumeric > 0 or #matchingOther > 0

        if found then
            local keeper = matchingNumeric[1] or matchingOther[1]
            nextInventory[keeper] = copyItem(newRecord)

            for i = 2, #matchingNumeric do
                nextInventory[matchingNumeric[i]] = nil
            end
            for _, index in ipairs(matchingOther) do
                if index ~= keeper then
                    nextInventory[index] = nil
                end
            end

            if #matchingNumeric > 1 then
                local numericKeys = {}
                for index in pairs(nextInventory) do
                    if type(index) == "number" and index >= 1 and index % 1 == 0 then
                        numericKeys[#numericKeys + 1] = index
                    end
                end
                table.sort(numericKeys)

                local compact = {}
                for _, index in ipairs(numericKeys) do
                    if nextInventory[index] ~= nil then
                        compact[#compact + 1] = nextInventory[index]
                    end
                    nextInventory[index] = nil
                end
                for index, record in ipairs(compact) do
                    nextInventory[index] = record
                end
            end
        else
            local mayAppear = not Env.__LenoraInventory.hidden
                or type(Env.__LenoraInventory.shouldKeepItemVisible) ~= "function"
                or Env.__LenoraInventory.shouldKeepItemVisible(itemId)

            if mayAppear then
                nextInventory[#nextInventory + 1] = copyItem(newRecord)
            end
        end
    end)

    if not ok then return false end

    updateEquipped(itemId, mutationVersion)

    if countOnly then
        local count = hasStatTrak(newRecord) and newRecord[4] or nil
        updateWeaponCounter(getCurrentViewmodel(), count, itemId)
    else
        rebuildHeldWeapon(newRecord, true)
    end
    return true
end

local function cleanStatTrak()
    readStatTrak()
    for itemId in pairs(StatCounts) do
        fixStatTrakItem(itemId)
    end
end

local function makeInventoryItem(item)
    local itemId = type(item) == "table" and item[1] or nil
    if itemId and StatCounts[tostring(itemId)] ~= nil then
        return makeStatTrakRecord(itemId, StatCounts[tostring(itemId)])
    end
    return item
end

local function addStatTrakButton()
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local menew = pg and pg:FindFirstChild("Menew")
    local options = menew and menew:FindFirstChild("RClickEquipOptions")
    local dropdown = options and options:FindFirstChild("Dropdown")
    if not dropdown then
        return false
    end

    local equipBoth = dropdown:FindFirstChild("Equip_Both")
        or dropdown:FindFirstChild("Equip_T")
        or dropdown:FindFirstChild("Equip_CT")
    if not equipBoth or not equipBoth:IsA("GuiButton") then
        return false
    end

    local existing = dropdown:FindFirstChild("Lenora_StatTrakButton")
    if existing then
        existing:Destroy()
    end

    local function isRecord(value)
        return type(value) == "table" and type(value[1]) == "string" and value[1] ~= ""
    end

    local function readUpvalues(fn, visitor)
        if type(fn) ~= "function" or type(visitor) ~= "function" then
            return nil
        end

        if type(getupvalues) == "function" then
            local ok, values = pcall(getupvalues, fn)
            if ok and type(values) == "table" then
                for _, value in pairs(values) do
                    local found = visitor(value)
                    if found then
                        return found
                    end
                end
            end
        end

        if type(debug) == "table" and type(debug.getupvalue) == "function" then
            for index = 1, 35 do
                local ok, a, b = pcall(debug.getupvalue, fn, index)
                if not ok then
                    break
                end
                local value = b ~= nil and b or a
                if value == nil then
                    break
                end
                local found = visitor(value)
                if found then
                    return found
                end
            end
        end

        return nil
    end

    local function selectedRecordFromButtonConnections()
        if type(getconnections) ~= "function" then
            return nil
        end

        for _, buttonName in ipairs({ "Equip_Both", "Equip_CT", "Equip_T" }) do
            local button = dropdown:FindFirstChild(buttonName)
            if button and button:IsA("GuiButton") then
                for _, signal in ipairs({ button.Activated, button.MouseButton1Click }) do
                    local ok, connections = pcall(getconnections, signal)
                    if ok and type(connections) == "table" then
                        for _, connection in ipairs(connections) do
                            local fn = connection and connection.Function
                            local found = readUpvalues(fn, function(value)
                                if isRecord(value) then
                                    return value
                                end
                                return nil
                            end)
                            if found then
                                return found
                            end
                        end
                    end
                end
            end
        end

        return nil
    end

    local function currentInventoryRecordFor(record)
        if not isRecord(record) then
            return record
        end

        local current = GameData.GetData("Inventory")
        if type(current) ~= "table" then
            return record
        end

        local itemId = tostring(record[1])
        local baseRecord, statRecord

        for _, item in current do
            if isRecord(item) and tostring(item[1]) == itemId then
                if hasStatTrak(item) then
                    statRecord = statRecord or item
                else
                    baseRecord = baseRecord or item
                end
            end
        end

        if statRecord then
            StatOwners[itemId] = statRecord[3]
            StatCounts[itemId] =
                math.clamp(math.floor(tonumber(statRecord[4]) or 0), 0, 999999)
            return statRecord
        end

        return baseRecord or record
    end

    local function applyTextGradient(gui)
        if not gui or not (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) then
            return
        end

        gui.TextColor3 = Color3.fromRGB(255, 184, 38)

        local gradient = gui:FindFirstChild("Lenora_OrangeTextGradient")
        if not gradient then
            gradient = Instance.new("UIGradient")
            gradient.Name = "Lenora_OrangeTextGradient"
            gradient.Rotation = 0
            gradient.Parent = gui
        end

        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 118, 24)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 183, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 232, 116)),
        })
    end

    local statButton = equipBoth:Clone()
    statButton.Name = "Lenora_StatTrakButton"
    statButton.LayoutOrder = (equipBoth.LayoutOrder or 3) + 1
    statButton.Position = equipBoth.Position + UDim2.fromOffset(0, equipBoth.AbsoluteSize.Y > 0 and equipBoth.AbsoluteSize.Y or 30)
    statButton.Parent = dropdown
    statButton.Visible = true
    statButton.Active = true
    statButton.Selectable = false
    statButton.AutoButtonColor = true

    dropdown.ClipsDescendants = false

    local label = nil
    local function ensureLabel()
        if label and label.Parent then
            return label
        end

        for _, descendant in ipairs(statButton:GetDescendants()) do
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                label = descendant
                break
            end
        end

        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Lenora_StatTrakText"
            label.BackgroundTransparency = 1
            label.Size = UDim2.fromScale(1, 1)
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = statButton
        end

        applyTextGradient(label)
        return label
    end

    local function setButtonText(text)
        local target = ensureLabel()
        target.Text = text
        applyTextGradient(target)

        if statButton:IsA("TextButton") then
            statButton.Text = ""
        end
    end

    local input = Instance.new("TextBox")
    input.Name = "Lenora_StatTrakKillsInput"
    input.BackgroundTransparency = 0.05
    input.BackgroundColor3 = Color3.fromRGB(8, 14, 22)
    input.BorderSizePixel = 0
    input.ClearTextOnFocus = false
    input.Size = UDim2.fromScale(1, 1)
    input.Font = Enum.Font.GothamSemibold
    input.TextSize = 12
    input.TextColor3 = Color3.fromRGB(255, 205, 80)
    input.PlaceholderText = "Kills amount + Enter"
    input.PlaceholderColor3 = Color3.fromRGB(170, 126, 70)
    input.Text = ""
    input.Visible = false
    input.ZIndex = statButton.ZIndex + 2
    input.Parent = statButton
    applyTextGradient(input)

    local activeRecord = nil
    local statTrakSubmitBusy = false

    local nativeEquipButtonState = {}
    local statInputActionBound = false

    local function unbindStatInputAction()
        if statInputActionBound then
            statInputActionBound = false
            pcall(function()
                ContextActionService:UnbindAction(STATTRAK_INPUT_ACTION)
            end)
        end
    end

    local function restoreNativeEquipButtons()
        unbindStatInputAction()
        for button, state in pairs(nativeEquipButtonState) do
            if button and button.Parent then
                pcall(function()
                    button.Active = state.Active
                    button.Selectable = state.Selectable
                    button.AutoButtonColor = state.AutoButtonColor
                end)
            end
        end
        table.clear(nativeEquipButtonState)
    end

    local function suspendNativeEquipButtons()
        restoreNativeEquipButtons()

        pcall(function()
            GuiService.SelectedObject = nil
        end)

        for _, buttonName in ipairs({ "Equip_T", "Equip_CT", "Equip_Both" }) do
            local button = dropdown:FindFirstChild(buttonName)
            if button and button:IsA("GuiButton") then
                nativeEquipButtonState[button] = {
                    Active = button.Active,
                    Selectable = button.Selectable,
                    AutoButtonColor = button.AutoButtonColor,
                }
                button.Active = false
                button.Selectable = false
                button.AutoButtonColor = false
            end
        end

        statInputActionBound = true
        ContextActionService:BindActionAtPriority(
            STATTRAK_INPUT_ACTION,
            function(_, inputState)
                if inputState == Enum.UserInputState.Begin and input.Visible then
                    task.defer(function()
                        if input.Visible then
                            input:ReleaseFocus(true)
                        end
                    end)
                end
                return Enum.ContextActionResult.Sink
            end,
            false,
            3000,
            Enum.KeyCode.Return,
            Enum.KeyCode.KeypadEnter
        )
    end

    local function finishStatTrakInput()
        input.Visible = false
        pcall(function()
            GuiService.SelectedObject = nil
        end)
        task.defer(restoreNativeEquipButtons)
    end

    local function refreshButton()
        local record = currentInventoryRecordFor(selectedRecordFromButtonConnections())
        activeRecord = record

        local usable = isRecord(record) and supportsStatTrak(record[1])
        statButton.Visible = usable
        input.Visible = false
        if not usable then
            return
        end

        if hasStatTrak(record) or StatCounts[tostring(record[1])] ~= nil then
            setButtonText("Remove StatTrak")
        else
            setButtonText("Add A StatTrak")
        end
    end

    trackConnection(statButton.Activated:Connect(function()
        if statTrakSubmitBusy then return end

        refreshButton()
        activeRecord = currentInventoryRecordFor(activeRecord or selectedRecordFromButtonConnections())
        if not (isRecord(activeRecord) and supportsStatTrak(activeRecord[1])) then
            return
        end

        local itemId = tostring(activeRecord[1])
        if hasStatTrak(activeRecord) or StatCounts[itemId] ~= nil then
            statTrakSubmitBusy = true
            input.Visible = false
            if options then options.Visible = false end
            if menew and menew:FindFirstChild("RClickInputCapture") then
                menew.RClickInputCapture.Visible = false
            end

            task.defer(function()
                local ok, err = pcall(function()
                    if Unloaded then return end
                    pendingStatTrakKills[itemId] = nil
                    nativeCountCredits[itemId] = nil
                    lastObservedNativeCount[itemId] = nil
                    StatCounts[itemId] = nil
                    NormalItems[itemId] = true
                    fixStatTrakItem(itemId)
                    saveConfig()
                end)
                statTrakSubmitBusy = false
                if not ok then
                    warn("[Lenora] Could not remove StatTrak: " .. tostring(err))
                end
            end)
            return
        end

        setButtonText("")
        input.Text = ""
        suspendNativeEquipButtons()
        input.Visible = true
        pcall(function()
            GuiService.SelectedObject = nil
        end)
        input:CaptureFocus()
    end))

    trackConnection(input.FocusLost:Connect(function(enterPressed)
        if statTrakSubmitBusy or not input.Visible then
            return
        end

        if not enterPressed and tostring(input.Text or "") == "" then
            finishStatTrakInput()
            refreshButton()
            return
        end

        local record = currentInventoryRecordFor(activeRecord or selectedRecordFromButtonConnections())
        if not (isRecord(record) and supportsStatTrak(record[1])) then
            finishStatTrakInput()
            refreshButton()
            return
        end

        local digits = tostring(input.Text or ""):gsub("%D", "")
        if digits == "" then
            finishStatTrakInput()
            refreshButton()
            return
        end

        local itemId = tostring(record[1])
        local count = math.clamp(math.floor(tonumber(digits) or 0), 0, 999999)

        statTrakSubmitBusy = true
        finishStatTrakInput()
        if options then options.Visible = false end
        if menew and menew:FindFirstChild("RClickInputCapture") then
            menew.RClickInputCapture.Visible = false
        end

        task.defer(function()
            local ok, err = pcall(function()
                if Unloaded then return end
                pendingStatTrakKills[itemId] = nil
                nativeCountCredits[itemId] = nil
                NormalItems[itemId] = nil
                StatCounts[itemId] = count
                lastObservedNativeCount[itemId] = count
                fixStatTrakItem(itemId)
                saveConfig()
            end)
            statTrakSubmitBusy = false
            if not ok then
                warn("[Lenora] Could not update StatTrak: " .. tostring(err))
            end
        end)
    end))

    trackConnection(options:GetPropertyChangedSignal("Visible"):Connect(function()
        if options.Visible then
            task.defer(refreshButton)
        else
            input.Visible = false
            activeRecord = nil
            pcall(function()
                GuiService.SelectedObject = nil
            end)
            task.defer(restoreNativeEquipButtons)
        end
    end))

    trackConnection(options:GetPropertyChangedSignal("Position"):Connect(function()
        if options.Visible then
            task.defer(refreshButton)
        end
    end))

    refreshButton()
    return true
end


-- Drops

Env.__LenoraDrops = {
    initialized = false,
    generation = 0,
    pending = nil,
    debris = nil,
    clientEnvironment = nil,
    weaponNames = {},
    directParts = setmetatable({}, { __mode = "k" }),
    ownDrops = setmetatable({}, { __mode = "k" }),
    groundConnections = setmetatable({}, { __mode = "k" }),
    heldSlotState = {},
    foreignHeldWeaponNames = {},
    connections = {},
    exactDropCount = 0,
    ambiguousDropCount = 0,
    nativePickupCount = 0,
    restoredPickupCount = 0,
}

Env.__LenoraDrops.stopWatchingGroundItem = function(part)
    local runtime = Env.__LenoraDrops
    local bundle = runtime.groundConnections[part]
    if type(bundle) == "table" then
        for _, connection in pairs(bundle) do
            if typeof(connection) == "RBXScriptConnection" then
                pcall(function() connection:Disconnect() end)
            end
        end
    end
    runtime.groundConnections[part] = nil
end

Env.__LenoraDrops.stop = function()
    local runtime = Env.__LenoraDrops
    runtime.generation += 1
    runtime.pending = nil

    for _, connection in ipairs(runtime.connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(runtime.connections)

    for part in pairs(runtime.groundConnections) do
        runtime.stopWatchingGroundItem(part)
    end

    table.clear(runtime.directParts)
    table.clear(runtime.ownDrops)
    table.clear(runtime.heldSlotState)
    table.clear(runtime.foreignHeldWeaponNames)
    runtime.initialized = false
end

Env.__LenoraDrops.findClientEnvironment = function()
    local runtime = Env.__LenoraDrops
    if type(runtime.clientEnvironment) == "table" then
        return runtime.clientEnvironment
    end

    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local clientScript = playerGui and playerGui:FindFirstChild("Client")
    if not clientScript or not clientScript:IsA("LocalScript") then
        return nil
    end

    if type(getsenv) == "function" then
        local ok, environment = pcall(getsenv, clientScript)
        if ok and type(environment) == "table" then
            runtime.clientEnvironment = environment
            return environment
        end
    end

    if type(getconnections) == "function" and type(getfenv) == "function" then
        local okConnections, connections = pcall(getconnections, LocalPlayer.CharacterAdded)
        if okConnections and type(connections) == "table" then
            for _, connection in ipairs(connections) do
                local fn = connection and connection.Function
                if type(fn) == "function" then
                    local okEnvironment, environment = pcall(getfenv, fn)
                    if okEnvironment
                        and type(environment) == "table"
                        and rawget(environment, "script") == clientScript then
                        runtime.clientEnvironment = environment
                        return environment
                    end
                end
            end
        end
    end

    return nil
end

Env.__LenoraDrops.getSlotForWeapon = function(weaponName)
    local template = ReplicatedStorage.Weapons:FindFirstChild(tostring(weaponName or ""))
    if not template then return nil end
    if template:FindFirstChild("Primary") then return "primary" end
    if template:FindFirstChild("Secondary") then return "secondary" end
    return nil
end

Env.__LenoraDrops.getRecordForSkin = function(weaponName, skinName)
    weaponName = tostring(weaponName or "")
    skinName = tostring(skinName or "")
    if weaponName == "" or skinName == "" or skinName == "Stock" then
        return nil
    end

    local expectedId = weaponName .. "_" .. skinName
    local team = getCurrentTeam()
    if team ~= "CT" and team ~= "T" then return nil end

    local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
    if type(loadout) ~= "table" then return nil end

    for _, record in pairs(loadout) do
        if type(record) == "table" and getItemId(record) == expectedId then
            local visibility = Env.__LenoraInventory
            local synthetic = visibility.addedItemIds[expectedId] == true
                or StatCounts[expectedId] ~= nil
                or NormalItems[expectedId] == true

            if not synthetic then
                return nil
            end

            if StatCounts[expectedId] ~= nil then
                return {
                    [1] = expectedId,
                    [2] = "StatTrak",
                    [3] = StatOwners[expectedId]
                        or record[3]
                        or LocalPlayer.UserId,
                    [4] = math.clamp(
                        math.floor(tonumber(StatCounts[expectedId]) or 0),
                        0,
                        999999
                    ),
                }
            end

            if NormalItems[expectedId] == true then
                return { expectedId }
            end

            return cleanItem(record)
        end
    end

    return nil
end

Env.__LenoraDrops.getDropRecord = function(weaponName, slot)
    local runtime = Env.__LenoraDrops
    weaponName = tostring(weaponName or "")
    slot = tostring(slot or ""):lower()

    if slot ~= "primary" and slot ~= "secondary" then
        return nil
    end

    if runtime.foreignHeldWeaponNames[weaponName] == true then
        return nil
    end

    local heldState = runtime.heldSlotState[slot]
    if type(heldState) == "table" then
        if heldState.kind == "foreign" then
            return nil
        end
        if heldState.kind == "own"
            and type(heldState.record) == "table"
            and getItemBase(heldState.record[1]) == weaponName then
            local _, heldSkinName = splitItemId(heldState.record[1])
            local refreshed =
                runtime.getRecordForSkin(weaponName, heldSkinName)
            return type(refreshed) == "table"
                and refreshed
                or copyItem(heldState.record)
        end
    end

    local environment = runtime.findClientEnvironment()
    if type(environment) ~= "table" then
        return nil
    end

    local equipped = tostring(rawget(environment, "equipped") or ""):lower()
    if equipped ~= "" and equipped ~= slot then
        return nil
    end

    local nativeWeapon
    local skinName
    if slot == "primary" then
        nativeWeapon = tostring(rawget(environment, "realgun") or "")
        if nativeWeapon == "" then
            nativeWeapon = tostring(rawget(environment, "primary") or "")
        end
        skinName = tostring(rawget(environment, "primaryskin") or "")
    else
        nativeWeapon = tostring(rawget(environment, "secondary") or "")
        skinName = tostring(rawget(environment, "secondaryskin") or "")
    end

    if nativeWeapon ~= ""
        and normalizeMapperWeapon(nativeWeapon)
            ~= normalizeMapperWeapon(weaponName) then
        return nil
    end

    return runtime.getRecordForSkin(weaponName, skinName)
end

Env.__LenoraDrops.beginDrop = function(weaponName, slot)
    local runtime = Env.__LenoraDrops
    weaponName = tostring(weaponName or "")
    slot = tostring(slot or ""):lower()

    if weaponName == "" or (slot ~= "primary" and slot ~= "secondary") then
        runtime.pending = nil
        return nil
    end

    runtime.generation += 1
    local generation = runtime.generation
    local before = setmetatable({}, { __mode = "k" })

    for part in pairs(runtime.directParts) do
        if typeof(part) == "Instance"
            and part.Parent == runtime.debris
            and tostring(part.Name or "") == weaponName then
            before[part] = true
        end
    end

    runtime.pending = {
        generation = generation,
        weaponName = weaponName,
        slot = slot,
        before = before,
        candidates = setmetatable({}, { __mode = "k" }),
        record = nil,
        acknowledged = false,
        marker = nil,
        markerRemoved = false,
        startedAt = os.clock(),
    }

    task.delay(2, function()
        local pending = runtime.pending
        if type(pending) == "table" and pending.generation == generation then
            runtime.finishPendingDrop(true)
        end
    end)

    return generation
end

Env.__LenoraDrops.finishDrop = function(weaponName, slot, generation)
    local runtime = Env.__LenoraDrops
    local pending = runtime.pending
    if type(pending) ~= "table"
        or pending.generation ~= generation
        or pending.weaponName ~= tostring(weaponName or "")
        or pending.slot ~= tostring(slot or ""):lower() then
        return false
    end

    local record = runtime.getDropRecord(pending.weaponName, pending.slot)

    runtime.heldSlotState[pending.slot] = nil
    runtime.foreignHeldWeaponNames[pending.weaponName] = nil

    if type(record) ~= "table" or type(record[1]) ~= "string" or record[1] == "" then
        runtime.pending = nil
        return false
    end

    pending.record = copyItem(record)

    task.defer(function()
        if runtime.pending == pending then
            runtime.finishPendingDrop(false)
        end
    end)

    return true
end

Env.__LenoraDrops.skinDroppedPart = function(part, record, slot)
    local runtime = Env.__LenoraDrops
    if typeof(part) ~= "Instance"
        or part.Parent ~= runtime.debris
        or not part:IsA("BasePart")
        or type(record) ~= "table"
        or not record[1] then
        return false
    end

    runtime.ownDrops[part] = {
        record = copyItem(record),
        slot = tostring(slot or ""):lower(),
        weaponName = tostring(part.Name or ""),
    }
    runtime.exactDropCount += 1

    local function mapNow()
        local tracked = runtime.ownDrops[part]
        if Unloaded
            or type(tracked) ~= "table"
            or part.Parent ~= runtime.debris then
            return
        end
        pcall(mapSkinWithGame, part, copyItem(tracked.record), true)
    end

    mapNow()

    local remapQueued = false
    local descendantConnection = part.DescendantAdded:Connect(function()
        if remapQueued then return end
        remapQueued = true
        task.defer(function()
            remapQueued = false
            mapNow()
        end)
    end)

    local ancestryConnection
    ancestryConnection = part.AncestryChanged:Connect(function()
        if part.Parent ~= runtime.debris then
            runtime.ownDrops[part] = nil
            runtime.stopWatchingGroundItem(part)
        end
    end)

    runtime.groundConnections[part] = {
        descendantConnection,
        ancestryConnection,
    }

    task.defer(mapNow)
    return true
end

Env.__LenoraDrops.finishPendingDrop = function(force)
    local runtime = Env.__LenoraDrops
    local pending = runtime.pending
    if type(pending) ~= "table" or type(pending.record) ~= "table" then
        return false
    end
    if not pending.acknowledged and not force then
        return false
    end

    local candidates = {}
    local seen = {}

    for part in pairs(pending.candidates) do
        if typeof(part) == "Instance"
            and part.Parent == runtime.debris
            and tostring(part.Name or "") == pending.weaponName
            and not pending.before[part] then
            candidates[#candidates + 1] = part
            seen[part] = true
        end
    end

    for part in pairs(runtime.directParts) do
        if typeof(part) == "Instance"
            and part.Parent == runtime.debris
            and tostring(part.Name or "") == pending.weaponName
            and not pending.before[part]
            and not seen[part] then
            candidates[#candidates + 1] = part
            seen[part] = true
        end
    end

    if #candidates > 1 then
        runtime.ambiguousDropCount += 1
        runtime.pending = nil
        return false
    end

    if #candidates == 1
        and (pending.acknowledged or pending.markerRemoved or force) then
        local part = candidates[1]
        local record = copyItem(pending.record)
        local slot = pending.slot
        runtime.pending = nil
        return runtime.skinDroppedPart(part, record, slot)
    end

    if force then
        runtime.pending = nil
        return false
    end

    return false
end

Env.__LenoraDrops.capturePickup = function(instance)
    local runtime = Env.__LenoraDrops
    if typeof(instance) ~= "Instance" then
        return nil
    end

    local tracked = runtime.ownDrops[instance]
    if type(tracked) ~= "table"
        or type(tracked.record) ~= "table"
        or not tracked.record[1] then
        return nil
    end

    return {
        record = copyItem(tracked.record),
        slot = tostring(tracked.slot or ""):lower(),
        weaponName = tostring(tracked.weaponName or instance.Name or ""),
    }
end

Env.__LenoraDrops.handlePickupResult = function(instance, results, pickupContext)
    local runtime = Env.__LenoraDrops
    if type(results) ~= "table" or not results[1] then
        return results
    end

    runtime.nativePickupCount += 1

    local tracked = type(pickupContext) == "table"
        and pickupContext
        or runtime.ownDrops[instance]
    local weaponName = type(tracked) == "table"
        and tostring(tracked.weaponName or "")
        or (typeof(instance) == "Instance" and tostring(instance.Name or "") or "")
    local slot = type(tracked) == "table"
        and tostring(tracked.slot or ""):lower()
        or runtime.getSlotForWeapon(weaponName)

    if type(tracked) ~= "table"
        or type(tracked.record) ~= "table"
        or not tracked.record[1] then
        if slot == "primary" or slot == "secondary" then
            runtime.heldSlotState[slot] = {
                kind = "foreign",
                weaponName = weaponName,
            }
        end
        if weaponName ~= "" then
            runtime.foreignHeldWeaponNames[weaponName] = true
        end
        return results
    end

    local record = copyItem(tracked.record)
    local _, skinName = splitItemId(record[1])
    if skinName == "" then
        return results
    end

    results.n = math.max(tonumber(results.n) or 0, 6)
    results[2] = skinName

    results[3] = LocalPlayer.Name
    results[4] = hasStatTrak(record)
        and math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
        or nil

    if slot == "primary" or slot == "secondary" then
        runtime.heldSlotState[slot] = {
            kind = "own",
            weaponName = weaponName,
            record = copyItem(record),
        }
    end
    runtime.foreignHeldWeaponNames[weaponName] = nil
    runtime.restoredPickupCount += 1
    runtime.ownDrops[instance] = nil
    runtime.stopWatchingGroundItem(instance)

    return results
end

Env.__LenoraDrops.start = function()
    local runtime = Env.__LenoraDrops
    if runtime.initialized then return true end

    runtime.debris = workspace:FindFirstChild("Debris")
    if not runtime.debris then
        return false
    end

    table.clear(runtime.weaponNames)
    for _, weapon in ipairs(ReplicatedStorage.Weapons:GetChildren()) do
        runtime.weaponNames[weapon.Name] = true
    end

    local function registerDirectPart(child)
        if child:IsA("BasePart")
            and child.Parent == runtime.debris
            and runtime.weaponNames[tostring(child.Name or "")] then
            runtime.directParts[child] = true

            local pending = runtime.pending
            if type(pending) == "table"
                and tostring(child.Name or "") == pending.weaponName
                and not pending.before[child] then
                pending.candidates[child] = true
                task.defer(function()
                    if runtime.pending == pending then
                        runtime.finishPendingDrop(false)
                    end
                end)
            end
        end
    end

    for _, child in ipairs(runtime.debris:GetChildren()) do
        registerDirectPart(child)
    end

    runtime.connections[#runtime.connections + 1] =
        runtime.debris.ChildAdded:Connect(function(child)
            registerDirectPart(child)
        end)

    runtime.connections[#runtime.connections + 1] =
        runtime.debris.ChildRemoved:Connect(function(child)
            runtime.directParts[child] = nil
            runtime.ownDrops[child] = nil
            runtime.stopWatchingGroundItem(child)
        end)

    runtime.connections[#runtime.connections + 1] =
        LocalPlayer.ChildAdded:Connect(function(child)
            if child.Name ~= "DROPPED" then return end
            local pending = runtime.pending
            if type(pending) ~= "table" then return end
            pending.acknowledged = true
            pending.marker = child
            task.defer(function()
                if runtime.pending == pending then
                    runtime.finishPendingDrop(false)
                end
            end)
        end)

    runtime.connections[#runtime.connections + 1] =
        LocalPlayer.ChildRemoved:Connect(function(child)
            if child.Name ~= "DROPPED" then return end
            local pending = runtime.pending
            if type(pending) ~= "table" then return end
            if pending.marker == nil or pending.marker == child then
                pending.acknowledged = true
                pending.markerRemoved = true
                task.delay(0.05, function()
                    if runtime.pending == pending then
                        runtime.finishPendingDrop(false)
                    end
                end)
            end
        end)

    runtime.connections[#runtime.connections + 1] =
        LocalPlayer.CharacterAdded:Connect(function()
            table.clear(runtime.heldSlotState)
            table.clear(runtime.foreignHeldWeaponNames)
            runtime.pending = nil
            runtime.generation += 1
        end)

    runtime.findClientEnvironment()
    task.spawn(function()
        for _ = 1, 20 do
            if Unloaded or type(runtime.clientEnvironment) == "table" then
                break
            end
            runtime.findClientEnvironment()
            task.wait(0.25)
        end
    end)

    runtime.initialized = true
    return true
end

Env.__LenoraDrops.start()

getgenv().GetLenoraDroppedSkinState = function()
    local runtime = Env.__LenoraDrops
    local ownDropCount = 0
    local foreignHeldCount = 0
    for _ in pairs(runtime.ownDrops) do ownDropCount += 1 end
    for _ in pairs(runtime.foreignHeldWeaponNames) do foreignHeldCount += 1 end

    return {
        exactIdentity = true,
        directDebrisBasePartOnly = true,
        pending = type(runtime.pending) == "table",
        trackedOwnDrops = ownDropCount,
        foreignHeldWeapons = foreignHeldCount,
        exactDropCount = runtime.exactDropCount,
        ambiguousDropCount = runtime.ambiguousDropCount,
        nativePickupCount = runtime.nativePickupCount,
        restoredPickupCount = runtime.restoredPickupCount,
        clientEnvironmentReady = type(runtime.clientEnvironment) == "table",
    }
end

-- Pistol switch

Env.__LenoraPistolSwitch = {
    generation = 0,
    rebuildGeneration = 0,
    pending = nil,
}

Env.__LenoraPistolSwitch.isSupportedPistol = function(base)
    return base == "USP" or base == "P2000"
end

Env.__LenoraPistolSwitch.getSelectedPistol = function(loadout)
    if type(loadout) ~= "table" then return nil end
    if loadout.USPOver == true then return "USP" end
    if loadout.USPOver == false then return "P2000" end
    return nil
end

Env.__LenoraPistolSwitch.beginSwitch = function(record)
    if type(record) ~= "table" or type(record[1]) ~= "string" or record[1] == "" then
        return nil
    end

    local base = getItemBase(record[1])
    if not Env.__LenoraPistolSwitch.isSupportedPistol(base) then
        return nil
    end

    Env.__LenoraPistolSwitch.generation += 1
    local generation = Env.__LenoraPistolSwitch.generation
    local loadout = GameData and GameData.GetData and GameData.GetData("CTLoadout")
    local pending = {
        generation = generation,
        base = base,
        record = copyItem(record),
        alreadySelected = Env.__LenoraPistolSwitch.getSelectedPistol(loadout) == base,
    }
    Env.__LenoraPistolSwitch.pending = pending

    task.delay(4, function()
        local current = Env.__LenoraPistolSwitch.pending
        if current and current.generation == generation then
            Env.__LenoraPistolSwitch.pending = nil
        end
    end)

    return pending
end

Env.__LenoraPistolSwitch.refreshAfterSwitch = function(base, record)
    if not Env.__LenoraPistolSwitch.isSupportedPistol(base) then
        return false
    end
    if type(record) ~= "table" or type(record[1]) ~= "string" or getItemBase(record[1]) ~= base then
        return false
    end

    Env.__LenoraPistolSwitch.rebuildGeneration += 1
    local generation = Env.__LenoraPistolSwitch.rebuildGeneration
    local expected = cleanItem(record)

    task.defer(function()
        if Unloaded
            or Env.__LenoraPistolSwitch.rebuildGeneration ~= generation then
            return
        end

        local loadout = GameData and GameData.GetData and GameData.GetData("CTLoadout")
        if Env.__LenoraPistolSwitch.getSelectedPistol(loadout) ~= base then
            return
        end

        CTItems[base] = copyItem(expected)
        setTeamLoadoutItem("CT", base, expected)

        local tool = getHeldWeaponName()
        if tool ~= "USP" and tool ~= "P2000" then
            return
        end

        local character = Players.LocalPlayer and Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return
        end

        local events = ReplicatedStorage:FindFirstChild("Events")
        local resetRemote = events and events:FindFirstChild("resetweapons")
        if not resetRemote or not resetRemote:IsA("RemoteEvent") then
            return
        end

        local ok, err = pcall(function()
            firesignal(resetRemote.OnClientEvent)
        end)
        if not ok then
            warn("[Lenora] Could not refresh the selected CT pistol: " .. tostring(err))
        end
    end)

    return true
end

-- Hooks

-- __namecall hook
do
local namecallState = rawget(Env, "__LenoraNamecallHook")
if type(namecallState) ~= "table"
    or type(namecallState.wrapper) ~= "function"
    or type(namecallState.original) ~= "function" then
    namecallState = {
        original = nil,
        wrapper = nil,
        handler = nil,
        token = nil,
    }

    local wrapper
    wrapper = newcclosure(function(self, ...)
        local state = rawget(getgenv(), "__LenoraNamecallHook")
        local original = state and state.original
        if type(original) ~= "function" then
            return nil
        end

        local handler = state.handler
        if type(handler) == "function" then
            local method = getnamecallmethod()
            local args = table.pack(...)
            return handler(self, method, args, original)
        end

        return original(self, ...)
    end)

    namecallState.wrapper = wrapper
    namecallState.original = hookmetamethod(game, "__namecall", wrapper)
    Env.__LenoraNamecallHook = namecallState
end

local namecallToken = {}
namecallState.token = namecallToken
namecallState.handler = newcclosure(function(self, method, args, originalNamecall)
    if Unloaded
        or (method ~= "FireServer" and method ~= "InvokeServer") then
        return originalNamecall(self, table.unpack(args, 1, args.n))
    end

    local mirrorSide
    local mirrorSlot
    local mirrorRecord
    local pistolRequest
    local dropGeneration
    local pickupContext
    local isDropCall = method == "FireServer"
        and typeof(self) == "Instance"
        and self.Parent == eventsFolder
        and self.Name == "Drop"
    local isPickupCall = method == "InvokeServer"
        and typeof(self) == "Instance"
        and self.Parent == eventsFolder
        and self.Name == "PickUp"

    if method == "FireServer" then
        if isCurrentDataEvent(self) then
            local payload = args[1]
            if type(payload) == "table" and payload[1] == "EquipItem" then
                local record = payload[4]
                if type(record) == "table"
                    and type(record[1]) == "string"
                    and record[1] ~= "" then
                    mirrorSide = payload[2]
                    mirrorSlot = payload[3]
                    mirrorRecord = copyItem(record)

                    local base = getItemBase(record[1])
                    if Env.__LenoraPistolSwitch.isSupportedPistol(base)
                        and (mirrorSide == "CT" or mirrorSide == "Both") then
                        pistolRequest =
                            Env.__LenoraPistolSwitch.beginSwitch(record)

                        local nativePayload = deepCopy(payload)
                        nativePayload[2] = "CT"
                        nativePayload[3] = base
                        nativePayload[4] = { base .. "_Stock" }
                        args[1] = nativePayload

                        mirrorSide = "CT"
                        mirrorSlot = base
                    end
                end
            end
        elseif typeof(self) == "Instance" and self.Name == "ApplyGun" then
            args[1] = KNIFE_MODEL_REMAP[args[1]] or args[1]
        end

        if isDropCall then
            dropGeneration =
                Env.__LenoraDrops.beginDrop(
                    args[1],
                    args[2]
                )
        end
    end

    if isPickupCall then
        pickupContext = Env.__LenoraDrops.capturePickup(args[1])
    end

    local results = table.pack(
        originalNamecall(self, table.unpack(args, 1, args.n))
    )

    if isDropCall and dropGeneration ~= nil then
        Env.__LenoraDrops.finishDrop(
            args[1],
            args[2],
            dropGeneration
        )
    elseif isPickupCall then
        results =
            Env.__LenoraDrops.handlePickupResult(
                args[1],
                results,
                pickupContext
            )
    end

    if mirrorRecord ~= nil then
        task.defer(function()
            if Unloaded then return end
            local ok, err = pcall(equipItemLocally, mirrorSide, mirrorSlot, mirrorRecord)
            if not ok then
                warn("[Lenora] Could not mirror the selected inventory item: " .. tostring(err))
                return
            end

            if pistolRequest and pistolRequest.alreadySelected then
                local pending = Env.__LenoraPistolSwitch.pending
                if pending and pending.generation == pistolRequest.generation then
                    Env.__LenoraPistolSwitch.pending = nil
                end
                Env.__LenoraPistolSwitch.refreshAfterSwitch(
                    pistolRequest.base,
                    pistolRequest.record
                )
            end
        end)
    end

    return table.unpack(results, 1, results.n)
end)

removeNamecallHook = function()
    local state = rawget(Env, "__LenoraNamecallHook")
    if type(state) == "table" and state.token == namecallToken then
        state.handler = nil
        state.token = nil
    end
end
end

-- Loadout sync

local addSkinsToInventory  -- forward declaration (defined below)
local syncGeneration = {
    Inventory = 0,
    CTLoadout = 0,
    TLoadout = 0,
}

local function hasLenoraOverride(itemId)
    itemId = tostring(itemId or "")
    return StatCounts[itemId] ~= nil or NormalItems[itemId] == true
end

local function queueInventorySync(patch)
    if PatchDepth.Inventory > 0 then return end

    local touchedIds = {}
    if type(patch) == "table" then
        for _, value in pairs(patch) do
            if type(value) == "table" and type(value[1]) == "string" then
                touchedIds[value[1]] = true
            end
        end
    end

    syncGeneration.Inventory += 1
    local generation = syncGeneration.Inventory
    task.defer(function()
        if Unloaded or syncGeneration.Inventory ~= generation then return end

        if type(Env.__LenoraInventory.noteInventoryPatch) == "function" then
            Env.__LenoraInventory.noteInventoryPatch(touchedIds)
        end

        for itemId in pairs(touchedIds) do
            if hasLenoraOverride(itemId) then
                fixStatTrakItem(itemId, true)
            end
        end

        if Env.__LenoraInventory.hidden then
            if type(Env.__LenoraInventory.applyHiddenInventory) == "function" then
                Env.__LenoraInventory.applyHiddenInventory()
            end
        elseif type(addSkinsToInventory) == "function" then
            addSkinsToInventory()
        end
    end)
end

local function queueLoadoutSync(label, patch)
    if PatchDepth[label] > 0 or type(patch) ~= "table" then return end

    local team = label == "CTLoadout" and "CT" or (label == "TLoadout" and "T" or nil)
    if not team then return end
    local desired = team == "CT" and CTItems or TItems

    local touchedSlots = {}
    local uspSelectorTouched = false
    for rawSlot, incoming in pairs(patch) do
        if type(incoming) == "table" and incoming[1] then
            touchedSlots[normalizeSlot(rawSlot, incoming[1])] = true
        elseif team == "CT" and rawSlot == "USPOver" then
            uspSelectorTouched = true
            touchedSlots.USP = true
            touchedSlots.P2000 = true
        elseif type(rawSlot) == "string" and rawSlot:sub(-4) == "Over" then
            local baseSlot = rawSlot:sub(1, -5)
            if baseSlot == "Knife" or baseSlot == "Glove" or desired[baseSlot] then
                touchedSlots[baseSlot] = true
            end
        end
    end
    if next(touchedSlots) == nil then return end

    syncGeneration[label] += 1
    local generation = syncGeneration[label]
    task.defer(function()
        if Unloaded or syncGeneration[label] ~= generation then return end

        local live = GameData.GetData(label)
        if type(live) ~= "table" then return end

        local confirmedPistol
        if team == "CT" and uspSelectorTouched then
            local pending = Env.__LenoraPistolSwitch.pending
            local getSelectedPistol = Env.__LenoraPistolSwitch.getSelectedPistol(live)
            if pending and pending.base == getSelectedPistol then
                CTItems[getSelectedPistol] = copyItem(pending.record)
                confirmedPistol = pending
            end
        end

        for slot in pairs(touchedSlots) do
            local expected = desired[slot]
            if type(expected) == "table" and expected[1] and not sameItem(live[slot], expected) then
                setTeamLoadoutItem(team, slot, expected)
                rebuildHeldWeapon(expected, false)
            elseif type(live[slot]) == "table" and live[slot][1] and not expected then
            end
        end

        if confirmedPistol then
            local pending = Env.__LenoraPistolSwitch.pending
            if pending and pending.generation == confirmedPistol.generation then
                Env.__LenoraPistolSwitch.pending = nil
            end
            Env.__LenoraPistolSwitch.refreshAfterSwitch(
                confirmedPistol.base,
                confirmedPistol.record
            )
        end

        if Env.__LenoraInventory.hidden
            and type(Env.__LenoraInventory.applyHiddenInventory) == "function" then
            task.defer(Env.__LenoraInventory.applyHiddenInventory)
        end
    end)
end

trackConnection(LoadoutEvent.OnClientEvent:Connect(function(label, patch)
    if Unloaded then return end
    if label == "Inventory" then
        queueInventorySync(patch)
    elseif label == "CTLoadout" or label == "TLoadout" then
        queueLoadoutSync(label, patch)
    end
end))

-- StatTrak sync

local function syncStatTrakCounter()
    if Unloaded
        or not Env.__LenoraCanApplyStatTrak() then
        return
    end
    local record, team, slot = getHeldItemRecord()
    if type(record) ~= "table" or not record[1] or not team or not slot then return end

    local itemId = getItemId(record)
    if not hasStatTrak(record) or NormalItems[itemId] == true then
        updateWeaponCounter(getCurrentViewmodel(), nil, itemId)
        return
    end

    local maintained = getTrackedKillCount(itemId, record)
    if maintained == nil then
        maintained = math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
    end

    local value = getTeamSkinValue(team, slot)
    local countValue = value and value:FindFirstChild("StatTrak")
        and value.StatTrak:FindFirstChild("Count")

    if countValue and countValue:IsA("IntValue") then
        local observed = math.clamp(math.floor(tonumber(countValue.Value) or 0), 0, 999999)
        local count = math.max(maintained, observed)

        if observed < count then
            localCountWriteTargets[countValue] = count
            countValue.Value = count
        elseif observed > maintained then
            trackNativeKillCount(itemId, observed, false)
        end

        NormalItems[itemId] = nil
        StatCounts[itemId] = count
        lastObservedNativeCount[itemId] = count
        watchKillCounter(countValue, itemId)
        updateWeaponCounter(getCurrentViewmodel(), count, itemId)
        if fixStatTrakItem then fixStatTrakItem(itemId, true) end
        saveConfig()
    else
        local corrected = copyItem(record)
        corrected[4] = maintained
        setSkinFolderItem(team, slot, corrected)
        updateWeaponCounter(getCurrentViewmodel(), maintained, itemId)
    end
end

if StatRemote and StatRemote:IsA("RemoteEvent") then
    trackConnection(StatRemote.OnClientEvent:Connect(function()
        task.defer(syncStatTrakCounter)
        task.delay(0.05, syncStatTrakCounter)
    end))
end

do
local cameraChildConnection = nil
local function bindCurrentCamera(camera)
    if typeof(cameraChildConnection) == "RBXScriptConnection" then
        pcall(function() cameraChildConnection:Disconnect() end)
        cameraChildConnection = nil
    end

    if not camera or not camera:IsA("Camera") then return end
    cameraChildConnection = camera.ChildAdded:Connect(function(child)
        if child.Name == "Arms" then
            task.defer(function()
                if isCurrentRuntime() then
                    syncStatTrakCounter()
                end
            end)
        end
    end)
    trackConnection(cameraChildConnection)
end

bindCurrentCamera(workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera"))
trackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if isCurrentRuntime() then
        bindCurrentCamera(workspace.CurrentCamera)
    end
end))
end

-- Killfeed
do

local KILL_SYNC_GRACE = 0.75
local NATIVE_CREDIT_LIFETIME = 1.25
local KILL_EVENT_LIFETIME = 20

local KILLFEED_ALIASES = {
    ["glock18"] = "glock",
    ["m4a1s"] = "m4a1",
    ["usps"] = "usp",
    ["cz75auto"] = "cz",
    ["r8revolver"] = "r8",
    ["44magnum"] = "r8",
    ["sg553"] = "sg",
    ["galilar"] = "galil",
    ["galilsar"] = "galil",
    ["ssg08"] = "scout",
    ["xm1014"] = "xm",
    ["ump45"] = "ump",
    ["ppbizon"] = "bizon",
}

local KNIFE_KILLFEED_NAMES = {
    knife = true,
    ctknife = true,
    tknife = true,
    melee = true,
}

local function normalizeWeaponToken(value)
    local token = tostring(value or ""):lower():gsub("[^%w]", "")
    return KILLFEED_ALIASES[token] or token
end

local function recordMatchesWeapon(record, weaponToken)
    if type(record) ~= "table" or type(record[1]) ~= "string" then
        return false
    end

    local itemId = tostring(record[1])
    local base = getItemBase(itemId)
    if GLOVE_NAME_SET[base] then
        return false
    end

    if normalizeWeaponToken(base) == weaponToken then
        return true
    end

    if isKnifeItem(itemId) then
        local nativeBase = KNIFE_MODEL_REMAP[base] or base
        return normalizeWeaponToken(nativeBase) == weaponToken
            or KNIFE_KILLFEED_NAMES[weaponToken] == true
    end

    return false
end

local function findKillCreditRecord(weaponName)
    local team = getCurrentTeam()
    if not team then return nil end

    local loadout = GameData and GameData.GetData and GameData.GetData(team .. "Loadout")
    if type(loadout) ~= "table" then return nil end

    local weaponToken = normalizeWeaponToken(weaponName)
    if weaponToken == "" then return nil end

    local match = nil
    for rawSlot, record in pairs(loadout) do
        if type(record) == "table" and record[1] then
            local itemId = getItemId(record)
            local slot = normalizeSlot(rawSlot, itemId)
            local hasStatTrak = hasStatTrak(record)
                or StatCounts[itemId] ~= nil

            if slot ~= "Glove"
                and hasStatTrak
                and supportsStatTrak(itemId)
                and recordMatchesWeapon(record, weaponToken) then
                local candidate = {
                    itemId = itemId,
                    team = team,
                    slot = slot,
                    record = copyItem(record),
                }

                if slot == "Knife" then
                    return candidate
                end

                if match ~= nil then
                    return nil
                end
                match = candidate
            end
        end
    end

    return match
end

local function getInventoryKillCount(itemId)
    local inventory = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(inventory) ~= "table" then return nil end

    for _, record in pairs(inventory) do
        if hasStatTrak(record) and tostring(record[1] or "") == itemId then
            return math.clamp(math.floor(tonumber(record[4]) or 0), 0, 999999)
        end
    end
    return nil
end

local function getEffectiveKillCount(itemId, team, slot)
    local best = tonumber(StatCounts[itemId])

    local inventoryCount = getInventoryKillCount(itemId)
    if inventoryCount ~= nil then
        best = best ~= nil and math.max(best, inventoryCount) or inventoryCount
    end

    local loadoutRecord = getEquippedRecord(team, slot)
    if hasStatTrak(loadoutRecord) and getItemId(loadoutRecord) == itemId then
        local loadoutCount = math.clamp(math.floor(tonumber(loadoutRecord[4]) or 0), 0, 999999)
        best = best ~= nil and math.max(best, loadoutCount) or loadoutCount
    end

    local slotValue = getTeamSkinValue(team, slot, false)
    local statFolder = slotValue and slotValue:FindFirstChild("StatTrak")
    local countValue = statFolder and statFolder:FindFirstChild("Count")
    if countValue and countValue:IsA("IntValue") then
        local folderCount = math.clamp(math.floor(tonumber(countValue.Value) or 0), 0, 999999)
        best = best ~= nil and math.max(best, folderCount) or folderCount
    end

    return math.clamp(math.floor(tonumber(best) or 0), 0, 999999)
end

local function useNativeKillCredit(itemId)
    local credit = nativeCountCredits[itemId]
    if not credit then return false end

    if credit.expires <= os.clock() or credit.count <= 0 then
        nativeCountCredits[itemId] = nil
        return false
    end

    credit.count -= 1
    if credit.count <= 0 then
        nativeCountCredits[itemId] = nil
    end
    return true
end

recordNativeKillIncrease = function(itemId, amount)
    itemId = tostring(itemId or "")
    amount = math.max(0, math.floor(tonumber(amount) or 0))
    if itemId == "" or amount <= 0 then return end

    if pendingStatTrakKills[itemId] then
        return
    end

    local now = os.clock()
    local credit = nativeCountCredits[itemId]
    if not credit or credit.expires <= now then
        credit = { count = 0, expires = now + NATIVE_CREDIT_LIFETIME }
        nativeCountCredits[itemId] = credit
    end
    credit.count += amount
    credit.expires = now + NATIVE_CREDIT_LIFETIME
end

local function queueKillCountUpdate(resolved)
    local itemId = resolved.itemId

    if useNativeKillCredit(itemId) then
        return
    end

    local pending = pendingStatTrakKills[itemId]
    if not pending then
        pending = {
            baseline = getEffectiveKillCount(itemId, resolved.team, resolved.slot),
            amount = 0,
            generation = 0,
            team = resolved.team,
            slot = resolved.slot,
        }
        pendingStatTrakKills[itemId] = pending
    end

    pending.amount += 1
    pending.generation += 1
    pending.team = resolved.team
    pending.slot = resolved.slot
    local generation = pending.generation

    task.delay(KILL_SYNC_GRACE, function()
        if Unloaded then return end

        local livePending = pendingStatTrakKills[itemId]
        if not livePending or livePending.generation ~= generation then
            return
        end
        pendingStatTrakKills[itemId] = nil

        if StatCounts[itemId] == nil
            or NormalItems[itemId] == true then
            return
        end

        local current = getEffectiveKillCount(itemId, livePending.team, livePending.slot)
        local nativeDelta = math.max(0, current - livePending.baseline)
        local missing = math.max(0, livePending.amount - nativeDelta)
        if missing <= 0 then
            return
        end

        local target = math.clamp(current + missing, 0, 999999)
        NormalItems[itemId] = nil
        StatCounts[itemId] = target
        lastObservedNativeCount[itemId] = target

        fixStatTrakItem(itemId, true)
        saveConfig()
    end)
end

local function getKillEventKey(payload)
    return table.concat({
        tostring(payload.killer or ""),
        tostring(payload.victim or ""),
        tostring(payload.weapon or ""),
        tostring(payload.time or ""),
    }, "\0")
end

local function handleKillfeedEvent(payload)
    if Unloaded or type(payload) ~= "table" then return end

    local localName = tostring(LocalPlayer and LocalPlayer.Name or "")
    local killer = tostring(payload.killer or "")
    local victim = tostring(payload.victim or "")
    local weapon = payload.weapon

    if localName == ""
        or killer ~= localName
        or victim == ""
        or victim == localName
        or type(weapon) ~= "string"
        or weapon == "" then
        return
    end

    local now = os.clock()
    for key, expires in pairs(processedKillEvents) do
        if expires <= now then
            processedKillEvents[key] = nil
        end
    end

    local key = getKillEventKey(payload)
    if processedKillEvents[key] then return end
    processedKillEvents[key] = now + KILL_EVENT_LIFETIME

    local resolved = findKillCreditRecord(weapon)
    if resolved then
        queueKillCountUpdate(resolved)
    end
end

local killfeedRemote = nil
local killfeedConnection = nil
local function connectKillfeed(remote)
    if remote == killfeedRemote and typeof(killfeedConnection) == "RBXScriptConnection" then
        return true
    end
    if not remote or not remote:IsA("RemoteEvent") then return false end

    if typeof(killfeedConnection) == "RBXScriptConnection" then
        pcall(function() killfeedConnection:Disconnect() end)
    end

    killfeedRemote = remote
    killfeedConnection = remote.OnClientEvent:Connect(handleKillfeedEvent)
    trackConnection(killfeedConnection)
    return true
end

local initialKillfeedRemote = eventsFolder and eventsFolder:FindFirstChild("AddToKillfeed")
if not connectKillfeed(initialKillfeedRemote) then
    warn("[Lenora] Kill tracking is unavailable because Events.AddToKillfeed was not found.")
end

trackConnection(eventsFolder.ChildAdded:Connect(function(child)
    if child.Name == "AddToKillfeed" and child:IsA("RemoteEvent") then
        connectKillfeed(child)
    end
end))

end

-- Catalog

local skinCatalog = nil

local function buildCatalog()
    if skinCatalog then return skinCatalog end

    local list     = {}
    local foundSet = {}

    local elapsed = 0
    while #SkinRoot:GetChildren() < 5 and elapsed < 15 do
        task.wait(0.2)
        elapsed += 0.2
    end

    for _, weaponFolder in SkinRoot:GetChildren() do
        if not weaponFolder:IsA("Folder") then continue end
        for _, skinFolder in weaponFolder:GetChildren() do
            if not skinFolder:IsA("Folder") then continue end
            local itemId = weaponFolder.Name .. "_" .. skinFolder.Name
            if not foundSet[itemId] then
                foundSet[itemId] = true
                table.insert(list, { itemId })
            end
        end
    end

    if GloveRoot then
        for _, typeFolder in GloveRoot:GetChildren() do
            if not typeFolder:IsA("Folder") then continue end
            for _, skinFolder in typeFolder:GetChildren() do
                if not (skinFolder:IsA("Folder") or skinFolder:IsA("Model")) then continue end
                local itemId = typeFolder.Name .. "_" .. skinFolder.Name
                if not foundSet[itemId] then
                    foundSet[itemId] = true
                    table.insert(list, { itemId })
                end
            end
        end
    end

    for _, itemId in BACKUP_SKIN_CATALOG do
        if not foundSet[itemId] then
            foundSet[itemId] = true
            table.insert(list, { itemId })
        end
    end

    skinCatalog = list
    return list
end

-- Inventory state

function Env.__LenoraInventory.getSessionKey()
    return table.concat({
        tostring(game.PlaceId),
        tostring(game.JobId),
        tostring(LocalPlayer and LocalPlayer.UserId or 0),
    }, ":")
end

function Env.__LenoraInventory.rememberServerItem(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" then return end

    Env.__LenoraInventory.serverItemIds[itemId] = true
    Env.__LenoraInventory.addedItemIds[itemId] = nil

    if type(Env.__LenoraInventory.inventorySource) == "table" then
        Env.__LenoraInventory.inventorySource.serverItemIds = Env.__LenoraInventory.serverItemIds
        Env.__LenoraInventory.inventorySource.addedItemIds = Env.__LenoraInventory.addedItemIds
    end
end

function Env.__LenoraInventory.rememberAddedItem(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" or Env.__LenoraInventory.serverItemIds[itemId] then return end

    Env.__LenoraInventory.addedItemIds[itemId] = true
    if type(Env.__LenoraInventory.inventorySource) == "table" then
        Env.__LenoraInventory.inventorySource.addedItemIds = Env.__LenoraInventory.addedItemIds
    end
end

Env.__LenoraInventory.captureOriginalInventory = function()
    if Env.__LenoraInventory.ready then
        return true
    end

    local current = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(current) ~= "table" then
        return false
    end

    local sessionKey = Env.__LenoraInventory.getSessionKey()
    local persisted = rawget(Env, "__LenoraInventorySource")
        or rawget(Env, "__CounterBloxCustomInventoryProvenance")

    if type(persisted) == "table" then
        persisted.serverItemIds = persisted.serverItemIds or persisted.serverOwnedItemIds
        persisted.addedItemIds = persisted.addedItemIds or persisted.injectedItemIds
        persisted.protectedItemIds = persisted.protectedItemIds or persisted.hiddenSessionProtectedItemIds
        persisted.protectedItemRecords = persisted.protectedItemRecords or persisted.hiddenSessionProtectedRecords
    end

    if type(persisted) ~= "table" or persisted.sessionKey ~= sessionKey then
        persisted = {
            version = 3,
            sessionKey = sessionKey,
            serverItemIds = {},
            addedItemIds = {},
            protectedItemIds = {},
            protectedItemRecords = {},
            baselineInventory = deepCopy(current),
            hidden = false,
        }

        for _, record in pairs(current) do
            if type(record) == "table" and type(record[1]) == "string"
                and record[1] ~= "" then
                persisted.serverItemIds[record[1]] = true
            end
        end

        Env.__LenoraInventorySource =
            persisted
    else
        persisted.serverItemIds =
            type(persisted.serverItemIds) == "table"
                and persisted.serverItemIds or {}
        persisted.addedItemIds =
            type(persisted.addedItemIds) == "table"
                and persisted.addedItemIds or {}
        persisted.protectedItemIds =
            type(persisted.protectedItemIds) == "table"
                and persisted.protectedItemIds or {}
        persisted.protectedItemRecords =
            type(persisted.protectedItemRecords) == "table"
                and persisted.protectedItemRecords or {}

        local stateVersion = tonumber(persisted.version) or 0
        if stateVersion < 3 then
            persisted.version = 3
            persisted.hidden = false
            persisted.protectedItemIds = {}
            persisted.protectedItemRecords = {}
        end
    end

    if persisted.hidden ~= true then
        persisted.protectedItemIds = {}
        persisted.protectedItemRecords = {}
    end

    Env.__LenoraInventorySource = persisted
    Env.__CounterBloxCustomInventoryProvenance = nil
    Env.__LenoraInventory.inventorySource = persisted
    Env.__LenoraInventory.serverItemIds = persisted.serverItemIds
    Env.__LenoraInventory.addedItemIds = persisted.addedItemIds
    Env.__LenoraInventory.protectedItemIds = persisted.protectedItemIds
    Env.__LenoraInventory.protectedItemRecords = persisted.protectedItemRecords
    Env.__LenoraInventory.hidden = persisted.hidden == true
    Env.__LenoraInventory.ready = true
    return true
end

Env.__LenoraInventory.noteInventoryPatch = function(touchedIds)
    if not Env.__LenoraInventory.captureOriginalInventory() then return end

    local current = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(current) ~= "table" then return end
    local liveOwned = getOwnedItems(current)

    if type(touchedIds) == "table" then
        for itemId in pairs(touchedIds) do
            if liveOwned[itemId] then
                Env.__LenoraInventory.rememberServerItem(itemId)
            end
        end
    end

    for itemId in pairs(liveOwned) do
        if not Env.__LenoraInventory.addedItemIds[itemId] then
            Env.__LenoraInventory.rememberServerItem(itemId)
        end
    end
end

Env.__LenoraInventory.getEquippedItemIds = function()
    local equipped = {}

    local function collectRecord(record)
        if type(record) == "table" and type(record[1]) == "string"
            and record[1] ~= "" then
            equipped[record[1]] = true
        end
    end

    local function collectLoadout(loadout)
        if type(loadout) ~= "table" then return end
        for _, record in pairs(loadout) do
            collectRecord(record)
        end
    end

    collectLoadout(CTItems)
    collectLoadout(TItems)
    collectLoadout(GameData and GameData.GetData and GameData.GetData("CTLoadout"))
    collectLoadout(GameData and GameData.GetData and GameData.GetData("TLoadout"))

    if type(getHeldItemRecord) == "function" then
        local ok, record = pcall(getHeldItemRecord)
        if ok then collectRecord(record) end
    end

    return equipped
end

Env.__LenoraInventory.saveEquippedItemProtection = function()
    local state = Env.__LenoraInventory.inventorySource
    if type(state) ~= "table" then return end

    state.protectedItemIds =
        Env.__LenoraInventory.protectedItemIds
    state.protectedItemRecords =
        Env.__LenoraInventory.protectedItemRecords
end

Env.__LenoraInventory.clearEquippedItemProtection = function()
    Env.__LenoraInventory.protectedItemIds = {}
    Env.__LenoraInventory.protectedItemRecords = {}
    Env.__LenoraInventory.saveEquippedItemProtection()
end

Env.__LenoraInventory.rememberEquippedInjectedItems = function()
    if not Env.__LenoraInventory.captureOriginalInventory() then
        return false, 0
    end

    local equipped =
        Env.__LenoraInventory.getEquippedItemIds()
    local protectedIds = {}
    local protectedRecords = {}

    local function protectRecord(record)
        if type(record) ~= "table" or type(record[1]) ~= "string" then return end

        local itemId = record[1]
        if itemId == ""
            or equipped[itemId] ~= true
            or Env.__LenoraInventory.serverItemIds[itemId] == true
            or Env.__LenoraInventory.addedItemIds[itemId] ~= true then
            return
        end

        protectedIds[itemId] = true
        if protectedRecords[itemId] == nil then
            protectedRecords[itemId] = cleanItem(record)
        end
    end

    local inventory = GameData and GameData.GetData and GameData.GetData("Inventory")
    if type(inventory) == "table" then
        for _, record in pairs(inventory) do
            protectRecord(record)
        end
    end

    local function collectProtectedLoadoutRecords(loadout)
        if type(loadout) ~= "table" then return end
        for _, record in pairs(loadout) do
            protectRecord(record)
        end
    end

    collectProtectedLoadoutRecords(CTItems)
    collectProtectedLoadoutRecords(TItems)
    collectProtectedLoadoutRecords(GameData and GameData.GetData and GameData.GetData("CTLoadout"))
    collectProtectedLoadoutRecords(GameData and GameData.GetData and GameData.GetData("TLoadout"))

    if type(getHeldItemRecord) == "function" then
        local ok, record = pcall(getHeldItemRecord)
        if ok then protectRecord(record) end
    end

    Env.__LenoraInventory.protectedItemIds = protectedIds
    Env.__LenoraInventory.protectedItemRecords = protectedRecords
    Env.__LenoraInventory.saveEquippedItemProtection()

    local count = 0
    for _ in pairs(protectedIds) do count += 1 end
    return true, count
end

Env.__LenoraInventory.shouldKeepItemVisible = function(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" then return false end
    if not Env.__LenoraInventory.hidden then return true end
    if Env.__LenoraInventory.serverItemIds[itemId] then return true end
    if not Env.__LenoraInventory.addedItemIds[itemId] then return true end

    return Env.__LenoraInventory.protectedItemIds[itemId] == true
end

Env.__LenoraInventory.applyHiddenInventory = function()
    if Unloaded or not Env.__LenoraInventory.hidden then
        return false, false
    end
    if not Env.__LenoraInventory.captureOriginalInventory() then
        return false, false
    end

    local protectedIds =
        Env.__LenoraInventory.protectedItemIds
    local protectedRecords =
        Env.__LenoraInventory.protectedItemRecords

    return editData("Inventory", function(nextInventory)
        local metadata = {}
        local numericKeys = {}

        for key, value in pairs(nextInventory) do
            if type(key) == "number" then
                numericKeys[#numericKeys + 1] = key
            else
                metadata[key] = deepCopy(value)
            end
        end
        table.sort(numericKeys)

        local retained = {}
        local retainedIds = {}
        for _, key in ipairs(numericKeys) do
            local record = nextInventory[key]
            local itemId = type(record) == "table"
                and type(record[1]) == "string"
                and record[1] or nil

            local keep = itemId == nil
                or Env.__LenoraInventory.serverItemIds[itemId] == true
                or Env.__LenoraInventory.addedItemIds[itemId] ~= true
                or protectedIds[itemId] == true

            if keep then
                retained[#retained + 1] = deepCopy(record)
                if itemId then
                    retainedIds[itemId] = true
                    if protectedIds[itemId] == true then
                        protectedRecords[itemId] = cleanItem(record)
                    end
                end
            end
        end

        for itemId in pairs(protectedIds) do
            if not retainedIds[itemId] then
                local record = protectedRecords[itemId]
                if type(record) ~= "table" then
                    record = cleanItem(
                        makeInventoryItem({ itemId }))
                    protectedRecords[itemId] = copyItem(record)
                end
                retained[#retained + 1] = copyItem(record)
                retainedIds[itemId] = true
            end
        end

        table.clear(nextInventory)
        for key, value in pairs(metadata) do
            nextInventory[key] = value
        end
        for index, record in ipairs(retained) do
            nextInventory[index] = record
        end

        Env.__LenoraInventory.saveEquippedItemProtection()
    end)
end

Env.__LenoraInventory.keepItemVisible = function(itemId, preferredRecord)
    itemId = tostring(itemId or "")
    if itemId == "" then return false end
    if not Env.__LenoraInventory.captureOriginalInventory() then return false end

    if not Env.__LenoraInventory.serverItemIds[itemId] then
        Env.__LenoraInventory.rememberAddedItem(itemId)
    end

    local isInjected =
        Env.__LenoraInventory.addedItemIds[itemId] == true
    local isProtected =
        Env.__LenoraInventory.protectedItemIds[itemId] == true

    if Env.__LenoraInventory.hidden
        and isInjected and not isProtected
        and not Env.__LenoraInventory.serverItemIds[itemId] then
        return false
    end

    local record = type(preferredRecord) == "table"
        and cleanItem(preferredRecord)
        or cleanItem(makeInventoryItem({ itemId }))

    if isProtected then
        Env.__LenoraInventory.protectedItemRecords[itemId] =
            copyItem(record)
        Env.__LenoraInventory.saveEquippedItemProtection()
    end

    return editData("Inventory", function(nextInventory)
        local owned = getOwnedItems(nextInventory)
        if not owned[itemId] then
            nextInventory[#nextInventory + 1] = copyItem(record)
        end
    end)
end

-- Inventory injection

function addSkinsToInventory()
    if Unloaded then return false end
    if not Env.__LenoraInventory.captureOriginalInventory() then return false end

    if Env.__LenoraInventory.hidden then
        return Env.__LenoraInventory.applyHiddenInventory()
    end

    local allSkins = buildCatalog()
    return editData("Inventory", function(nextInventory)
        local owned = getOwnedItems(nextInventory)
        for _, item in ipairs(allSkins) do
            local itemId = type(item) == "table" and item[1] or nil
            if itemId and not owned[itemId] then
                nextInventory[#nextInventory + 1] = copyItem(
                    makeInventoryItem(item))
                Env.__LenoraInventory.rememberAddedItem(itemId)
                owned[itemId] = true
            end
        end
    end)
end

Env.__LenoraInventory.ensureAddedItem = function(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" then return false end
    if not Env.__LenoraInventory.captureOriginalInventory() then return false end

    if not Env.__LenoraInventory.serverItemIds[itemId] then
        Env.__LenoraInventory.rememberAddedItem(itemId)
    end

    return editData("Inventory", function(nextInventory)
        local owned = getOwnedItems(nextInventory)
        if not owned[itemId] then
            nextInventory[#nextInventory + 1] = copyItem(
                makeInventoryItem({ itemId }))
        end
    end)
end

-- New skins

function Env.__LenoraInventory.handleNewSkin(weaponFolder, skinFolder)
    if buildingLegacyAssets then return end
    if not skinFolder:IsA("Folder") then return end
    task.defer(function()
        if Unloaded then return end
        local current = GameData.GetData("Inventory")
        if not current or type(current) ~= "table" then return end
        local owned  = getOwnedItems(current)
        local itemId = weaponFolder.Name .. "_" .. skinFolder.Name
        if not owned[itemId] then
            if skinCatalog then
                table.insert(skinCatalog, { itemId })
            end
            if not Env.__LenoraInventory.hidden then
                Env.__LenoraInventory.ensureAddedItem(itemId)
            end
        end
    end)
end

function Env.__LenoraInventory.handleNewGlove(typeFolder, skinFolder)
    if buildingLegacyAssets then return end
    if not skinFolder:IsA("Folder") then return end
    task.defer(function()
        if Unloaded then return end
        local current = GameData.GetData("Inventory")
        if not current or type(current) ~= "table" then return end
        local owned  = getOwnedItems(current)
        local itemId = typeFolder.Name .. "_" .. skinFolder.Name
        if not owned[itemId] then
            if skinCatalog then
                table.insert(skinCatalog, { itemId })
            end
            if not Env.__LenoraInventory.hidden then
                Env.__LenoraInventory.ensureAddedItem(itemId)
            end
        end
    end)
end

trackConnection(SkinRoot.ChildAdded:Connect(function(weaponFolder)
    if buildingLegacyAssets or not isCurrentRuntime() then return end
    if not weaponFolder:IsA("Folder") then return end
    for _, child in weaponFolder:GetChildren() do
        Env.__LenoraInventory.handleNewSkin(weaponFolder, child)
    end
    trackConnection(weaponFolder.ChildAdded:Connect(function(child)
        if isCurrentRuntime() then
            Env.__LenoraInventory.handleNewSkin(weaponFolder, child)
        end
    end))
end))

if GloveRoot then
    trackConnection(GloveRoot.ChildAdded:Connect(function(typeFolder)
        if buildingLegacyAssets or not isCurrentRuntime() then return end
        if not typeFolder:IsA("Folder") then return end
        for _, child in typeFolder:GetChildren() do
            Env.__LenoraInventory.handleNewGlove(typeFolder, child)
        end
        trackConnection(typeFolder.ChildAdded:Connect(function(child)
            if isCurrentRuntime() then
                Env.__LenoraInventory.handleNewGlove(typeFolder, child)
            end
        end))
    end))
end

-- Hide / show

function Env.__LenoraInventory.saveHiddenSetting(value)
    if type(Env.__LenoraInventory.inventorySource) == "table" then
        Env.__LenoraInventory.inventorySource.hidden = value == true
    end
end

function Env.__LenoraInventory.hideInjectedItems()
    if Unloaded then return false end

    Env.__LenoraInventory.captureOriginalInventory()

    if Env.__LenoraInventory.hidden then
        task.defer(Env.__LenoraInventory.applyHiddenInventory)
        return true
    end
    if Env.__LenoraInventory.hideQueued then
        return true
    end

    Env.__LenoraInventory.visibilityVersion += 1
    local generation =
        Env.__LenoraInventory.visibilityVersion
    Env.__LenoraInventory.hideQueued = true

    task.spawn(function()
        local deadline = os.clock() + 30
        while not Unloaded and not Env.__LenoraInventory.ready
            and os.clock() < deadline do
            Env.__LenoraInventory.captureOriginalInventory()
            task.wait(0.1)
        end

        if Unloaded
            or Env.__LenoraInventory.visibilityVersion ~= generation then
            return
        end

        if not Env.__LenoraInventory.ready then
            Env.__LenoraInventory.hideQueued = false
            warn("[Lenora] The original inventory could not be saved before hiding injected items.")
            return
        end

        local captured = Env.__LenoraInventory.rememberEquippedInjectedItems()
        if not captured then
            Env.__LenoraInventory.hideQueued = false
            warn("[Lenora] Equipped injected items could not be protected for this session.")
            return
        end

        if Env.__LenoraInventory.visibilityVersion ~= generation then
            return
        end

        Env.__LenoraInventory.hidden = true
        Env.__LenoraInventory.hideQueued = false
        Env.__LenoraInventory.saveHiddenSetting(true)

        local ok = Env.__LenoraInventory.applyHiddenInventory()
        if not ok then
            Env.__LenoraInventory.hidden = false
            Env.__LenoraInventory.saveHiddenSetting(false)
            Env.__LenoraInventory.clearEquippedItemProtection()
            warn("[Lenora] The hidden inventory view could not be built.")
            return
        end
    end)

    return true
end

function Env.__LenoraInventory.showInjectedItems()
    if Unloaded then return false end

    Env.__LenoraInventory.visibilityVersion += 1
    Env.__LenoraInventory.hideQueued = false
    Env.__LenoraInventory.captureOriginalInventory()
    Env.__LenoraInventory.hidden = false
    Env.__LenoraInventory.saveHiddenSetting(false)
    Env.__LenoraInventory.clearEquippedItemProtection()

    task.spawn(function()
        local ok = addSkinsToInventory()
        if not ok then
            warn("[Lenora] The injected inventory could not be restored.")
            return
        end
    end)

    return true
end

getgenv().hideLenoraLoadout = Env.__LenoraInventory.hideInjectedItems
getgenv().showLenoraLoadout = Env.__LenoraInventory.showInjectedItems
getgenv().HideLenoraLoadout = Env.__LenoraInventory.hideInjectedItems
getgenv().ShowLenoraLoadout = Env.__LenoraInventory.showInjectedItems
getgenv().IsLenoraLoadoutHidden = function()
    return Env.__LenoraInventory.hidden
end
getgenv().GetLenoraInventorySource = function()
    Env.__LenoraInventory.captureOriginalInventory()
    local serverCount = 0
    local injectedCount = 0
    local protectedCount = 0
    for _ in pairs(Env.__LenoraInventory.serverItemIds) do
        serverCount += 1
    end

    for _ in pairs(Env.__LenoraInventory.addedItemIds) do
        injectedCount += 1
    end

    for _ in pairs(Env.__LenoraInventory.protectedItemIds) do
        protectedCount += 1
    end
    return {
        hidden = Env.__LenoraInventory.hidden,
        hideQueued = Env.__LenoraInventory.hideQueued,
        serverOwnedCount = serverCount,
        injectedCount = injectedCount,
        hiddenSessionProtectedCount = protectedCount,
        sessionKey = Env.__LenoraInventory.inventorySource and Env.__LenoraInventory.inventorySource.sessionKey or nil,
    }
end

-- Load config

local function loadConfig()
    local hasFile = false
    pcall(function()
        hasFile = isfile(SAVE_PATH)
    end)
    if not hasFile then return end

    local ok, raw = pcall(readfile, SAVE_PATH)
    if not ok or not raw or raw == "" then return end

    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(data) ~= "table" then return end

    if type(data.StatTrak) == "table" then
        for itemId, state in pairs(data.StatTrak) do
            if type(itemId) == "string" and type(state) == "table" then
                NormalItems[itemId] = nil
                StatOwners[itemId] = state.owner
                StatCounts[itemId] =
                    math.clamp(math.floor(tonumber(state.count) or 0), 0, 999999)
            end
        end
    end

    task.delay(1.5, function()
        if Unloaded then return end

        cleanStatTrak()

        if type(data.CT) == "table" then
            for slot, saved in pairs(data.CT) do
                local record = unpackItem(saved)
                local itemId = record and getItemId(record)
                if itemId then
                    slot = normalizeSlot(slot, itemId)
                    if slot == "Knife" and isStockTeamKnife(itemId) then
                        resetTeamKnife("CT")
                    else
                        if StatCounts[itemId] ~= nil then
                            record = makeStatTrakRecord(itemId, StatCounts[itemId])
                        end
                        equipItemLocally("CT", slot, record)
                    end
                end
            end
        end

        if type(data.T) == "table" then
            for slot, saved in pairs(data.T) do
                local record = unpackItem(saved)
                local itemId = record and getItemId(record)
                if itemId then
                    slot = normalizeSlot(slot, itemId)
                    if slot == "Knife" and isStockTeamKnife(itemId) then
                        resetTeamKnife("T")
                    else
                        if StatCounts[itemId] ~= nil then
                            record = makeStatTrakRecord(itemId, StatCounts[itemId])
                        end
                        equipItemLocally("T", slot, record)
                    end
                end
            end
        end
    end)
end

-- API

local function resetLoadout()
    local ctSlots, tSlots = {}, {}
    for slot in CTItems do
        table.insert(ctSlots, slot)
    end

    for slot in TItems do
        table.insert(tSlots, slot)
    end

    for _, slot in ctSlots do
        unequipItemLocally("CT", slot)
    end

    for _, slot in tSlots do
        unequipItemLocally("T", slot)
    end

    table.clear(StatCounts)
    table.clear(StatOwners)
    table.clear(NormalItems)
    table.clear(StatVersions)
    table.clear(lastObservedNativeCount)
    table.clear(pendingStatTrakKills)
    table.clear(nativeCountCredits)
    table.clear(processedKillEvents)
    pcall(writefile, SAVE_PATH, formatJson({ CT = {}, T = {}, StatTrak = {} }))
end

getgenv().ResetLenoraLoadout = resetLoadout

getgenv().SetLenoraStatTrak = function(itemId, count)
    itemId = tostring(itemId or "")
    if itemId == "" or not supportsStatTrak(itemId) then return false end
    pendingStatTrakKills[itemId] = nil
    nativeCountCredits[itemId] = nil
    NormalItems[itemId] = nil
    StatCounts[itemId] = math.clamp(math.floor(tonumber(count) or 0), 0, 999999)
    lastObservedNativeCount[itemId] = StatCounts[itemId]
    fixStatTrakItem(itemId)
    saveConfig()
    return true
end

getgenv().RemoveLenoraStatTrak = function(itemId)
    itemId = tostring(itemId or "")
    if itemId == "" then return false end
    pendingStatTrakKills[itemId] = nil
    nativeCountCredits[itemId] = nil
    lastObservedNativeCount[itemId] = nil
    StatCounts[itemId] = nil
    NormalItems[itemId] = true
    fixStatTrakItem(itemId)
    saveConfig()
    return true
end

getgenv().SwitchLenoraCTPistol = function(base)
    base = tostring(base or ""):upper():gsub("[^A-Z0-9]", "")
    if base == "USPS" then base = "USP" end
    if base ~= "USP" and base ~= "P2000" then
        return false
    end

    local record = CTItems[base]
    if type(record) ~= "table" or type(record[1]) ~= "string" or getItemBase(record[1]) ~= base then
        local loadout = GameData and GameData.GetData and GameData.GetData("CTLoadout")
        local liveRecord = type(loadout) == "table" and loadout[base] or nil
        record = type(liveRecord) == "table" and copyItem(liveRecord) or { base .. "_Stock" }
    end

    local event = getDataEvent(0.5)
    if not event then
        return false
    end

    local ok = pcall(function()
        event:FireServer({ "EquipItem", "CT", base, copyItem(record) })
    end)
    return ok
end

getgenv().ApplyLenoraSkinModel = function(model, itemId, worldModel, count, ownerValue)
    if typeof(model) ~= "Instance" or type(itemId) ~= "string" or itemId == "" then return false end
    local record
    if count ~= nil then
        record = {
            [1] = itemId,
            [2] = "StatTrak",
            [3] = ownerValue ~= nil and ownerValue
                or StatOwners[itemId]
                or (LocalPlayer and LocalPlayer.UserId or 0),
            [4] = math.clamp(math.floor(tonumber(count) or 0), 0, 999999),
        }
    else
        record = { itemId }
    end
    return mapSkinWithGame(model, record, worldModel == true)
end


-- Aliases
do
    local env = getgenv()
    env.hideLoadout = env.hideLenoraLoadout
    env.showLoadout = env.showLenoraLoadout
    env.HideLoadout = env.HideLenoraLoadout
    env.ShowLoadout = env.ShowLenoraLoadout
    env.HideLoadOut = env.HideLenoraLoadout
    env.ShowLoadOut = env.ShowLenoraLoadout
    env.IsCustomLoadoutHidden = env.IsLenoraLoadoutHidden
    env.GetCustomInventoryProvenance = env.GetLenoraInventorySource
    env.GetCustomDroppedSkinState = env.GetLenoraDroppedSkinState
    env.ResetLoadOut = env.ResetLenoraLoadout
    env.ResetCustomLoadout = env.ResetLenoraLoadout
    env.SetCustomStatTrak = env.SetLenoraStatTrak
    env.RemoveCustomStatTrak = env.RemoveLenoraStatTrak
    env.SwitchCustomCTPistol = env.SwitchLenoraCTPistol
    env.ApplyCustomSkinModel = env.ApplyLenoraSkinModel
end

-- Start

task.spawn(function()
    local elapsed = 0
    while isCurrentRuntime() and not GameData.GetData("Inventory") do
        task.wait(0.5)
        elapsed += 0.5
        if elapsed >= 30 then
            stopRuntime()
            return
        end
    end
    if not isCurrentRuntime() then return end

    if not checkPatch() then
        warn("[Lenora] Loadout syncing could not start: "
            .. tostring(patchApiError or "unknown Patch protocol failure"))
        stopRuntime()
        return
    end

    if not Env.__LenoraInventory.captureOriginalInventory() then
        warn("[Lenora] The original inventory could not be saved before skins were added.")
        stopRuntime()
        return
    end

    if not isCurrentRuntime() then return end
    buildLegacySkins()
    if not isCurrentRuntime() then return end
    findNativeSkinMapper(true)
    if not skinMapperHooked and not skinMapperWarningShown then
        skinMapperWarningShown = true
        warn("[Lenora] The skin mapper was unavailable, so its StatTrak guard was skipped.")
    end
    if not isCurrentRuntime() then return end
    readStatTrak()
    addSkinsToInventory()
    if not isCurrentRuntime() then return end
    cleanStatTrak()
    refreshInventory()
    loadConfig()
    if not isCurrentRuntime() then return end
    print("Lenora Successfully loaded")
    task.delay(0.5, function()
        if isCurrentRuntime() then syncStatTrakCounter() end
    end)

    task.defer(function()
        for _ = 1, 20 do
            if not isCurrentRuntime() then return end
            if addStatTrakButton() then
                break
            end
            task.wait(0.5)
        end
    end)
end)
