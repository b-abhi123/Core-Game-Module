local mainModule = {}

--[[
	Common Items: 0-1K
	Uncommon Items: 5K-10K
	Epic Items: 10K-50K
	Legendary Items: 50K-100K
	Relic Items: 100K-1M
	Contraband Items: 1M+
	Unobtainable Items: Not obtainable
]]
local HTTP = game:GetService("HttpService")
local MPS = game:GetService("MarketplaceService")
local Insert = game:GetService("InsertService")

function mainModule:getRAPFromPlayer(player: Player)
	if game.Players:FindFirstChild(player.Name) then
		--Player actually exists in the game
		local playerLimiteds = game.ReplicatedStorage.Inventories[player.Name]
		if playerLimiteds then
			--Player has loaded
			local limiteds = game.ReplicatedStorage.Inventories[player.Name]:GetChildren()
			local totalRap = 0
			for i,v in pairs(limiteds) do
				local RAP = v:FindFirstChild("RAP")
				totalRap += RAP.Value
			end
			return totalRap
		end
	end
end

function mainModule.getRarityIfLost(fromRarity)
	if fromRarity == "Common" then
		return "Common"
	elseif fromRarity == "Uncommon" then
		return "Common"
	elseif fromRarity == "Rare" then
		return "Uncommon"
	elseif fromRarity == "Epic" then
		return "Rare"
	elseif fromRarity == "Legendary" then
		return "Epic"
	elseif fromRarity == "Relic" then
		return "Legendary"
	end
end

function mainModule.getRarityFromDifference(diff, rarity)
	if rarity == "Common" then
		if diff < 10 then
			return 'Uncommon'
		elseif diff < 50 then
			return 'Rare'
		elseif diff < 100 then
			return 'Epic'
		elseif diff < 500 then
			return 'Legendary'
		elseif diff < 1000 then
			return 'Relic'
		else
			return 'Unobtainable'
		end
	elseif rarity == "Uncommon" then
		if diff < 10 then
			return 'Rare'
		elseif diff < 50 then
			return 'Epic'
		elseif diff < 100 then
			return 'Legendary'
		elseif diff < 500 then
			return 'Relic'
		elseif diff < 1000 then
			return 'Unobtainable'
		end
	elseif rarity == "Rare" then
		if diff < 10 then
			return 'Epic'
		elseif diff < 50 then
			return 'Legendary'
		elseif diff < 100 then
			return 'Relic'
		elseif diff < 500 then
			return 'Unobtainable'
		end
	elseif rarity == "Epic" then
		if diff < 10 then
			return 'Legendary'
		elseif diff < 50 then
			return 'Relic'
		elseif diff < 100 then
			return 'Unobtainable'	
		end
	elseif rarity == "Legendary" then
		if diff < 10 then
			return 'Relic'
		elseif diff < 100 then
			return 'Unobtainable'
		end
	elseif rarity == "Relic" then
		if diff < 10 then
			return 'Unobtainable'
		end
	end	
end

function mainModule.detectRarity(rap)
	if rap < 5000 then
		return 'Common'
	elseif rap < 10000 then
		return 'Uncommon'
	elseif rap < 50000 then
		return 'Rare'
	elseif rap < 100000 then
		return 'Epic'
	elseif rap < 1000000 then
		return 'Legendary'
	elseif rap < 10000000 then
		return 'Relic'
	else
		return 'Unobtainable'
	end
end

function mainModule.addDetails(item, name, RAPrice, typeofitem, id)
	local NativeName = Instance.new("StringValue", item)
	NativeName.Value = name
	NativeName.Name = "NativeName"

	local RAP = Instance.new("StringValue", item)
	RAP.Value = RAPrice
	RAP.Name = "RAP"

	local Type = Instance.new("StringValue", item)
	Type.Name = "Type"
	Type.Value = typeofitem
	
	local Id = Instance.new("IntValue", item)
	Id.Value = id
	Id.Name = "ProductId"
end
function mainModule.Length(Table)
	local counter = 0 
	for _, v in pairs(Table) do
		counter =counter + 1
	end
	return counter
end

function mainModule.addCommaToNum(n)
	local formatted = n
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function mainModule.filternum(n)
	local suffixes = {"K", "M", "B", "T", "Q"}
	local i = math.floor(math.log(n, 1e3))
	local v = math.pow(10, i * 3)
	return ("%.1f"):format(n / v):gsub("%.?0+$", "") .. (suffixes[i] or "")
end

