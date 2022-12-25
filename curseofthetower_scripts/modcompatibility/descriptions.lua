local descriptions = {}

descriptions.Collectibles = {
    ICE_CREAM = "Isaac's tears now spawn a trail of creep that damages enemies# {{ArrowDown}} -0.20 shotspeed down# {{ArrowDown}} -0.50 range down",
    KEROSENE = "{{Slow}} 50% chance to fire slowing tears that darken enemies# Darkened enemies can have a red flame spawned ontop of them when Kerosene is activated",
    PAIN_KILLERS = "{{Pill}} Take a random pill everytime you take damage, based on the current pool of pills",
    POKER_FACE = "{{BleedingOut}} Tears inflict bleed# {{Card}} 1% chance for a card to spawn upon hitting an enemy",
    POP_O_MATIC = "50% chance to either activate the {{Collectible386}} or {{Collectible285}} upon taking damage# 1% chance to instead activate the {{Collectible283}} # {{Warning}} Pop-O-Matic cannot be rerolled once picked up",
    TAROT_BOMBS = "{{Bomb}} Bombs have a 15% chance to activate your held tarot card upon exploding#{{Warning}}20% chance to consume your held tarot card if a bomb activates it#{{Card}}10% chance for bombs to spawn a random tarot card upon exploding# Can only spawn up to 10 cards per floor",
    WHITE_BELT = "{{Warning}} Champion enemies no longer spawn#{{ArrowDown}} -1 Damage down# Lowers enemy max health by 15%# Lowers boss max health by 5%",
    DARK_ORB = "Spawns a random quality 4 item upon pickup#{{Warning}}Quality 4 items are always rerolled, unless spawned through another Dark Orb#{{Warning}}Quality 3 items have a 35% chance to be rerolled",
    TERRORPORTER = "{{Warning}} Teleports Isaac in the position of the closest enemy# The chosen enemy will take 40 damage + Isaac's damage x3",
    LIL_RAINMAKER = "Fires homing, spectral tears in random nearby locations# Deals 3.5 damage per tear# Spawns a puddle of creep when colliding with an enemy",
    HEX_OF_THE_TOWER = "Enemies spawn a troll bomb upon death"
}

descriptions.Trinkets = {
    FREE_BLOOD = "{{Heart}} 10% chance for self inflicted damage to be prevented",
    MINTY_GUM = "{{Freezing}} 10% chance to fire an ice tear",
    THE_UNEXPECTED = "{{Warning}} 20% chance for an item to be rerolled into another item#The rerolled item will ignore the current item pool #{{Warning}} Story items can be received from this effect",
    REJECT_TECH = "10% chance to fire a technology laser when firing a tear"
}

descriptions.Pills = {
    WHO_AM_I = "Transforms you into a different character"
}

descriptions.Cards = {
    GIFT_CARD = "Halves the price of all items on the floor"
}

descriptions.BookOfVirtues = {
    KEROSENE = "#Spawns a wisp that has a 33% chance to fire slowing tears that darken enemies",
    TERRORPORTER = "#Spawns a stationary wisp in the location of the last telefragged enemy# Shoots tears that inflict fear"
}

descriptions.JudasBirthright = {
    KEROSENE = "#A rift that pulls in enemies will spawn in the same location as the flame",
    TERRORPORTER = "#The player explodes upon teleporting and shoots out 8 red flames"
}

descriptions.AbyssLocusts = {
    ICE_CREAM = "Pink locust that spawns a trail of creep",
    POKER_FACE = "White locust that inflicts bleed#{{ColorRed}} 1% chance to spawn a card upon hitting an enemy",
    WHITE_BELT = "White locust that instantly kills champion enemies",
    DARK_ORB = "Gold large locust that deals quadruple damage#{{ColorRed}} All quality 4 items are rerolled into quality 3 items",
    HEX_OF_THE_TOWER = "Dark purple locust that causes enemies it kills to drop a troll bomb"
}

return descriptions