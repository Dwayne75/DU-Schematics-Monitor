---
--- Created by Zrips#9691.
--- DateTime: 2022-10-14 11:33
---
---


screens = {}
container = nil
requestingUpdateContent = false

mfloor = math.floor

for key, value in pairs(unit) do
    if type(value) == "table" and type(value.export) == "table" then
        if value.getClass then
            if value.getClass() == "ScreenUnit" then
                screens[#screens + 1] = { screen = value, slot = key, second = string.match(value.getName():lower(), "screen_2") ~= nil }
            elseif value.getClass() == "CoreUnitStatic" or value.getClass() == "CoreUnitSpace" or value.getClass() == "CoreUnitDynamic" then
                core = value
            elseif string.match(value.getClass():lower(), "container") then
                container = value
            end
        end
    end
end

if not container then
    system.print("Container NOT found")
end

schematics = {}

local tempTier = 0
local left = true

function addSchematic(id, max, priority)
    local item = system.getItem(id)

    local name = item.locDisplayName:gsub("Schematic Copy", "")
    name = name:gsub("Tier " .. tempTier, "")
    name = name:gsub("Construct Support", "")
    name = name:gsub("Core Unit", "")

    schematics[#schematics + 1] = { id = id, name = name, max = max, tier = tempTier, priority = priority, left = left }
end

function loadInSchematics()

    tempTier = 1
    -- Tier 1 Product Material
    addSchematic(690638651, 6000, true)
    -- Tier 1 XS Element
    addSchematic(1910482623, 50)
    -- Tier 1 S Element
    addSchematic(4148773283, 50)
    -- Tier 1 M Element
    addSchematic(2066101218, 50, true)
    -- Tier 1 L Element
    addSchematic(2068774589, 100, true)
    -- Tier 1 XL Element
    addSchematic(304578197, 50)
    -- Tier 1 Honeycomb
    addSchematic(2479827059, 500, false)

    tempTier = 2
    -- Tier 2 Product Material
    addSchematic(4073976374, 4000, true)
    -- Tier 2 Pure Material
    addSchematic(3332597852, 4000, true)
    -- Tier 2 XS Element
    addSchematic(2096799848, 40)
    -- Tier 2 S Element
    addSchematic(1752968727, 40)
    -- Tier 2 M Element
    addSchematic(2726927301, 40, true)
    -- Tier 2 L Element
    addSchematic(616601802, 60, true)
    -- Tier 2 XL Element
    addSchematic(3677281424, 40)
    -- Tier 2 Honeycomb
    addSchematic(632722426, 500, false)
    -- Tier 2 Honeycomb
    addSchematic(625377458, 500, false)

    tempTier = 3
    -- Tier 3 Product Material
    addSchematic(3707339625, 1000, true)
    -- Tier 3 Pure Material
    addSchematic(2003602752, 1000, true)
    -- Tier 3 XS Element
    addSchematic(787727253, 30)
    -- Tier 3 S Element
    addSchematic(425872842, 30)
    -- Tier 3 M Element
    addSchematic(3713463144, 30, true)
    -- Tier 3 L Element
    addSchematic(1427639881, 30, true)
    -- Tier 3 XL Element
    addSchematic(109515712, 30)
    -- Tier 3 Honeycomb
    addSchematic(2343247971, 500, false)
    -- Tier 3 Honeycomb
    addSchematic(4221430495, 500, false)

    tempTier = 6
    -- Construct Support XS
    addSchematic(1477134528, 100)
    -- Construct Support S
    addSchematic(1224468838, 100)
    -- Construct Support M
    addSchematic(1861676811, 200, true)
    -- Construct Support L
    addSchematic(784932973, 200, true)

    left = false

    tempTier = 4
    -- Tier 4 Product Material
    addSchematic(2485530515, 500)
    -- Tier 4 Pure Material
    addSchematic(2326433413, 500)
    -- Tier 4 XS Element
    addSchematic(210052275, 30)
    -- Tier 4 S Element
    addSchematic(3890840920, 30)
    -- Tier 4 M Element
    addSchematic(3881438643, 30)
    -- Tier 4 L Element
    addSchematic(1614573474, 30)
    -- Tier 4 XL Element
    addSchematic(1974208697, 30)
    -- Tier 4 Honeycomb
    addSchematic(3743434922, 500, false)
    -- Tier 4 Honeycomb
    addSchematic(99491659, 500, false)

    tempTier = 5
    -- Tier 5 Product Material
    addSchematic(2752973532, 500)
    -- Tier 5 Pure Material
    addSchematic(1681671893, 500)
    -- Tier 5 XS Element
    addSchematic(1513927457, 30)
    -- Tier 5 S Element
    addSchematic(880043901, 30)
    -- Tier 5 M Element
    addSchematic(3672319913, 30)
    -- Tier 5 L Element
    addSchematic(86717297, 30)
    -- Tier 5 XL Element
    addSchematic(1320378000, 30)
    -- Tier 5 Honeycomb
    addSchematic(1885016266, 500, false)
    -- Tier 5 Honeycomb
    addSchematic(3303272691, 500, false)

    tempTier = 7
    -- Core Unit xs
    addSchematic(120427296, 10)
    -- Core Unit s
    addSchematic(1213081642, 10)
    -- Core Unit M
    addSchematic(1417495315, 20)
    -- Core Unit L
    addSchematic(1202149588, 20)

    tempTier = 8
    -- Warp cells
    addSchematic(363077945, 5000, true)
    -- Atmo Fuel
    addSchematic(3077761447, 5000)
    -- Space Fuel
    addSchematic(1917988879, 5000)
    -- Rocket Fuel
    addSchematic(3992802706, 2000)
end

loadInSchematics()

unit.hideWidget()

function formatScript(data)
    return [[---
--- Created by Zrips#9691.
--- DateTime: 2022-10-05 15:12
---

font = loadFont('Play', 25)
smallFont = loadFont('Play', 15)
midFont = loadFont('Play', 20)

if not init then
    init = true

    lastUpdate = getTime()

    mfloor = math.floor
    mceil = math.ceil

    cyanColor = { r = 135 / 255, g = 206 / 255, b = 235 / 255 }
    uiSettings = { r = 37 / 255, g = 57 / 255, b = 64 / 255 }
    barColor1 = { r = 255 / 255, g = 255 / 255, b = 255 / 255 }
    orangeColor = { r = 224 / 255, g = 165 / 255, b = 85 / 255 }
    backgroundColor = { r = 13 / 255, g = 24 / 255, b = 28 / 255 }

    barColorGood = { r = 4 / 255, g = 159 / 255, b = 0 / 255 }
    barColorBad = { r = 177 / 255, g = 80 / 255, b = 0 / 255 }

    realX, realY = getResolution()
    -- Inverting
    ry, rx = realX, realY

    barStartY = 40

    barHeight = 25
    barWidth = 130
    barSpacing = 4

    barInset = 2

    sectionSpacing = 20

    textBarSpacing = 10

    blocks = ]] .. data .. [[
    function round(number, decimals)
        local power = 10 ^ decimals
        return mfloor(number * power) / power
    end

    function mixColors(color1, color2, percent)
        local inverse_percent = 1 - percent
        local redPart = color2.r * percent + color1.r * inverse_percent
        local greenPart = color2.g * percent + color1.g * inverse_percent
        local bluePart = color2.b * percent + color1.b * inverse_percent
        return { r = redPart, g = greenPart, b = bluePart };
    end

    function round(number, decimals)
        local power = 10 ^ decimals
        return mceil(number * power) / power
    end
end

local layer = createLayer()
setLayerOrigin(layer, realX / 2, realY / 2)
setLayerTranslation(layer, (realX - realY) / 2, realY / 3)
setLayerRotation(layer, 1.5708)
setBackgroundColor(backgroundColor.r, backgroundColor.g, backgroundColor.b)

local pos = 0
local localPos = 1

function drawLine(material, y)

    local alpha = 0.8
    if localPos % 2 == 0 then
        alpha = 0.1
    end

    setNextFillColor(layer, uiSettings.r, uiSettings.g, uiSettings.b, alpha)
    setNextStrokeColor(layer, 0, 0, 0, 0)
    setNextStrokeWidth(layer, 0)
    addBox(layer, textBarSpacing * 2, y, rx - (textBarSpacing * 4), barHeight)

    local progress = 0
    if material.max > 0 then
        progress = mfloor(material.volume * 100 / material.max)
    end

    if progress > 100 then
        progress = 100
    end

    local width = progress * barWidth / 100

    setNextTextAlign(layer, AlignH_Left, AlignV_Middle)
    local textX = (textBarSpacing * 2)
    local barX = rx - (textBarSpacing * 2) - barWidth
    local secBarX = barX + 2
    local volumeX = barX - textBarSpacing
    local percentX = barX + (barWidth / 2)

    alpha = 1

    -- Material name section
    if material.p and progress < 100 and material.max > 0 then
        setNextFillColor(layer, orangeColor.r, orangeColor.g, orangeColor.b, alpha)
    else
        setNextFillColor(layer, barColor1.r, barColor1.g, barColor1.b, alpha)
    end

    addText(layer, midFont, material.name, textX, y + (barHeight / 2))

    -- Bar background section
    setNextFillColor(layer, uiSettings.r, uiSettings.g, uiSettings.b, alpha)
    setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, alpha)
    setNextStrokeWidth(layer, 0.01)
    addBox(layer, barX, y, barWidth, barHeight)

    if progress > 0 then
        -- Dynamic bar section
        local fillColor = mixColors(barColorBad, barColorGood, progress / 100)
        setNextFillColor(layer, fillColor.r, fillColor.g, fillColor.b, 1)
        setNextStrokeColor(layer, 0, 0, 0, 0)
        addBox(layer, secBarX, y + barInset, width - (barInset * 2), barHeight - (barInset * 2))
    end

    -- Percentage section
    setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
    setNextStrokeColor(layer, 0.1, 0.1, 0.1, 0.8)
    setNextStrokeWidth(layer, alpha)
    setNextFillColor(layer, barColor1.r, barColor1.g, barColor1.b, alpha)
    addText(layer, smallFont, progress .. "%", percentX, y + (barHeight / 2))


    -- Volume section
    setNextTextAlign(layer, AlignH_Right, AlignV_Middle)
    setNextStrokeColor(layer, 0.1, 0.1, 0.1, 0.8)
    setNextStrokeWidth(layer, alpha)
    setNextFillColor(layer, barColor1.r, barColor1.g, barColor1.b, alpha)
    addText(layer, smallFont, mfloor(material.volume) .. " / " .. mfloor(material.max), volumeX, y + (barHeight / 2))
end

local offset = 0
local prevTier = 0

local sectionStartY = 0

function drawBorder()

    setNextFillColor(layer, 0, 0, 0, 0)
    setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 0.5)
    setNextStrokeWidth(layer, 0.01)
    addBox(layer, barSpacing * 4, sectionStartY - barHeight, rx - (barSpacing * 8), barStartY + (pos * (barHeight + barSpacing)) + offset - sectionStartY - (barSpacing * 2))

end

for id, schematic in ipairs(blocks) do

    if prevTier ~= schematic.tier then
        offset = offset + (barSpacing * 1.8) + barHeight
        prevTier = schematic.tier
        localPos = 1

        if sectionStartY > 0 then
            drawBorder()
        end

        sectionStartY = barStartY + (pos * (barHeight + barSpacing)) + offset

        local tierName = "Tier " .. schematic.tier

        if schematic.tier > 5 then
            if schematic.tier == 6 then
                tierName = "Construct Support"
            elseif schematic.tier == 7 then
                tierName = "Core Unit"
            elseif schematic.tier == 8 then
                tierName = "Consumables"
            end
        end

        setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
        setNextFillColor(layer, barColor1.r, barColor1.g, barColor1.b, 1)
        addText(layer, font, tierName, rx / 2, barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))

    end

    drawLine(schematic, barStartY + (pos * (barHeight + barSpacing)) + offset)
    pos = pos + 1
    localPos = localPos + 1
end

offset = offset + (barSpacing * 1.8) + barHeight
drawBorder()

setNextFillColor(layer, barColor1.r, barColor1.g, barColor1.b, 0)
setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 1)
setNextStrokeWidth(layer, 0.1)
addBox(layer, 10, 10, rx - 20, ry - 20)

