if !PK then
	PK = {}
	PK.Client = {}
end

function PK_SaveConfig()
	file.Write("pkr_cl_settings.txt", util.TableToJSON(PKConfig))
end

PKConfig = {}

if file.Exists("pkr_cl_settings.txt", "DATA") then
	pk_config_file = file.Read("pkr_cl_settings.txt", "DATA")
	PKConfig = util.JSONToTable(pk_config_file)
	print("what")
	PrintTable(PKConfig)
else
	print("what the fuck")
	PKConfig = {
		RemoveSkybox = false,
		RoofTiles = false,
		UseLerpCommand = false,
		UseCustomFOV = false,
		CustomFOV = 100,
		UseCustomViewmodelOffset = false,
		CustomViewmodelOffset = Vector(1, 1, 1),
		HideViewmodel = false
	}
	PK_SaveConfig()
end


function PK_SetConfig(setting, value)
	PKConfig[setting] = value
	PK_SaveConfig()
	print(setting)
	if isfunction(PK.Client[setting]) then
		PK.Client[setting]()
	end
	print("SET " .. setting .. " TO " .. tostring(value))
end

function PK_GetConfig(setting)
	if isbool(PKConfig[setting]) then
		return PKConfig[setting] or false
	elseif isvector(PKConfig[setting]) then
		return PKConfig[setting]
	elseif isnumber(PKConfig[setting]) then
		return math.Round(tonumber(PKConfig[setting]))
	end
end