mainModule.CrateData = {
	Group = {
		Common = 50,
		Uncommon = 35,
		Rare = 13.785,
		Epic = 1,
		Legendary = 0.2,
		Relic = 0.01,
		Unobtainable = 0.005
	},
	Wood = {
		Common = 60,
		Uncommon = 25,
		Rare = 13,
		Epic = 1.78,
		Legendary =0.25,
		Relic = 0.01,
		Unobtainable = 0.005
	},
	Silver = {
		Common = 30,
		Uncommon = 45,
		Rare = 15,
		Epic = 9.685,
		Legendary = 0.3,
		Relic = 0.01,
		Unobtainable = 0.005
	},
	Gold = {
		Common = 25,
		Uncommon = 40, 
		Rare = 25,
		Epic = 9.5, 
		Legendary = 0.478,
		Relic = 0.015,
		Unobtainable = 0.007
	},
	Clover = {
		Common = 10,
		Uncommon = 40,
		Rare = 35,
		Epic = 14.41,
		Legendary = 0.545,
		Relic = 0.03,
		Unobtainable = 0.015
	},
	Heavenly = {
		Common = 10,
		Uncommon = 25,
		Rare = 40,
		Epic = 24.3,
		Legendary = 0.62,
		Relic = 0.065,
		Unobtainable = 0.015
	},
	Dark = {
		Common = 5,
		Uncommon = 35,
		Rare = 35,
		Epic = 24.35,
		Legendary = 0.6,
		Relic = 0.04,
		Unobtainable = 0.01
	},
	Fairy = {
		Common = 69,
		Uncommon = 0,
		Rare = 9,
		Epic = 6.78,
		Legendary = 15,
		Relic = 0.2,
		Unobtainable = 0.02
	}
}

mainModule.CratePrice = {
	Group = "robux",
	Wood = 5000,
	Silver = 10000,
	Gold = 25000,
	Clover = 50000,
	Heavenly = 100000,
	Dark = "robux",
	Fairy = "robux"
}

mainModule.DuplicateReward = {
	Common = 100,
	Uncommon = 500,
	Rare = 1000,
	Epic = 2500,
	Legendary = 10000,
	Relic = 25000,
	Unobtainable = 50000
}

mainModule.ToolsData = {
	sPhoneFive = 5,
	sPadTwo = 10,
	semBookTwoNineteen = 25,
	sMacTwoFourteen = 50,
	sMacMini = 75,
	sMacUltra = 100,
	senonsixonesevens = 250,
	HappyBdayCamera = 500,
	securityscam = 750,
	studiocamera = 1000,
	newscamera = 2500,
	semanticscopexs = 5000,
	hubblebubble = 10000,
}

mainModule.Rarity = {
	Group = {
		{"Common",50},
		{"Uncommon",35},
		{"Rare",13.785},
		{"Epic",1},
		{"Legendary",0.2},
		{"Relic",0.01},
		{"Unobtainable",0.005}
	},
	Wood = {
		{"Common",60},
		{"Uncommon",25},
		{"Rare",13},
		{"Epic",1.78},
		{"Legendary",0.25},
		{"Relic",0.01},
		{"Unobtainable",0.005}
	},
	Silver = {
		{"Common",30},
		{"Uncommon",45},
		{"Rare",15},
		{"Epic",9.685},
		{"Legendary",0.3},
		{"Relic",0.01},
		{"Unobtainable",0.005}
	},
	Gold = {
		{"Common",25},
		{"Uncommon",40},
		{"Rare",25},
		{"Epic",9.5},
		{"Legendary",0.478},
		{"Relic",0.015},
		{"Unobtainable",0.007}
	},
	Clover = {
		{"Common",10},
		{"Uncommon",40},
		{"Rare",35},
		{"Epic",14.41},
		{"Legendary",0.545},
		{"Relic",0.03},
		{"Unobtainable",0.015}
	},
	Heavenly = {
		{"Common",10},
		{"Uncommon",25},
		{"Rare",40},
		{"Epic",24.3},
		{"Legendary",0.62},
		{"Relic",0.065},
		{"Unobtainable",0.015}
	},
	Dark = {
		{"Common",5},
		{"Uncommon",35},
		{"Rare",35},
		{"Epic",24.35},
		{"Legendary",0.6},
		{"Relic",0.04},
		{"Unobtainable",0.01}
	},
	Fairy = {
		{"Common",69},
		{"Uncommon",0},
		{"Rare",9},
		{"Epic",6.78},
		{"Legendary",15},
		{"Relic",0.2},
		{"Unobtainable",0.02}
	}
}