if lastUpdate + 30 > getTime() then
    setNextFillColor(layer, 1, 1, 1, 0.5)
    setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
    addText(layer, midFont, mfloor(30 - (getTime() - lastUpdate)) .. "s", 35, 30)
end

setNextFillColor(layer, 1, 1, 1, 0.5)
setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
addText(layer, font, "Schematics Bank", rx / 2, 30)

function addPriorityInfo()

    setNextFillColor(layer, orangeColor.r, orangeColor.g, orangeColor.b, 1)
    setNextTextAlign(layer, AlignH_Right, AlignV_Middle)
    addText(layer, smallFont, "Priority", rx - 50, 30)

    setNextFillColor(layer, orangeColor.r, orangeColor.g, orangeColor.b, 1)
    setNextStrokeColor(layer, 0, 0, 0, 0)
    addBox(layer, rx - 40, 20, 20, 20)
end
addPriorityInfo()

requestAnimationFrame(30)]]


end

function updateScreens()

    local SerializedContentsLeft = serialize(contentsLeft)
    local SerializedContentsRight = serialize(contentsRight)

    for id, screenObject in ipairs(screens) do
        local script = ""
        if screenObject.second then
            script = formatScript(SerializedContentsRight)
        else
            script = formatScript(SerializedContentsLeft)
        end
        screenObject.screen.setRenderScript(script)
    end
