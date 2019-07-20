-- Remove Skybox

function PK.Client.RemoveSkybox()
	if PK_GetConfig("RemoveSkybox") then
		hook.Add("PostDrawSkyBox", "removeSkybox", function()
			render.Clear(50, 50, 50, 255)
			return true
		end)
		hook.Add("PostDraw2DSkyBox", "removeSkybox", function()
			render.Clear(50, 50, 50, 255)
			return true
		end)
	else
		hook.Remove("PostDrawSkyBox", "removeSkybox")
		hook.Remove("PostDraw2DSkyBox", "removeSkybox")
	end
end

-- Roof Tiles

local DrawPos
local params = {
	["$basetexture"] = "phoenix_storms/pack2/train_floor",
	["$nodecal"] = 1,
	["$model"] = 1,
	["$additive"] = 0,
	["$nocull"] = 1,
	["$alpha"] = 0.95
}
local RoofMaterial = CreateMaterial("RoofMaterialTest8", "UnlitGeneric", params)

timer.Create("DrawRoofTiles", 0.1, 0, function()
	if not IsValid(LocalPlayer()) then return end
	local tracedata = {}
	tracedata.start = LocalPlayer():GetShootPos()
	tracedata.endpos = tracedata.start + Vector(0,0,9999999)
	tracedata.filter = LocalPlayer()
	tracedata.mask = MASK_NPCWORLDSTATIC
	local trace = util.TraceLine(tracedata)
	if trace.HitWorld and (trace.HitTexture == "TOOLS/TOOLSSKYBOX" or trace.HitTexture == "TOOLS/TOOLSSKYBOX2D") then
		DrawPos = DrawPos or trace.HitPos
		DrawPos.z = trace.HitPos.z
	end
	if IsValid(DrawPos) then
		timer.Remove("DrawRoofTiles")
	end
end)

function PK.Client.RoofTiles()
	if PK_GetConfig("RoofTiles") then
		hook.Add("PostDrawOpaqueRenderables", "ReplaceSkyBox", function()
			if not DrawPos then return end
			local pos1 = DrawPos + Vector( 5000,  5000, 0)
			local pos2 = DrawPos + Vector(-5000,  5000, 0)
			local pos3 = DrawPos + Vector(-5000, -5000, 0)
			local pos4 = DrawPos + Vector( 5000, -5000, 0)
			cam.Start3D(EyePos(), EyeAngles())
				render.SuppressEngineLighting(true)
				render.SetBlend(0.4)
				render.SetMaterial(RoofMaterial)

				render.DrawQuad(pos1, pos2, pos3, pos4)
				render.DrawQuad(pos1 + Vector(5000), pos2 + Vector(5000), pos3 + Vector(5000), pos4 + Vector(5000))
				render.DrawQuad(pos1 - Vector(5000), pos2 - Vector(5000), pos3 - Vector(5000), pos4 - Vector(5000))
				render.DrawQuad(pos1 - Vector(5000, 5000), pos2 - Vector(5000, 5000), pos3 - Vector(5000, 5000), pos4 - Vector(5000, 5000))
				render.DrawQuad(pos1 - Vector(5000, -5000), pos2 - Vector(5000, -5000), pos3 - Vector(5000, -5000), pos4 - Vector(5000, -5000))
				render.DrawQuad(pos1 - Vector(0, -5000), pos2 - Vector(0, -5000), pos3 - Vector(0, -5000), pos4 - Vector(0, -5000))
				render.DrawQuad(pos1 + Vector(0, -5000), pos2 + Vector(0, -5000), pos3 + Vector(0, -5000), pos4 + Vector(0, -5000))

				render.DrawQuad(pos1 - Vector(-5000, -5000), pos2 - Vector(-5000, -5000), pos3 - Vector(-5000, -5000), pos4 - Vector(-5000, -5000))
				render.DrawQuad(pos1 - Vector(-5000, 5000), pos2 - Vector(-5000, 5000), pos3 - Vector(-5000, 5000), pos4 - Vector(-5000, 5000))


				render.SuppressEngineLighting(false)
				render.SetBlend(1)
			cam.End3D()
		end)
	else
		hook.Remove("PostDrawOpaqueRenderables", "ReplaceSkyBox")
	end
end

-- Use Custom FOV

function PK.Client.UseCustomFOV()
	if PK_GetConfig("UseCustomFOV") then
		local function fov(ply, ori, ang, fov, nz, fz)
			local view = {}
			view.origin = ori
			view.angles = ang
			view.fov = PK_GetConfig("CustomFOV") or 100
			return view
		end
		hook.Add("CalcView", "PK_CustomFOV", fov)
	else
		hook.Remove("CalcView", "PK_CustomFOV")
	end
end

-- Use Custom Viewmodel Offset

function PK.Client.UseCustomViewmodelOffset()
	if PK_GetConfig("UseCustomViewmodelOffset") then
		local function ViewmodelOffset(wep, vm, oldPos, oldAng, pos, ang)
			local view = {}
			pos = pos + ang:Right() * PK_GetConfig("CustomViewmodelOffset").x
			pos = pos + ang:Forward() * PK_GetConfig("CustomViewmodelOffset").y
			pos = pos + ang:Up() * PK_GetConfig("CustomViewmodelOffset").z
			view.angles = ang
			return pos, ang
		end
		hook.Add("CalcViewModelView", "PK_CustomViewmodelOffset", ViewmodelOffset)
	else
		hook.Remove("CalcViewModelView", "PK_CustomViewmodelOffset")
	end
end

-- Hide Viewmodel

function PK.Client.HideViewmodel()
	if PK_GetConfig("HideViewmodel") then
		local function HideViewmodel()
			for i = 0, 2 do
				LocalPlayer():DrawViewModel(false, i)
			end
		end
		//HideViewmodel()
		hook.Add("PreDrawViewModel", "PK_Hideviewmodel", HideViewmodel)
	else
		for i = 0, 2 do
			LocalPlayer():DrawViewModel(true, i)
		end
		hook.Remove("PreDrawViewModel", "PK_Hideviewmodel")
	end
end

-- Autorun all enabled settings on start

for k,v in pairs(PK.Client) do
	if isbool(PK_GetConfig(k)) and PK_GetConfig(k) == true then
		v()
	end
end