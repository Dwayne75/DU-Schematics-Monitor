--[[ LUA PARAMETERS ]]
useDatabankValues = true --export: If checked and if values were saved in databank, parmaters will be loaded from the databank, if not, following ones will be used
checkSchematicsContainer = true --export: Should we indicate if linked container is set to be used as schematics container
local Localize = false --export: When enabled we will localize schematic names

screens = {}
databank = nil
container = nil
requestingUpdateContent = false

options = {}
options.checkSchematicsContainer = checkSchematicsContainer
options.Localize = Localize

mfloor = math.floor
mround = math.round
mabs = math.abs

linkedToSchemContainer = false

function round(number, decimals)
    local power = 10 ^ decimals
    return mfloor(mfloor(number * power)) / power
end

function getDirection(element)
    local position = "vl"
    if mabs(element.getUp()[1]) > mabs(element.getUp()[2]) and mabs(element.getUp()[1]) > mabs(element.getUp()[3]) then
        if element.getForward()[3] < 0 then
            position = "fd"
        else
            position = "fu"
        end
    else
        if mabs(element.getUp()[2]) > mabs(element.getUp()[3]) then
            if element.getUp()[2] > 0 then
                position = "vr"
            else
                position = "vl"
            end
        else
            if element.getUp()[3] > 0 then
                position = "hu"
            else
                position = "hd"
            end
        end
    end
    return position
end