end

function update()
    requestingUpdateContent = true
    container.updateContent()
end

function getExisting(id)
    for i, item in ipairs(tempInfo) do
        if item.id == id then
            return i, item
        end
    end
    return -1, nil
end

function getExistingSchematic(id)
    for i, item in ipairs(schematics) do
        if item.id == id then
            return item
        end
    end
    return nil
end

function generateItemUpdate()
    local map = container.getContent()
    tempInfo = {}
    for _, i in ipairs(map) do
        local schem = getExistingSchematic(i.id)
        if schem ~= nil then
            local item = system.getItem(i.id)
            local existingId, existingItem = getExisting(item.id)
            if existingItem == nil then
                tempInfo[#tempInfo + 1] = { id = item.id, name = item.displayName:gsub("Schematic Copy", ""), volume = mfloor(i.quantity), max = schem.max, tier = item.tier, p = schem.priority }
            else
                existingItem.volume = mfloor(existingItem.volume + i.quantity)
                tempInfo[existingId] = existingItem
            end
        end
    end
    return tempInfo
end

function fillMissing()
    infoLeft = {}
    infoRight = {}
    for id, schematic in ipairs(schematics) do
        local id, existing = getExisting(schematic.id)
        if schematic.left then
            if not existing then
                infoLeft[#infoLeft + 1] = { name = schematic.name, volume = 0, max = schematic.max, tier = schematic.tier, p = schematic.priority }
            else
                infoLeft[#infoLeft + 1] = { name = schematic.name, volume = existing.volume, max = schematic.max, tier = schematic.tier, p = schematic.priority }
            end
        else
            if not existing then
                infoRight[#infoRight + 1] = { name = schematic.name, volume = 0, max = schematic.max, tier = schematic.tier, p = schematic.priority }
            else
                infoRight[#infoRight + 1] = { name = schematic.name, volume = existing.volume, max = schematic.max, tier = schematic.tier, p = schematic.priority }
            end
        end
    end
    return infoLeft, infoRight
end

function containerContentUpdate()
    lastRequest = system.getArkTime()
    requestingUpdateContent = false
    generateItemUpdate()
    contentsLeft, contentsRight = fillMissing()
    updateScreens()
end

update()

unit.setTimer('update', 1)