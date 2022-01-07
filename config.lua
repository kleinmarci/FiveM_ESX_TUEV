Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 22
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableSocietyOwnedVehicles = false
Config.MaxInService               = -1
Config.Locale                     = 'de'

Config.tuevdortmundStations = {

  tuevdortmund = {

    AuthorizedWeapons = {
      { name = 'WEAPON_COMBATPISTOL',     price = 4000 },
      { name = 'WEAPON_ASSAULTSMG',       price = 50000 },
      { name = 'WEAPON_ASSAULTRIFLE',     price = 80000 },
      { name = 'WEAPON_PUMPSHOTGUN',      price = 18000 },
      { name = 'WEAPON_STUNGUN',          price = 250 },
      { name = 'WEAPON_FLASHLIGHT',       price = 50 },
      { name = 'WEAPON_FIREEXTINGUISHER', price = 50 },
      { name = 'WEAPON_CARBINERIFLE',     price = 50000 },
      { name = 'WEAPON_ADVANCEDRIFLE',    price = 50000 },
      { name = 'WEAPON_SNIPERRIFLE',      price = 150000 },
      { name = 'WEAPON_SMOKEGRENADE',     price = 8000 },
      { name = 'WEAPON_APPISTOL',         price = 12000 },
      { name = 'WEAPON_FLARE',            price = 8000 },
      { name = 'WEAPON_SWITCHBLADE',      price = 500 },
	  { name = 'WEAPON_POOLCUE',          price = 100 },  
    },

	AuthorizedVehicles = {
	  { name = 'hexer',          label = 'Hexer' },
	  { name = 'innovation',     label = 'Innovation' },
	  { name = 'daemon',         label = 'Daemon' },
	  { name = 'Zombieb',        label = 'Zombie Chopper' },
	  { name = 'slamvan',        label = 'Slamvan' },
	  { name = 'GBurrito',       label = 'Gang Burrito' },
	  { name = 'sovereign',      label = 'Sovereign' },
	  { name = 'benson',         label = 'Benson' },		  
	  },

    Armories = {
      { x = -364.48, y = -88.17, z = 45.86},
    },

    Vehicles = {
      {
        Spawner    = { x = -362.33, y = -146.38, z = 38.24 },
        SpawnPoint = { x = -373.16, y = -143.48, z = 38.68 },
        Heading    = 147.03,
      }
    },

    VehicleDeleters = {
      { x = -385.54, y = -118.53, z = 38.69 },
    },


    tuervpoint = {
      { x = -369.01, y = -111.01, z = 38.84 },
    },
    tuervpoint2 = {
      { x = -364.25, y = -113.43, z = 38.91 },
    },
    tuervpoint3 = {
      { x = -374.63, y = -110.05, z = 38.92 },
    },
    tuervpoint4 = {
      { x = -377.56, y = -115.34, z = 38.92 },
    },

    BossActions = {
      { x = -370.51, y = -94.48, z = 45.86 },
    },
	
  },
  
}
