fx_version 'adamant'

game 'gta5'

description 'ESX TÜV Dortmund'

version '1.0'


resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/de.lua',
  'config.lua',
  'client/main.lua',
  'server/main.lua'
}

client_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/de.lua',
  'config.lua',
  'client/main.lua',
  "@NativeUI/NativeUI.lua"
}
