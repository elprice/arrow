-- This is a module for drawing an arrow towards a mob object. Will need Images/ with Arrow pngs to function

local arrowprim = 'arrowprim'
local math = require('math')
local texts = require('texts')

config = require('config') -- why can't this be local?

local defaults = {}
defaults.bg = {}
defaults.bg.alpha = 128
defaults.text = {}
defaults.text.font = 'Consolas'
defaults.text.size = 14
defaults.flags = {}
defaults.flags.draggable = false

local settings = config.load(defaults)
local text_box = texts.new(settings)

local arrow = {}

local ARROW_IMAGE_WIDTH = 56
local ARROW_IMAGE_HEIGHT = 42
local TEXT_BOX_MARGIN_TOP = 40
local CONSOLAS_CHARACTER_WIDTH = 11

local ARROW_IMAGE_COUNT = 108
local DEGREES_IN_CIRCLE = 360

local arrow_x_pos = (windower.get_windower_settings().ui_x_res / 2) - (ARROW_IMAGE_WIDTH/2)
local arrow_y_pos = windower.get_windower_settings().ui_y_res * 0.15 

local function distance(x1, y1, x2, y2)
    local dX = (x1 - x2)
    local dY = (y1 - y2)
    return math.sqrt(dX * dX + dY * dY)
end

local function position_angle(x1, y1, x2, y2) -- angle between two x,y coords in degrees
    return math.atan2(x1 - x2, y1 -  y2) * (DEGREES_IN_CIRCLE/2) / math.pi % DEGREES_IN_CIRCLE
end

local function camera_angle(orientation_x, orientation_z) -- angle the camera is facing relative to game axis in degrees
    return math.atan2(orientation_x, orientation_z) * DEGREES_IN_CIRCLE/math.pi % DEGREES_IN_CIRCLE--N is 0 W is 90 and so on
end

local function arrow_angle(cam_angle, pos_angle) -- difference between the camera and the position angles (0 is straight forward)
    return (cam_angle - pos_angle) % DEGREES_IN_CIRCLE
end

local function arrow_prim_path(arrow_angle, distance) -- picks the correct sprite for the desired angle (10 is the straight forward arrow)
    if distance < 5 then                              -- hindsight is 20/20 I should have just updated the image labels                      
        return windower.addon_path..'Images/Arrow_Down.png'
    end
    -- +9 and +1 are to get us back to 10 for the 0 degree case (straight forward)
    return windower.addon_path..'Images/Arrow ('..tostring(math.floor(arrow_angle / (DEGREES_IN_CIRCLE/ARROW_IMAGE_COUNT) + 9) % ARROW_IMAGE_COUNT + 1)..').png' 
end

local function update_arrow_texture(filepath)
    windower.prim.set_texture(arrowprim, filepath) -- set arrow image
end

local function update_text_box(name, distance)
    local str = name..' - '..tonumber(string.format("%.1f", distance))
    text_box:text(str)

    local x_mid = windower.get_windower_settings().ui_x_res / 2
    local str_len = string.len(str) + 2 -- string.len doesn't count the spaces ? so add 2
    local str_pixel_width = (CONSOLAS_CHARACTER_WIDTH*str_len) + 2 -- 2 extra pixels on the end
    text_box:pos(x_mid - (str_pixel_width/2), text_box:pos_y()) --reuse same pos_y.. calc new x based on width
end

function arrow.show()
    windower.prim.set_visibility(arrowprim, true)
    text_box:visible(true)
end

function arrow.hide()
    windower.prim.set_visibility(arrowprim, false)
    text_box:visible(false)
end

function arrow.init()
    windower.prim.create(arrowprim)
    windower.prim.set_fit_to_texture(arrowprim, true)    
    windower.prim.set_position(arrowprim, arrow_x_pos, arrow_y_pos) 
    text_box:pos(arrow_x_pos, arrow_y_pos + ARROW_IMAGE_HEIGHT + TEXT_BOX_MARGIN_TOP)
    arrow.hide()
end

function arrow.destroy()
    windower.prim.delete(arrowprim)
    texts.destroy(text_box)
end

function arrow.update(mob) -- feel free to rewrite this to take an x,y instead of a mob object

    local pos_angle, cam_angle, arr_angle, dist
    local me = windower.ffxi.get_mob_by_target('me')
    local cam = windower.get_camera()

    local cam_angle = camera_angle(cam.orientation_x, cam.orientation_z)
    local pos_angle = position_angle(me.x, me.y, mob.x, mob.y)
    local arr_angle = arrow_angle(cam_angle, pos_angle)

    local dist = distance(me.x, me.y, mob.x, mob.y)
    local sprite_path = arrow_prim_path(arr_angle, dist)

    update_arrow_texture(sprite_path)
    update_text_box(mob.name, dist)

    arrow.show()
end

return arrow