for key, value in pairs(unit) do
    if type(value) == "table" and type(value.export) == "table" then
        if value.getClass then
            if value.getClass() == "ScreenUnit" then
                local screenNumber = 1
                if string.match(value.getName():lower(), "screen_") ~= nil then
                    screenNumber = tonumber(string.sub(value.getName():lower(), 8, 8))
                end

                screens[#screens + 1] = { screen = value, slot = key, sn = screenNumber, dir = getDirection(value)}
                value.activate()
            elseif value.getClass() == "CoreUnitStatic" or value.getClass() == "CoreUnitSpace" or value.getClass() == "CoreUnitDynamic" then
                core = value
            elseif value.getClass():lower() == "databankunit" then
                databank = value
            elseif string.match(value.getClass():lower(), "container") then
                container = value

                if construct.getSchematicContainerId() == value.getLocalId() then
                    linkedToSchemContainer = true
                end
            end
        end
    end
end

if #screens == 0 then
    system.print("No screen detected")
else
    local plural = ""
    if #screens > 1 then plural = "s" end
    system.print(#screens .. " screen" .. plural .. " connected")
end

if not container then
    system.print("Container NOT found")
end

if core == 0 then
    system.print("No core detected") else system.print("Core connected")
end

if not databank then
    system.print("No Databank Detected")
else
    system.print("Databank Connected")
    if (databank.hasKey("options")) and (useDatabankValues == true) then
        local db_options = json.decode(databank.getStringValue("options"))
        if db_options then
            for key, value in pairs(options) do
                if db_options[key] then options[key] = db_options[key] end
            end
            system.print("Options Loaded From Databank")
        else
            system.print("No parameters saved to Databank. Restart the Programming Board")
        end
    else
        system.print("Options Loaded From LUA Parameters")
    end
end

schematics = {}

tempTier = 0
subTempTier = 0
ScreenNumber = 1

function setTier(tier)
    tempTier = tier
end

function setSubTempTier(tier)
    subTempTier = tier
end

function moveToNextScreen()
    ScreenNumber = ScreenNumber + 1
end

function addSchematic(id, max, priority)
    local item = system.getItem(id)

    local name = Localize and item.locDisplayName or item.displayName

    -- English cleanup
    name = name:gsub("Schematic Copy", "")
    name = name:gsub("Tier " .. tempTier, "")
    name = name:gsub("Tier " .. subTempTier, "")
    name = name:gsub("Construct Support", "")
    name = name:gsub("Core Unit", "")
    name = name:gsub("Scrap", "")

    --German cleanup
    name = name:gsub("Stufe", "")
    name = name:gsub("-", " ")
    name = name:gsub("Schema", "")
    
    -- French cleanup
    name = name:gsub("Copie de schéma ", "")
    name = name:gsub("de soutien de construct", "")
    name = name:gsub("d'unités centrales", "")
    name = name:gsub("(de palier)", "")
    name = name:gsub("" .. tempTier, "")

    schematics[#schematics + 1] = { id = id, name = name, max = max, tier = tempTier, priority = priority, sn = ScreenNumber }
end

function formatScript(data, horizontal, inverted)
    return [[---
--- Created by Zrips#9691.
--- DateTime: 2022-10-05 15:12
--- Updated by Vtreka#1337
--- DateTime: 2023-02-26 00:48

font = loadFont('Play', 25)
smallFont = loadFont('Play', 15)
midFont = loadFont('Play', 20)
tinyFont = loadFont('Play', 10)

if not init then
    init = true

    lastUpdate = getTime()

    mfloor = math.floor
    mceil = math.ceil

    lowPriorityColor = { r = 128 / 255, g = 128 / 255, b = 128 / 255 } --export: Low Priority Colour
    cyanColor = { r = 135 / 255, g = 206 / 255, b = 235 / 255 }
    uiSettings = { r = 37 / 255, g = 57 / 255, b = 64 / 255 }
    tier1Color = { r = 255 / 255, g = 255 / 255, b = 255 / 255 } --export: Tier 1 Colour
    tier2Color = { r = 0 / 255, g = 255 / 255, b = 0 / 255 } --export: Tier 2 Colour
    tier3Color = { r = 0 / 255, g = 127 / 255, b = 255 / 255 } --export: Tier 3 Colour
    tier4Color = { r = 255 / 255, g = 0 / 255, b = 255 / 255 } --export: Tier 4 Colour
    tier5Color = { r = 255 / 255, g = 102 / 255, b = 0 / 255 } --export: Tier 5 Colour
    highPriorityColor = { r = 255 / 255, g = 50 / 255, b = 0 / 255 } --export: High Priority Colour
    backgroundColor = { r = 13 / 255, g = 24 / 255, b = 28 / 255 }
    redColor = { r = 254 / 255, g = 69 / 255, b = 0 / 255 }

    barColorGood = { r = 4 / 255, g = 159 / 255, b = 0 / 255 }
    barColorBad = { r = 177 / 255, g = 80 / 255, b = 0 / 255 }

    realX, realY = getResolution()

    barStartY = 40

    barHeight = 21
    barWidth = 130
    barSpacing = 4

    barInset = 2

    sectionSpacing = 20

    textBarSpacing = 10

    linkedToSchem = ]] .. tostring(linkedToSchemContainer) .. [[
    horizontal = ]] .. tostring(horizontal) .. [[
    inverted = ]] .. tostring(inverted) .. [[
    blocks = ]] .. data .. [[
   
    -- Inverting
    if not horizontal then
        ry, rx = realX, realY
    else
        rx, ry = realX, realY

        barHeight = barHeight * 0.52
        barWidth = barWidth * 0.6
        barStartY = barStartY * 0.6
    end

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
if not horizontal then
    setLayerOrigin(layer, realX / 2, realY / 2)

    if inverted then
        setLayerTranslation(layer, (realY - realX) / 2, -realY / 3)
        setLayerRotation(layer, -1.5708)
    else
        setLayerTranslation(layer, (realX - realY) / 2, realY / 3)
        setLayerRotation(layer, 1.5708)
    end

    font = loadFont('Play', 25)
    smallFont = loadFont('Play', 15)
    midFont = loadFont('Play', 20)
    tinyFont = loadFont('Play', 10)

else
    if inverted then
        setLayerOrigin(layer, realX / 2, realY / 2)
        setLayerRotation(layer, 3.14159)
    end
    font = loadFont('Play', 20)
    smallFont = loadFont('Play', 12)
    midFont = loadFont('Play', 12)
    tinyFont = loadFont('Play', 10)
end

setBackgroundColor(backgroundColor.r, backgroundColor.g, backgroundColor.b)

local pos = 0
local localPos = 1

local blockWidth = rx
if horizontal then
    blockWidth = blockWidth / #blocks
end

function getColor(material, progress)
    if material.p then
        if progress < 100 and material.max > 0 then
            return highPriorityColor
        end
        return tier1Color
    elseif material.p == nil and progress < 100 and material.max > 0 then
        return tier1Color
    end
    return lowPriorityColor
end

function drawLine(material, x, y)

    local alpha = 0.8
    if localPos % 2 == 0 then
        alpha = 0.1
    end

    local rx = x + blockWidth

    setNextFillColor(layer, uiSettings.r, uiSettings.g, uiSettings.b, alpha)
    setNextStrokeColor(layer, 0, 0, 0, 0)
    setNextStrokeWidth(layer, 0)
    addBox(layer, x + textBarSpacing * 2, y, blockWidth - (textBarSpacing * 4), barHeight)

    local progress = 0
    if material.max > 0 then
        progress = mfloor(material.volume * 100 / material.max)
    end

    if progress > 100 then
        progress = 100
    end

    local width = progress * barWidth / 100

    setNextTextAlign(layer, AlignH_Left, AlignV_Middle)
    local textX = x + (textBarSpacing * 2)
    local barX = rx - (textBarSpacing * 2) - barWidth
    local secBarX = barX + 2
    local volumeX = barX - textBarSpacing
    local percentX = barX + (barWidth / 2)

    alpha = 1

    -- Material name section

    local priorityColor = getColor(material, progress)
    setNextFillColor(layer, priorityColor.r, priorityColor.g, priorityColor.b, 0.5)

    if material.p and progress < 100 and material.max > 0 then
        setNextFillColor(layer, priorityColor.r, priorityColor.g, priorityColor.b, 0.5)
    elseif material.tier == 2 or material.tier == 11 then
        setNextFillColor(layer, tier2Color.r, tier2Color.g, tier2Color.b, 0.5)
    elseif material.tier == 3 or material.tier == 12 then
        setNextFillColor(layer, tier3Color.r, tier3Color.g, tier3Color.b, 0.5)    
    elseif material.tier == 4 or material.tier == 13 then
        setNextFillColor(layer, tier4Color.r, tier4Color.g, tier4Color.b, 0.5)
    elseif material.tier == 5 then
        setNextFillColor(layer, tier5Color.r, tier5Color.g, tier5Color.b, 0.5)
    end

    addText(layer, midFont, material.name, textX, y + (barHeight / 2))

    -- Bar background section
    setNextFillColor(layer, uiSettings.r, uiSettings.g, uiSettings.b, alpha)

    if horizontal then
        setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 0.5)
    else
        setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, alpha)
    end
    setNextStrokeWidth(layer, 0.1)
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
    if horizontal then
        setNextStrokeWidth(layer, 0.8)
    else
        setNextStrokeWidth(layer, alpha)
    end
    setNextFillColor(layer, priorityColor.r, priorityColor.g, priorityColor.b, 1)
    addText(layer, smallFont, progress .. "%", percentX, y + (barHeight / 2))

    -- Volume section
    setNextFillColor(layer, priorityColor.r, priorityColor.g, priorityColor.b, 0.5)

    setNextTextAlign(layer, AlignH_Right, AlignV_Middle)
    setNextStrokeColor(layer, 0.1, 0.1, 0.1, 0.8)
    setNextStrokeWidth(layer, 0.5)
    addText(layer, smallFont, mfloor(material.volume) .. " / " .. mfloor(material.max), volumeX, y + (barHeight / 2))
end

local offset = 0
local prevTier = 0
local sectionStartY = 0

function drawBorder(x)

    setNextFillColor(layer, 0, 0, 0, 0)
    if linkedToSchem then
        setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 0.5)
    else
        setNextStrokeColor(layer, redColor.r, redColor.g, redColor.b, 0.5)
    end
    setNextStrokeWidth(layer, 0.01)
    addBox(layer, x + (barSpacing * 4), sectionStartY - barHeight, blockWidth - (barSpacing * 8), barStartY + (pos * (barHeight + barSpacing)) + offset - sectionStartY - (barSpacing * 2))
end

function processBlock(bn, block)

    local lx = (bn - 1) * blockWidth

    for id, schematic in ipairs(block) do

        if prevTier ~= schematic.tier then
            offset = offset + (barSpacing * 1.8) + barHeight
            prevTier = schematic.tier
            localPos = 1

            if sectionStartY > 0 then
                drawBorder((bn - 1) * blockWidth)
            end

        sectionStartY = barStartY + (pos * (barHeight + barSpacing)) + offset

        local tierName = "Tier " .. schematic.tier

        if schematic.tier == 1 then
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))    
        elseif schematic.tier == 2 then
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier2Color.r, tier2Color.g, tier2Color.b, 0.5)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 3 then
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier3Color.r, tier3Color.g, tier3Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 4 then
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier4Color.r, tier4Color.g, tier4Color.b, 0.5)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 5 then
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier5Color.r, tier5Color.g, tier5Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 6 then
            tierName = "Construct Support"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 7 then
            tierName = "Core Unit"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 8 then
            tierName = "Deployables"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 9 then
            tierName = "Fuel"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 10 then
            tierName = "Scrap"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 11 then
            tierName = "Tier 2 Ammo"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier2Color.r, tier2Color.g, tier2Color.b, 0.5)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 12 then
            tierName = "Tier 3 Ammo"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier3Color.r, tier3Color.g, tier3Color.b, 1)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        elseif schematic.tier == 13 then
            tierName = "Tier 4 Ammo"
            setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
            setNextFillColor(layer, tier4Color.r, tier4Color.g, tier4Color.b, 0.5)
            addText(layer, midFont, tierName, lx + (blockWidth / 2), barStartY + (pos * (barHeight + barSpacing)) + offset - (barHeight / 2))
        end
    end

        drawLine(schematic, (bn - 1) * blockWidth, barStartY + (pos * (barHeight + barSpacing)) + offset)
        pos = pos + 1
        localPos = localPos + 1
    end
