-- Global Variables
DPSMate.Modules.FriendlyFire = {}
DPSMate.Modules.FriendlyFire.Hist = "DMGTaken"
DPSMate.Options.Options[1]["args"]["friendlyfire"] = {
	order = 260,
	type = 'toggle',
	name = 'Friendly fire',
	desc = 'TO BE ADDED!',
	get = function() return DPSMateSettings["windows"][DPSMate.Options.Dewdrop:GetOpenedParent().Key]["options"][1]["friendlyfire"] end,
	set = function() DPSMate.Options:ToggleDrewDrop(1, "friendlyfire", DPSMate.Options.Dewdrop:GetOpenedParent()) end,
}

-- Register the moodule
DPSMate:Register("friendlyfire", DPSMate.Modules.FriendlyFire)


function DPSMate.Modules.FriendlyFire:GetSortedTable(arr)
	local b, a, total, temp = {}, {}, 0, {}
	for c, v in pairs(arr) do
		local cName = DPSMate:GetUserById(c)
		for cat, val in pairs(v) do
			if DPSMateUser[cName][3]==1 and DPSMateUser[DPSMate:GetUserById(cat)][3]==1 then
				if temp[c] then temp[c]=temp[c]+val["i"][3] else temp[c] = val["i"][3] end
			end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not b[i]) then
				table.insert(b, i, val)
				table.insert(a, i, cat)
				break
			else
				if b[i] < val then
					table.insert(b, i, val)
					table.insert(a, i, cat)
					break
				end
			end
			i=i+1
		end
		total = total + val
	end
	return b, total, a
end

function DPSMate.Modules.FriendlyFire:EvalTable(user, k)
	local a, d, total, temp = {}, {}, 0, {}
	local arr = DPSMate:GetMode(k)
	if not arr[user[1]] then return end
	for cat, val in pairs(arr[user[1]]) do
		if user[3]==1 and DPSMateUser[DPSMate:GetUserById(cat)][3]==1 then
			for ca, va in pairs(val) do
				if ca~="i" then
					if temp[cat] then temp[cat]=temp[cat]+va[13] else temp[cat] = va[13] end
				end
			end
		end
	end
	for cat, val in pairs(temp) do
		local i = 1
		while true do
			if (not d[i]) then
				table.insert(a, i, cat)
				table.insert(d, i, val)
				break
			else
				if (d[i] < val) then
					table.insert(a, i, cat)
					table.insert(d, i, val)
					break
				end
			end
			i = i + 1
		end
		total=total+val
	end
	return a, total, d
end

function DPSMate.Modules.FriendlyFire:GetSettingValues(arr, cbt, k)
	local name, value, perc, sortedTable, total, a, p, strt = {}, {}, {}, {}, 0, 0, "", {[1]="",[2]=""}
	if DPSMateSettings["windows"][k]["numberformat"] == 2 then p = "K" end
	sortedTable, total, a = DPSMate.Modules.FriendlyFire:GetSortedTable(arr)
	for cat, val in pairs(sortedTable) do
		local dmg, tot, sort = DPSMate:FormatNumbers(val, total, sortedTable[1], k)
		if dmg==0 then break end
		local str = {[1]="",[2]="",[3]=""}
		str[1] = " "..dmg..p; strt[2] = tot..p
		str[2] = " ("..string.format("%.1f", 100*dmg/tot).."%)"
		table.insert(name, DPSMate:GetUserById(a[cat]))
		table.insert(value, str[1]..str[2])
		table.insert(perc, 100*(dmg/sort))
	end
	return name, value, perc, strt
end

function DPSMate.Modules.FriendlyFire:ShowTooltip(user, k)
	local a,b,c = DPSMate.Modules.FriendlyFire:EvalTable(DPSMateUser[user], k)
	if DPSMateSettings["informativetooltips"] then
		for i=1, DPSMateSettings["subviewrows"] do
			if not a[i] then break end
			GameTooltip:AddDoubleLine(i..". "..DPSMate:GetUserById(a[i]),c[i],1,1,1,1,1,1)
		end
	end
end