mainModule.itemsColor = {
	Common = Color3.fromRGB(189,189,189),
	Uncommon = Color3.fromRGB(0, 191, 92),
	Rare = Color3.fromRGB(33, 150, 243),
	Epic = Color3.fromRGB(224,64,251),
	Legendary = Color3.fromRGB(251,192,45),
	Relic = Color3.fromRGB(255,80,80),
	Unobtainable = Color3.fromRGB(255,0,197)
}

mainModule.itemsTable = {
	Common = {},
	Uncommon = {},
	Rare = {},
	Epic = {},
	Legendary = {},
	Relic = {},
	Unobtainable = {}
}


function mainModule.computeMultiplier(RAP)
	return math.floor((math.floor(((RAP - 100000) / 100000) + 1) * 0.1) * 10)/10
	
end

function mainModule.randomRarity(box)
	local RNG = Random.new()
	local counter = 0
	for i,v in pairs(mainModule.Rarity[box]) do
		counter += mainModule.Rarity[box][i][2]
	end
	local Chosen = RNG:NextNumber(0, counter); -- Randomize Counter
	for i, v in pairs(mainModule.Rarity[box]) do 
		counter -= mainModule.Rarity[box][i][2]
		if Chosen > counter then
			return mainModule.Rarity[box][i][1] -- This will return the first array in the table, which is the item we would like to give chosen randomly..
		end
	end
end