end

if horizontal then
    for ids, block in ipairs(blocks) do
        offset = 0
        prevTier = 0
        sectionStartY = 0

        pos = 0
        localPos = 1
        processBlock(ids, block)
        offset = offset + (barSpacing * 1.8) + barHeight
        drawBorder((ids - 1) * blockWidth)
    end
else
    processBlock(1, blocks)
    offset = offset + (barSpacing * 1.8) + barHeight
    drawBorder(0)
end

setNextFillColor(layer, tier1Color.r, tier1Color.g, tier1Color.b, 0)
setNextStrokeColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 1)
setNextStrokeWidth(layer, 0.1)
addBox(layer, 10, 10, rx - 20, ry - 20)

if lastUpdate + 30 > getTime() then
    setNextFillColor(layer, 1, 1, 1, 0.5)
    setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
    if horizontal then
        addText(layer, midFont, mfloor(30 - (getTime() - lastUpdate)) .. "s", 30, 20)
    else
        addText(layer, midFont, mfloor(30 - (getTime() - lastUpdate)) .. "s", 35, 30)
    end
end

local textY = 40

if horizontal then
    textY = 27
end

if linkedToSchem then
    setNextFillColor(layer, 1, 1, 1, 0.5)
else
    setNextFillColor(layer, redColor.r, redColor.g, redColor.b, 0.7)
