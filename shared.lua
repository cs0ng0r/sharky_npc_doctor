Sharky = {}


Sharky.PedSettings = {
    PedModel = GetHashKey("s_m_m_doctor_01"),
    Coords = { x = 307.2420, y = -593.6313, z = 42.2840, h = 66.9500 },
}


Sharky.Options = {
    CheckInterval = 5, -- Hány másodpercenként ellenőrizze, hogy van-e online mentőszolgálatos
    ["heal"] = {
        minHealth = 75,
        price = 10000
    },
    ["revive"] = {
        minHealth = 0,
        price = 20000
    }
}