function mainModule.getItemFromRarity(rarity)
--	print(rarity)
	if game.ReplicatedStorage.LimitedsLoaded.Value == true then
		local rarFolder = game.ReplicatedStorage.Limiteds:FindFirstChild(rarity)
		if rarFolder then
			local allItems = rarFolder:GetChildren()
			local randomItem = allItems[math.random(1, #allItems)]
			return randomItem.Name
		else
			error("MainModule: COULD NOT FIND RARITY FOLDER. FOLDER WAS INDEXED TO RARITY: "..rarity)
			return "ERR"
		end
	else
		error("MainModule: LIMITEDS HAVE NOT LOADED YET!")
		return "ERR"
	end
end

mainModule.Limiteds = {
	--Add limited IDS here
}


mainModule.Unobtainables = {
	--Add limited IDs HERE
}
function mainModule.checkCurrency(player, amount)
	local details = {
		TotalAmount = amount,
		CurrencyType = "Cash",
		AmountDifference = 0,
		IsEnough = false
	}
	if player:FindFirstChild("leaderstats").Cash.Value > amount then
		details.IsEnough = true
		return details
	else
		details.AmountDifference = amount - player.leaderstats.Cash.Value
		return details
	end
end


function mainModule.modifyCurrency(player, amount, action)
	if action == "Subtract" then
		print('Mainmodule: Now Subtracting.')
		if player.Robucks.Value > amount then
			player.Robucks.Value = player.Robucks.Value - amount
			return true
		else
			return false
		end
	elseif action == "Add" then
		print('Mainmodule: Now Adding.')
		player.Robucks.Value = player.Robucks.Value + amount
		return true
	end
end

function mainModule:loadLimiteds(passcode)
	if passcode == "i" and game:GetService("RunService"):IsServer() then
		local loadedLims = game.ReplicatedStorage.Server_Data.Loaded
		game.ReplicatedStorage.Server_Data.Total.Value = mainModule.Length(mainModule.Limiteds)
		for index,unobs in pairs(mainModule.Unobtainables) do
			local LoadedAsset = Insert:LoadAsset(unobs):GetChildren()
			local ProductInfo = MPS:GetProductInfo(unobs)
			local ItemName = ProductInfo.Name
			local Rarity = "Unobtainable"
			local RAP = "10000000"
			if LoadedAsset[1]:IsA("Decal") then
				local Type = "Face"
				if game.ReplicatedStorage.Limiteds[Rarity]:FindFirstChild("ItemName") == nil then
					local PartCache = game.ReplicatedStorage:WaitForChild("Beauty"):Clone()
					PartCache.Parent = game.ReplicatedStorage.Limiteds[Rarity]
					PartCache.Anchored = true
					LoadedAsset[1].Parent = PartCache
					LoadedAsset[1].Name = ItemName
					PartCache.Name = ItemName
					mainModule.addDetails(PartCache, ItemName, RAP, Type, unobs)
				end
			else
				local Type = "Accessory"
				if game.ReplicatedStorage.Limiteds[Rarity]:FindFirstChild(ItemName) == nil then
					LoadedAsset[1].Parent = game.ReplicatedStorage.Limiteds:FindFirstChild(Rarity)
					LoadedAsset[1].Name = ItemName
					mainModule.addDetails(LoadedAsset[1], ItemName, RAP, Type, unobs)
				end
			end
		end
		print('ALL UNOBS HAVE LOADED.')
		wait(.1)
		for _,v in pairs(mainModule.Limiteds) do
			local URL = "https://economy.roproxy.com/v1/assets/"..tostring(v).."/resale-data"
			local ProductInfo = MPS:GetProductInfo(v)
			local Data = HTTP:GetAsync(URL)
			Data = HTTP:JSONDecode(Data)

			local ItemName = ProductInfo.Name
			local RAP = Data.recentAveragePrice
			local Desc = ProductInfo.Description
			local Rarity = mainModule.detectRarity(RAP)
			local LoadedAsset = Insert:LoadAsset(v):GetChildren()
			
			if LoadedAsset[1]:IsA("Decal") then
				local Type = "Face"
				if game.ReplicatedStorage.Limiteds[Rarity]:FindFirstChild("ItemName") == nil then
					local PartCache = game.ReplicatedStorage:WaitForChild("Beauty"):Clone()
					PartCache.Parent = game.ReplicatedStorage.Limiteds[Rarity]
					PartCache.Anchored = true
					LoadedAsset[1].Parent = PartCache
					LoadedAsset[1].Name = ItemName
					PartCache.Name = ItemName
					mainModule.addDetails(PartCache, ItemName, RAP, Type, v)
				end
			else
				local Type = "Accessory"
				if game.ReplicatedStorage.Limiteds[Rarity]:FindFirstChild(ItemName) == nil then
					LoadedAsset[1].Parent = game.ReplicatedStorage.Limiteds:FindFirstChild(Rarity)
					LoadedAsset[1].Name = ItemName
					mainModule.addDetails(LoadedAsset[1], ItemName, RAP, Type, v)
				end
			end

			loadedLims.Value += 1
		end
		print('ALL THE LIMITEDS HAVE SUCCESSFULLY LOADED!!!')
	else
		print("Wrong Password!")
	end
end
function mainModule:locateLimited(name)
	for _,v in pairs(game.ReplicatedStorage.Limiteds:GetDescendants()) do
		if v.Name == "NativeName" and v.Value == name then
			--print("Returned "..v.Parent.Parent.Name.." for "..v.Name)
			return v.Parent.Parent.Name
		end
	end
end
function mainModule:refreshLimiteds(passcode)
	if passcode == "i" and game:GetService("RunService"):IsServer() then
		game.ReplicatedStorage.LoadLimiteds:FireAllClients()
		local loadedLims = game.ReplicatedStorage.Server_Data.Loaded
		loadedLims.Value = 0
		game.ReplicatedStorage.Server_Data.Total.Value = mainModule.Length(mainModule.Limiteds)
		for _,v in pairs(mainModule.Limiteds) do
			local URL = "https://economy.roproxy.com/v1/assets/"..tostring(v).."/resale-data"
			local ProductInfo = MPS:GetProductInfo(v)
			local Data = HTTP:GetAsync(URL)
			Data = HTTP:JSONDecode(Data)
			local ItemName = ProductInfo.Name
			local RAP = Data.recentAveragePrice
			--print("RAP for "..ItemName..": "..RAP)
			local Rarity = mainModule.detectRarity(RAP)
			--print("Rarity for "..ItemName..": "..Rarity)
			local Yes = mainModule:locateLimited(ItemName)
			local Prev = game.ReplicatedStorage.Limiteds[Yes][ItemName]
			--print(Yes.." = "..Prev.Name)
			--[[local toprint = {
				Name = ItemName,
				OldRAP = Prev.RAP.Value,
				RAP = Data.recentAveragePrice,
				OldRarity = Prev.Parent.Name,
				NewRarity = Rarity,				
			}
			print(toprint)--]]
			if Prev ~= "" and (RAP ~= nil or "") then
				if Prev.RAP.Value ~= tostring(RAP) then
					print("A new rap is detected for "..Prev.Name..", old RAP: "..Prev.RAP.Value..", new RAP: "..RAP)
					Prev.RAP.Value = tostring(RAP)
					local Rar = Prev.Parent.Name
					if Rar ~= Rarity then
						print("Rarity changed to "..Rarity.." from "..Rar.." for "..ItemName)
						Prev.Parent = game.ReplicatedStorage.Limiteds[Rarity]
					end
				end
			else
				print(Prev.Name.." is nil!")
			end
			loadedLims.Value += 1
		end
		game.ReplicatedStorage.FinishedLoading:FireAllClients()
	else
		print("Wrong Password!")
	end
end


return mainModule