end
setNextTextAlign(layer, AlignH_Right, AlignV_Baseline)
addText(layer, font, "Schematics Bank", rx / 2 + 50, textY)

setNextFillColor(layer, 1, 1, 1, 0.5)
setNextTextAlign(layer, AlignH_Left, AlignV_Baseline)
addText(layer, tinyFont, "v2.1", rx / 2 + 55, textY)

function priority(x, y, text, color, alpha)

    local boxSize = 10

    setNextFillColor(layer, color.r, color.g, color.b, alpha)
    setNextTextAlign(layer, AlignH_Right, AlignV_Middle)
    addText(layer, smallFont, text, x - boxSize - 5, y)

    setNextFillColor(layer, color.r, color.g, color.b, alpha)
    setNextStrokeColor(layer, 0, 0, 0, 0)
    addBox(layer, x - boxSize, y - (boxSize / 2), boxSize, boxSize)
end

function addPriorityInfo()

    if horizontal then
        setNextFillColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 1)
        setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
        addText(layer, smallFont, "Priority", rx - 190, 20)

        priority(rx - 20, 20, "Low", lowPriorityColor, 1)
        priority(rx - 65, 20, "Normal", tier1Color, 1)
        priority(rx - 125, 20, "High", highPriorityColor, 0.5)
    else
        setNextFillColor(layer, cyanColor.r, cyanColor.g, cyanColor.b, 1)
        setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
        addText(layer, smallFont, "Priority", rx - 100, 20)

        priority(rx - 20, 35, "Low", lowPriorityColor, 1)
        priority(rx - 70, 35, "Normal", tier1Color, 1)
        priority(rx - 140, 35, "High", highPriorityColor, 0.5)
    end
