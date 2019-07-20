-- Use Lerp Command

function PK.Client.UseLerpCommand()
	if PK_GetConfig("UseLerpCommand") then
		RunConsoleCommand("cl_updaterate", "1000")
		RunConsoleCommand("cl_interp", "0")
		RunConsoleCommand("rate", "1048576")
	else
		RunConsoleCommand("cl_updaterate", "30")
		RunConsoleCommand("cl_interp", "0.1")
		RunConsoleCommand("rate", "30000")
	end
end