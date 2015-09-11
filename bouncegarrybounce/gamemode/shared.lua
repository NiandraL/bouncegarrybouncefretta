GM.Name 	= "Bounce Garry Bounce!"
GM.Author 	= "iRzilla"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta13" )

GM.Help	= "Be the first to reach the top!"
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 0
GM.GameLength = 10 -- meh
GM.RoundBased = false
GM.NoPlayerDamage = true
GM.NoPlayerSelfDamage = true
GM.NoPlayerTeamDamage = true
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.AddFragsToTeamScore = false
GM.TeamBased = false
GM.RoundPreStartTime = 0
GM.NoAutomaticSpawning = true

team.SetUp( 24, "Jumpers!", Color( 90, 255, 90, 255 ), true )
team.SetClass( 24, { "Jumper" } )

local CLASS = {}

CLASS.DisplayName			= "Jumper"
CLASS.WalkSpeed 			= 0
CLASS.CrouchedWalkSpeed 	= 0
CLASS.RunSpeed				= 0
CLASS.DuckSpeed				= 0
CLASS.JumpPower				= 0
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )
end

function CLASS:OnSpawn(ply)
	if ply.Jumper then ply.Jumper:Remove() ply.Jumper = nil end

	ply:SetModel("models/player/Group01/male_01.mdl")
	
	ply.Jumper = ents.Create("sent_jumper")
	ply.Jumper:SetPos(Vector(0, -1300, 50))
	ply.Jumper.Owner = ply
	ply.Jumper:Spawn()
	ply.Jumper:Activate()
	
	local rp = RecipientFilter()     -- Grab a CRecipientFilter object
	rp:AddAllPlayers()               -- Send to all players!
	 
	umsg.Start("myjumper", rp)
	    umsg.Long(ply:EntIndex())
	    umsg.Long(ply.Jumper:EntIndex())
	umsg.End()
end

function CLASS:OnDeath(ply)
	ply.Jumper:Remove()
	ply.Jumper = nil
	
	ply:Spawn()
end

player_class.Register("Jumper", CLASS)