--[[
    Credits:
    	Fami Harukaze for cleaning all of this sperged code :^) Visit my channel: https://www.youtube.com/user/INTELINSIDECHANNEL
]]--

local _R = debug.getregistry();
local _G = _G;
local cheat_notify = function(x) _G.chat.AddText(_G.Color(240,240,0,255),"TheAimbotProject| ",_G.Color(240,240,240),x); end;
local g_pGetTeam = _R.Player.Team
local g_pInVehicle = _R.Player.InVehicle
local g_pIsAlive = _R.Player.Alive
local g_pLocalToWorld = _R.Entity.LocalToWorld
local g_pGetOBBCenter = _R.Entity.OBBCenter
local g_GetCenter = function(x) if !x then return; end return g_pLocalToWorld(x,g_pGetOBBCenter(x)); end
local g_pEyePos = _R.Entity.EyePos
local g_ToAngles = _R.Vector.Angle

--[[ // Todo: Unload Hooks
local cheat_hooks = {};
local function cheat_unload()
	for k = 0, #cheat_hooks do local v = cheat_hooks[k];
	_G.hook.Remove();
	end
end
]]

local g_pLocalPlayer = _G.LocalPlayer();
local g_pAimbotTarget = nil;

local function g_IsValidTarget(pEnt)
	if (!pEnt) then return false; end
	
	if pEnt:IsPlayer() then
		if (pEnt == g_pLocalPlayer) then return false; end
	
		if (!g_pIsAlive(pEnt)) then return false; end 
		
		if (g_pInVehicle(pEnt)) then return false; end

		if (g_pGetTeam(pEnt) == TEAM_SPECTATOR) then return false; end
	end
	
	return true;
end

local function g_AimbotThread()
	g_pAimbotTarget = nil;
	local pPlayers = player.GetAll(); -- local pEntities = ents.GetAll(); // Incaze you want to aim at npcs
	for i = 1, #pPlayers do local pEnt = pPlayers[i]; -- Now let's iterate though players... 'i' is the integrer and 'pEnt' is the player entity
		if (!g_IsValidTarget(pEnt)) then continue; end
		g_pAimbotTarget = pEnt;
	end
end

local function g_GetAimPosition(pEnt)
	local vPrediction = _G.Vector(0,0,0); -- Make your own prediction, faggot.

	return (g_GetCenter(pEnt) + vPrediction);
end

local function g_Aim(CUserCmd)
	if (g_pAimbotTarget ~= nil) then
		local vPosition = g_GetAimPosition(g_pAimbotTarget);
		local aAngles = g_ToAngles(vPosition - g_pEyePos(g_pLocalPlayer))
		aAngles.p = _G.math.NormalizeAngle(aAngles.p);
		aAngles.y = _G.math.NormalizeAngle(aAngles.y);
		
		CUserCmd:SetViewAngles(aAngles)
	end
end

local function hooked_CreateMove(CUserCmd, sequence_number, input_sample_frametime, active)

	g_AimbotThread(); -- Search for a target

	g_Aim(CUserCmd); -- Aim at the target if any.

end

local function hookAdd(hooked_vfuncname,hooked_nfunc)
	_G.hook.Add(hooked_vfuncname,_G.tostring(math.random(666,133769420)),hooked_nfunc);
	cheat_notify("Hook Added: "..hooked_vfuncname..".");
end

hookAdd("CreateMove",hooked_CreateMove)

cheat_notify("Cheat Loaded.");
