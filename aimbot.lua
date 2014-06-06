--[[
    Credits:
    Original modified wiki aimbot by Trollaux
    Random string function by tehhkp modified by Trollaux
]]--
local usingMouseKey = false
local aimkey = KEY_F
local mousekey = MOUSE_RIGHT
local ltrs = {
    [1] = "a",
    [2] = "b",
    [3] = "c",
    [4] = "d",
    [5] = "e",
    [6] = "f",
    [7] = "g",
    [8] = "h",
    [9] = "i",
    [10] = "j",
}
local function randomstring(length)
	local random = ""
		for i=0,length do
			local random = random .. ltrs[math.random(1,10)]
		end
	return random
end
local function hookDatShit(HookType,Function)
	local funcname = HookType.." | "..randomstring(10)
	return hook.Add(HookType,funcname,Function)
end
hookDatShit("CreateMove", function()
	local enabled = false
	if usingMouseKey then enabled = (input.IsMouseDown(mousekey)) else enabled = (input.IsKeyDown(aimkey)) end
	if enabled then
	local ply = LocalPlayer()
	local trace = util.GetPlayerTrace( ply )
	local traceRes = util.TraceLine( trace )
	local shouldTarget = true
	if traceRes.HitNonWorld then
		local target = traceRes.Entity
		if target:IsPlayer() then
			if not shouldAttackFriends then
				if target:GetFriendStatus() == "friend" then
					shouldTarget = false	
				end
			end
			if target:Alive() and target != LocalPlayer() and shouldTarget then
			local targethead = target:LookupBone("ValveBiped.Bip01_Head1")
			local targetheadpos,targetheadang = target:GetBonePosition(targethead)
			ply:SetEyeAngles((targetheadpos - ply:GetShootPos()):Angle())
		end
	end
end
end
end)