end
addPriorityInfo()

requestAnimationFrame(30)]]

end

function schematicsTracker()

    -- Keep ID as it is which if first number
    -- Second number defines amount you want to have
    -- Third value is optional, set it to true if you want it to be prioritized, set it to false for low priority
    -- keeping last value empty will make schematic normal priority

    setTier(1)
    -- Tier 1 Product Material
    addSchematic(690638651, 6000, true)
    -- Tier 1 XS Element
    addSchematic(1910482623, 50)
    -- Tier 1 S Element
    addSchematic(4148773283, 50)
    -- Tier 1 M Element
    addSchematic(2066101218, 50)
    -- Tier 1 L Element
    addSchematic(2068774589, 100)
    -- Tier 1 XL Element
    addSchematic(304578197, 50)
    -- Tier 1 Honeycomb
    addSchematic(2479827059, 500)

    setTier(2)
    -- Tier 2 Product Material
    addSchematic(4073976374, 4000, true)
    -- Tier 2 Pure Material
    addSchematic(3332597852, 4000, true)
    -- Tier 2 XS Element
    addSchematic(2096799848, 40)
    -- Tier 2 S Element
    addSchematic(1752968727, 40)
    -- Tier 2 M Element
    addSchematic(2726927301, 40)
    -- Tier 2 L Element
    addSchematic(616601802, 60)
    -- Tier 2 XL Element
    addSchematic(3677281424, 40)
    -- Tier 2 Honeycomb
    addSchematic(632722426, 500)
    -- Tier 2 Honeycomb
    addSchematic(625377458, 500)

    setTier(3)
    -- Tier 3 Product Material
    addSchematic(3707339625, 1000, true)
    -- Tier 3 Pure Material
    addSchematic(2003602752, 1000, true)
    -- Tier 3 XS Element
    addSchematic(787727253, 30)
    -- Tier 3 S Element
    addSchematic(425872842, 30)
    -- Tier 3 M Element
    addSchematic(3713463144, 30)
    -- Tier 3 L Element
    addSchematic(1427639881, 30)
    -- Tier 3 XL Element
    addSchematic(109515712, 30)
    -- Tier 3 Honeycomb
    addSchematic(2343247971, 500)
    -- Tier 3 Honeycomb
    addSchematic(4221430495, 500)

    setTier(4)
    -- Tier 4 Product Material
    addSchematic(2485530515, 500, true)
    -- Tier 4 Pure Material
    addSchematic(2326433413, 500, true)
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
    addSchematic(3743434922, 500)
    -- Tier 4 Honeycomb
    addSchematic(99491659, 500)

    moveToNextScreen()
    setTier(5)

    -- Tier 5 Product Material
    addSchematic(2752973532, 500)
    -- Tier 5 Pure Material
    addSchematic(1681671893, 500, true)
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
    addSchematic(1885016266, 500)
    -- Tier 5 Honeycomb
    addSchematic(3303272691, 500)

    setTier(6)
    -- Construct Support XS
    addSchematic(1477134528, 100, true)
    -- Construct Support S
    addSchematic(1224468838, 100, true)
    -- Construct Support M
    addSchematic(1861676811, 200, true)
    -- Construct Support L
    addSchematic(784932973, 200, true)
    
    setTier(7)
    -- Core Unit xs
    addSchematic(120427296, 10)
    -- Core Unit s
    addSchematic(1213081642, 10)
    -- Core Unit M
    addSchematic(1417495315, 20)
    -- Core Unit L
    addSchematic(1202149588, 20)

    setTier(8)
    -- Bonsai
    addSchematic(674258992, 1, false)
    -- Territory Unit
    addSchematic(318308564, 7)
    -- Warp Beacon
    addSchematic(3437488324, 1, false)

    setTier(9)
    -- Atmo Fuel
    addSchematic(3077761447, 5000, true)
    -- Rocket Fuel
    addSchematic(3992802706, 2000, false)
    -- Space Fuel
    addSchematic(1917988879, 5000, true)
    -- Warp cells
    addSchematic(363077945, 5000)
    
    setTier(10)
    -- Tier 2 Scrap
    addSchematic(1952035274, 1000)
    -- Tier 3 Scrap
    addSchematic(2566982373, 1000)
    -- Tier 4 Scrap
    addSchematic(1045229911, 1000, true)
    -- Tier 5 Scrap
    addSchematic(2702634486, 1000, true)

    moveToNextScreen()
    setTier(11)
    -- Tier 2 XS Ammo
    addSchematic(326757369, 1000, false)
    -- Tier 2 S Ammo
    addSchematic(3336558558, 1000, false)
    -- Tier 2 M Ammo
    addSchematic(399761377, 1000, false)
    -- Tier 2 L Ammo
    addSchematic(512435856, 1000, false)
        
    setTier(12)
    -- Tier 3 XS Ammo
    addSchematic(2413250793, 1000, false)
    -- Tier 3 S Ammo
    addSchematic(1705420479, 1000, false)
    -- Tier 3 M Ammo
    addSchematic(3125069948, 1000, false)
    -- Tier 3 L Ammo
    addSchematic(2913149958, 1000, false)
    
    setTier(13)   
    -- Tier 4 XS Ammo
    addSchematic(2293088862, 1000, false)
    -- Tier 4 S Ammo
    addSchematic(3636126848, 1000, false)
    -- Tier 4 M Ammo
    addSchematic(3847207511, 1000, false)
    -- Tier 4 L Ammo
    addSchematic(2557110259, 1000, false)
