if not AssignBearerFix then 
	AssignBearerFix = {} 
end

AssignBearerFix.CmdQ = {}
AssignBearerFix.elapsed = 0
local lastUpdate = 0;
local updateThrottle = 0.5;
local tinsert, pairs = table.insert, pairs

function AssignBearerFix.Initialize()
	AssignBearerFix.OldCommandAssignBearer = GuildWindowTabRoster.CommandAssignBearer
	GuildWindowTabRoster.CommandAssignBearer = AssignBearerFix.CommandAssignBearer
end

function AssignBearerFix.OnShutdown()
	GuildWindowTabRoster.CommandAssignBearer = AssignBearerFix.OldCommandAssignBearer
end

function AssignBearerFix.OnUpdate(elapsed)
	AssignBearerFix.elapsed = AssignBearerFix.elapsed + elapsed
	if (AssignBearerFix.elapsed - lastUpdate >= updateThrottle) then		
		if #AssignBearerFix.CmdQ > 0 then
			local cmd = table.remove(AssignBearerFix.CmdQ, 1)
            SendChatText(cmd, L"")			
		end
	end
end

function AssignBearerFix.CommandAssignBearer()
	local StandardBearer = {}
    local MAX_STANDARD_BEARERS = 5
    local count = 0
	local members = GetGuildMemberData()
	local cmd = L""
    for _, member in pairs(members) do
		if ((member.bearerStatus == 1) and (member.zoneID == 0)) then            
			tinsert(StandardBearer, member.name)
			count = count + 1
        end
    end
	if count >= MAX_STANDARD_BEARERS and #StandardBearer > 0 then
		for _, member in pairs(StandardBearer) do
			cmd = L"/guildremovestandardbearer "..member
			tinsert(AssignBearerFix.CmdQ, cmd)
		end
    end
	cmd = L"/guildaddstandardbearer "..GuildWindowTabRoster.SelectedGuildMemberName
    tinsert(AssignBearerFix.CmdQ, cmd)
end

function AssignBearerFix.GuildInvolve()
	SendChatText(L"/GuildInvolve", L"")
end