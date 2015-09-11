AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

include( "server/sv_chatcommands.lua" )
include( "server/sv_player.lua" )

resource.AddFile("models/bgb/platform.mdl")
resource.AddFile("materials/models/bgb/platform_sheet.vtf")