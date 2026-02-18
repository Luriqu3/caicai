


















































storage.taskParams = storage.taskParams or {
    taskFinalized = false,
    progress = 0,
    total = 0,
    mobName = ""
}

onTextMessage(function(mode, text)
    if not text then return end
    local ltext = text:lower()


    if ltext:find("sua task é matar") then
        local mob = ltext:match("matar %s+(.*)")
        if mob then
            storage.taskParams.mobName = mob
        end
        storage.taskParams.taskFinalized = false
        storage.taskParams.progress = 0
        storage.taskParams.total = 0
        return
    end


    if ltext:find("completou a task") then
        storage.taskParams.taskFinalized = true
        return
    end


    if ltext:find("%[task%]") then
        local defeated, total = ltext:match("(%d+)%s*/%s*(%d+)")
        if defeated and total then
            defeated, total = tonumber(defeated), tonumber(total)
            storage.taskParams.progress = defeated
            storage.taskParams.total = total

            if defeated == total then
                storage.taskParams.taskFinalized = true
            else
                storage.taskParams.taskFinalized = false
            end

            return
        end
    end
end)

function getTaskParams()
    return storage.taskParams
end





onTalk(function(name, level, mode, text, channelId, pos)
    if name ~= "Zamasu" then return end
    local inicio = text:match("Sua task é matar ([^.]+%.)")
    local proxima = text:match("Sua próxima task é matar ([^.]+%.)")

    local mob = inicio or proxima
    if not mob then return end
    say("matar " .. mob)
end)











local configTaskZamasu = {
['\072\117\109\097\110\111\105\100\032\067\121\098\111\114\103'] = { cave = '\114\113\116\104\099' },
['\065\116\108\097\110\116\105\100'] = { cave = '\114\113\116\097\116' },
['\068\114\097\103\111\110'] = { cave = '\114\113\116\100\103' },
['\078\097\109\101\106\105\110\032\087\097\114\114\105\111\114'] = { cave = '\114\113\116\110\119' },
['\078\097\109\101\107'] = { cave = '\114\113\116\110' },
['\084\097\110\107'] = { cave = '\114\113\116\116' },
['\082\111\098\111\116\114\111\110'] = { cave = '\114\113\116\114\098' },
['\084\115\117\102\117\108'] = { cave = '\114\113\116\116\115\117' },
['\065\110\099\101\115\116\114\097\108\032\071\117\097\114\100\105\097\110'] = { cave = '\114\113\116\097\103' },
['\066\108\097\099\107\032\068\114\097\103\111\110'] = { cave = '\114\113\116\098\100' },
['\080\097\105\107\117\104\097\110'] = { cave = '\114\113\116\112\097\105' },
['\083\117\112\101\114\032\080\097\105\107\117\104\097\110'] = { cave = '\114\113\116\115\117\112\101\114\112\097\105' },
['\069\118\105\108\032\084\115\117\102\117\108'] = { cave = '\114\113\116\101\118\116\115\117' },
['\069\118\105\108\032\086\101\103\101\116\116\111'] = { cave = '\114\113\116\101\118\118\103\116' },
['\070\114\111\110\116\097\108\032\067\121\098\111\114\103'] = { cave = '\114\113\116\102\099' },
['\072\101\108\108\032\074\097\110\101\109\098\097'] = { cave = '\114\113\116\104\106' },
['\075\105\110\103\032\086\101\103\101\116\097'] = { cave = '\114\113\116\107\118' },
['\076\105\032\083\104\101\110\114\111\110\032\077\097\120'] = { cave = '\114\113\116\108\115\109' },
['\085\117\032\083\104\101\110\108\111\110\103'] = { cave = '\114\113\116\117\115' },
    }


    onTalk(function(name, level, mode, text, channelId, pos)
        if name ~= player:getName() then return; end
        if not string.find(text, 'mata') then return; end
        local lowerText = string.lower(text)
        for key, value in pairs(configTaskZamasu) do
            if lowerText:find(string.lower(key)) then
                CaveBot.setOff()
                storage._configs.cavebot_configs.selected = value.cave
                CaveBot.setOn()
            end
        end
    end)



local configPegarTask = {
['\116\097\115\107'] = { cave = '\112\101\103\097\114\084\097\115\107' },

    }


    onTalk(function(name, level, mode, text, channelId, pos)
        if name ~= player:getName() then return; end
        if not string.find(text, '/') then return; end
        local lowerText = string.lower(text)
        for key, value in pairs(configPegarTask) do
            if lowerText:find(string.lower(key)) then
                CaveBot.setOff()
                storage._configs.cavebot_configs.selected = value.cave
                CaveBot.setOn()
            end
        end
    end)















setDefaultTab("tools")

incompleteTaskMacro = macro(1000, "Task Atual", function() end)

onTalk(function(name, level, mode, text, channelId, pos)
    if not incompleteTaskMacro.isOn() then return end
    if name ~= "Zamasu" then return end

  
    local mob = text:match("task atual de ([^%.]+)")
    if not mob then return end
    say("matar " .. mob)
    incompleteTaskMacro.setOff()
end)



local checkAol = 11841
macro(3000, "Comprar aol", function()
  if getFinger() and getFinger():getId(checkAol) then return end
  say("!aol")
end)


blessTalk = {
    {'Deseja adquirir uma', 'bless'},
    {'Deseja comprar', 'yes'},
}

local hasBless = false
local stopTime
local blessNames = {"Blessing Seller"} 


function getDistanceFromPlayer(pos)
    local playerPos = player:getPosition()
    if not playerPos or not pos then return nil end
    return math.max(math.abs(playerPos.x - pos.x), math.abs(playerPos.y - pos.y), math.abs(playerPos.z - pos.z))
end

local blessScript = macro(100, 'Fast Bless', function()
    if hasBless then return end
    if stopTime and stopTime >= now then return end

   
    for _, blessName in ipairs(blessNames) do
        local findNpc = getCreatureByName(blessName)
        if not findNpc then goto continue end

       
        if getDistanceFromPlayer(findNpc:getPosition()) <= 3 then
            NPC.say('hi')
            delay(3000)
            return
        end

        ::continue::
    end
end)


onTalk(function(name, level, mode, text, channelId, pos)
  
    if not table.find(blessNames, name) then return end
    if blessScript.isOff() then return end

    local lowerText = text:lower()

  
    for _, phrase in ipairs(blessTalk) do
        if lowerText:find(phrase[1]:lower()) then
            schedule(200, function()
                NPC.say(phrase[2])
            end)
        end
    end

    
    if lowerText:find('possui a bless') or lowerText:find('possui a bless') then
        hasBless = true
        modules.game_textmessage.displayGameMessage("Rique Blessed")
        return
    end



  
    if lowerText:find('nao tem') then
        warn('Sem gold, liso!')
        stopTime = now + 60000
        return
    end
end)



local secondsToIdle = 5
local activeFPS =  60
---------------------------------------------------------

local afkFPS = 0
function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end



local function isSameMousePos(p1,p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4
macro(250, "Afk Mode", function()
  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos,currentMousePos) then return end
    botPrintMessage("on")
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos,currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    botPrintMessage("AFK")
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end

end)

  local ui = setupUI([[
Panel

  height: 25

  Label
    id: editCustom2
    color: red
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25


  ]], parent)


















