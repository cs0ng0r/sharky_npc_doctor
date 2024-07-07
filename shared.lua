Config = {}


Config.PedSettings = {
    PedModel = GetHashKey("s_f_y_scrubs_01"),
    Coords = { x = 221.7073, y = -801.1910, z = 29.6887, h = 331.8986 }, -- 221.7073, -801.1910, 30.6887, 331.8986
} -- 308.4781, -595.2182, 43.2840, 66.9862


Config.Options = {
    CheckInterval = 5,   -- Hány másodpercenként ellenőrizze, hogy van-e online mentőszolgálatos
    RevivePrice = 20000, -- Feltámadás ára
    HealPrice = 10000,   -- Gyógyulás ára
    MaleHealth = 200,    -- Férfi játékosok alap élete
    FemaleHealth = 175,  -- Női játékosok alap élete
}

Config.NPCText = {
    npc_ems_online =  "~r~Ügyeletes \n ~s~Bocsi, jelenleg van elérhetö kollégám!",
    npc_heal_txt = "~r~Ügyeletes \n ~s~Nyomd meg az ~g~E~w~ gombot az ellátás igényléséhez! ~g~10.000$",
    npc_revive_txt = "~r~Ügyeletes \n ~s~Nyomd meg az ~g~E~w~ gombot a feltámadáshoz! ~g~20.000$",
}