end

schematicsTracker()

if not checkSchematicsContainer then
    linkedToSchemContainer = true
end

unit.hideWidget()

function updateScreens()
    local serialized = {}
    for id, info in ipairs(information) do
        serialized[id] = serialize(info)
    end

    for id, screenObject in ipairs(screens) do

        local horizontal = false
        local inverted = false
        local script = serialized[screenObject.sn]

        if screenObject.dir == "hu" or screenObject.dir == "hd" then
            horizontal = true
            if screenObject.dir == "hd" then
                inverted = true
            end
            script = serialize(information)
        elseif  screenObject.dir == "vr" then
            inverted = true
        end

        screenObject.screen.setRenderScript(formatScript(script, horizontal, inverted))
    end
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

function fillMissing()
    
    information = {}
    for id, schematic in ipairs(schematics) do
        local id, existing = getExisting(schematic.id)
        local temp = information[schematic.sn] or {}
        if not existing then
            temp[#temp + 1] = { name = schematic.name, volume = 0, max = schematic.max, tier = schematic.tier, p = schematic.priority }
        else
            temp[#temp + 1] = { name = schematic.name, volume = existing.volume, max = schematic.max, tier = schematic.tier, p = schematic.priority }
        end
        information[schematic.sn] = temp
    end
    return information
end

function containerContentUpdate()
    lastRequest = system.getArkTime()
    requestingUpdateContent = false
    generateItemUpdate()
    fillMissing()
    updateScreens()
end

local init = false

function update()
    requestingUpdateContent = true
    container.updateContent()

    if not init then
        local map = container.getContent()
        if map and #map > 0 then
            generateItemUpdate()
            fillMissing()
            updateScreens()
        end
        init = true
    end
end

update()

unit.setTimer('update', 1)