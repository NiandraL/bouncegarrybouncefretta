module( "chatcommand", package.seeall )

local Commands = {}
function Add( name, func )
	Commands[ name ] = func
end

function Call( name, pl, args )
	local func = Commands[ name ]
	if (func) then
		local b, res = pcall( func, pl, name, args )
		if (!b) then
			Commands[ name ] = nil
			ErrorNoHalt( res )
			return false
		end
		return true
	end
end

function FindPlayer( name )
	for _, ply in pairs( player.GetAll() ) do
		if (string.find( ply:Nick(), name ) || (name == ply:Nick())) then return ply end
	end
end

local function PlayerSay( ply, text, toall)
    

	local first = string.sub( text, 1, 1 )
	if (first == "/") then
		local str = string.sub( text, 2 )
		local args = string.Explode( " ", str )
		local com = args[1]
		table.remove( args, 1 )
		local b = Call( com, ply, args )
		if (b) then return "" end
	end
	
	

end
hook.Add( "PlayerSay", "CHATCOMMANDS", PlayerSay )