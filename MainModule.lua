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
	494291269, --SSHF
	1365767, --Valkyrie Helm
	2409285794, --Playful Vampire
	20573078, --Shaggy
	21070012, --Dominus Empyreus
	138932314, --Dominus Aureus
	20052135, --Prankster
	19027209, --PLBH
	583721561, --Blue Wistful Wink
	583722932, --Green Wistful Wink
	583722710, --Purple Wistful Wink
	71484026, --Sinister Branches
	321570512, --Chill Cap
	74891470, --Frozen Horns of the Frigid Planes
	439945661, --Silver King of the Night
	44113968, --Kuddle E. Koala
	334656210, --Miss Scarlet
	564449640, --Beautiful Hair for Beautiful Space People
	215718515, --Fiery Horns of the Netherworld
	124730194, --Blackvalk
	6803400584, --Gucci Spiked Basketball Bag
	6803405665, --Gucci Dionysus Bag
	6803412842, --Gucci Diamond Framed Sunglasses
	6803407328, --Gucci Bloom Perfume
	6807138720, --Gucci GG Marmont Bag
	6807133411, --Gucci Horsebit 1955 shoulder bag
	8853102495, --Gucci Glam Rock Shoulder...
	1117744489, --Dangerous Eye-patch
	1744198126, --Casual Sunglasses Pocket
	140469731, --Festive Narwhal
	15857936, --Tee-vee
	1772531407, --Green Ultimate Dragon Face
	553707410, --Rusty Chrome Shades
	16985920, --Pink Penguin
	119917015, --Shooting Star
	161211433, --Shooting Star 2014
	1149615185, --Autumn King Crown
	2830496106, --Torque the Blue Orc
	1191162013, --Blue Goof
	489176525, --Omega Rainbow Top Hat
	1772529256, --Blue Ultimate Dragon Face
	1016184756, --Crimson Evil Eye
	1016185809, --Golden Evil Eye
	8274214179, --NFL Golden Football
	1191162539, --Green Goof
	556821517, --Golden Chrome Shades
	212971414, --Neon Green Equinox
	188003527, --Winter King Crown
	1016185535, --Emerald Evil Eye
	1191125008, --Red Goof
	1230403652, --Camo Commando
	2222774106, --Green Starry Sight
	1772530315, --Red Ultimate Dragon Face
	302281542, --Omega Rainbow Top Hat
	835094544, --Green AmazeFace
	554663566, --Manicbot 10000
	928908332, --Black Iron Commando
	82332313, --Rainbow Equinox
	2222775067, --Blue Starry Sight
	259424300, --Universal Fedora
	835095003, --Blue AmazeFace
	9254254, --Rubber Duckie
	2222775930, --Violet Starry Sight
	2569005011, --Snow Queen Smile
	835095880, --Rose AmazeFace
	835095306, --Lavender AmazeFace
	241542617, --Frozen Horns of the Dangerous Ones
	50453968, --Mr. Rabbit
	17450053, --Sinister P.
	2568801198, --SO Super Excited- Pink
	110207471, --Egg on your face
	362029470, --Bombastic Scary Hood
	554663025, --CuckooCrazyBot 10K
	402304145, --Friendly Trusting Smile
	2569001052, --So Super Excited- Blue
	7893468574, --Heart Gaze - Zara Larsson
	151789690, --DIY DOMINUS Empyreus
	89624140, --Shady Business Hat
	380754227, --Green Bubble Trouble
	169454280, --Brighteyes top hat
	110336757, --Evil Skeptic
	362051899, --Violet Fang
	362051999, --Purple Bubble Trouble
	2225761296, --Radioactive Beast Mode
	330296924, --Blue Bubble Trouble
	376806474, --Neon Pink Top Hat
	65417235, --Azure Pinstripe Fedora
	7636350, --Supa Fly Cap
	108147416, --Bunny Ear Fedora
	2620506513, --Crybaby
	19704809, --Elf Ears
	259424866, --Midnight Commando
	31252891, --Skull Bandit
	106709262, --Timeless Top Hat
	1172161, --The Bluesteel Bathelm
	376812961, --Purple Super Happy Joy
	1213472762, --Catching Snowflakes
	25306182, --LOLHOO
	383607653, --Monarch Butterfly Smile
	238983270, --Purple Butterfly Smile
	24727929, --Butterfly
	74214775, --Valkyrie 3000
	135470963, --Lime Green Shaggy
	172309861, --Purple Shaggy
	6807137300, --Gucci Dionysus Bee Bag
	323191596, --Green Super Happy Joy
	50382508, --LOLEARTH
	406000421, --Red Seriously Scar Face
	134086163, --Chrome Glasses
	28278529, --Dancing Banana
	162372650, --LOLMOON
	5013615, --Sapphire Eye
	1563352, --Green Banded Top Hat
	162066057, --Adurite Antlers
	323191979, --Blue Eyeroll
	362051405, --True-Love Smile
	1081239, --Bucket
	1185264, --Emerald Eye
	2568804274, --So Super Excited- Purple
	151786902, --Neon Green Beautiful Hair
	554658475, --Madbot 10K
	158068502, --Omega Rainbow Helmet
	162066176, --Adurite Fedora with Black Iron Accent
	173780221, --Cookie Clicker
	440739518, --Blue Galaxy Gaze
	439945864, --Gold King of the Night
	20418682, --Bandage
	164204277, --Tasteless TopHat
	82332012, --Rainbow Fedora
	12313531, --W's TopHat
	440739240, --Purple Galaxy Gaze
	119916824, --Midnight Blue Shaggy
	4390890198, --Viridian Domino Crown
	66330295, --Red RAWR
	106689944, --Blizzaria the frozen
	66319941, --Golden Shiny Teeth
	105344861, --Rubywrath Dragon
	60115635, --Sinister Fedora
	1587175771, --Overseer Wings of Terror
	121260018, --American Commando
	440738448, --Pink Galaxy Gaze
	19264845, --Bubble Trouble
	175134718, --Blackvalk Shades
	130213380, --ROBLOX Madness Face
	628771505, --Black Iron Horns
	878895806, --Gold Emperor of the Night
	362029620, --GoldLika: Boss
	1323384, --The ICECROWN
	439946249, --Black Iron King of the Night
	98346834, --Bluesteel Fedora
	209994352, --Eyes of Emeraldwrath
	416846000, --Yellow Glowing Eyes
	398676450, --Green Glowing Eyes
	1235488, --Clockwork's Headphones
	39247441, --Subarctic Commando
	49493376, --Eyes of crimsonwrath
	183468963, --Ghosdeeri
	68258723, --Bluesteel Domino Crown
	26343188, --Tattletale
	527365852, --Dominus Praefectus
	26019070, --Yum!
	24123795, --Al Capwn
	193659065, --Golden Antlers
	1029025, --Classic ROBLOX Fedora
	398674241, --GoldLika: Troll
	1560601706, --Counterfeit Domino Crown
	387256603, --Silver Punk Face
	4390891467, --Ice Valkyrie
	21024661, --Optimist
	1272714, --wanwood antlers
	440739783, --Green Galaxy Gaze
	39247498, --Arctic Commando
	119812659, --Punk Face
	22920501, --Troublemaker
	102605392, --Red Bucket of Cheer
	4255053867, --Dominus Formidulosus
	209995252, --Blizzard Beast Mode
	128992838, --Beast Mode
	72082328, --Red Sparkle Time
	119916949, --Midnight Blue Sparkle Time
	63043890, --Purple Sparkle Time
	100929604, --Green Sparkle Time
	259423244, --Black Sparkle Time
	2830437685, --Emerald Valkyrie
	16652251, --Red tango
	493476042, --Sky blue Sparkle Time
	64444871, --Dominus Messor
	1180433861, --Sparkle Time Valkyrie
	557057917, --Interstellar Wings
	147180077, --Teal Sparkle Time
	250395631, --Dominus Rex
	42211680, --Red Domino Crown
	215751161, --Orange Sparkle Time
	180660043, --Red Glowing Eyes
	1016143686, --White Sparkle Time
	11748356, --Clockwork's Shades
	1285307, --Sparkle Time Fedora
	96103379, --Dominus Vespertilio
	74891545, --Scary Hood
	48545806, --Dominus Frigidus
	64082730, --Rainbow Shaggy
	31101391, --Dominus Infernus
}


mainModule.Unobtainables = {
	187848395, --Workclock Shades
	172309919, --Workclock Headphones
	1082932, --Traffic Cone
	1048037, --Bighead
	5731049064, --Developer Longsword
	189963816, --Festive Sword Valkyrie
	7781687598, --VVOT
	2274774123, --Red Valkyrie
	42070576, --Epic Face
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

