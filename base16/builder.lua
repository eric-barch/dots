-- Base16 Builder in Lua
-- Spec: https://github.com/chriskempson/base16/blob/main/builder.md
-- Example: https://github.com/chriskempson/base16-builder-php

local yaml = require("lyaml")
local mustache = require("lustache")

local scheme_file = ""
for line in io.lines() do
	scheme_file = scheme_file .. line .. "\n"
end

local argparse = require("argparse")
local parser = argparse():name("base16-builder"):description("Base16 Builder")
parser:option("-t --template", "Template file path")
local args = parser:parse()

if not args.template then
	io.stderr:write("Specify template with -t or --template.\n")
	os.exit(1)
end

local scheme_data = yaml.load(scheme_file)

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return {
		r = tonumber(hex:sub(1, 2), 16),
		g = tonumber(hex:sub(3, 4), 16),
		b = tonumber(hex:sub(5, 6), 16),
	}
end

local function rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local h, s, l = 0, 0, (max + min) / 2

	if max ~= min then
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)
		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return { h = h * 360, s = s * 100, l = l * 100 }
end

local function get_tags(data)
	local tags = {}

	tags["scheme-name"] = data["name"]
	tags["scheme-slug"] = string.gsub(string.lower(data["name"]), " ", "-")
	tags["scheme-author"] = data["author"]

	local bases = { "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "0A", "0B", "0C", "0D", "0E", "0F" }

	for _, base in ipairs(bases) do
		local base_key = "base" .. base

		local color_hex = data["palette"][base_key]:gsub("#", "")
		local color_rgb = hex_to_rgb(color_hex)
		local color_hsl = rgb_to_hsl(color_rgb.r, color_rgb.g, color_rgb.b)

		tags[base_key .. "-hex"] = color_hex
		tags[base_key .. "-hex-bgr"] = color_hex:sub(5, 6) .. color_hex:sub(3, 4) .. color_hex:sub(1, 2)
		tags[base_key .. "-hex-r"] = color_hex:sub(1, 2)
		tags[base_key .. "-hex-g"] = color_hex:sub(3, 4)
		tags[base_key .. "-hex-b"] = color_hex:sub(5, 6)
		tags[base_key .. "-rgb-r"] = color_rgb.r
		tags[base_key .. "-rgb-g"] = color_rgb.g
		tags[base_key .. "-rgb-b"] = color_rgb.b
		tags[base_key .. "-dec-r"] = color_rgb.r / 255
		tags[base_key .. "-dec-g"] = color_rgb.g / 255
		tags[base_key .. "-dec-b"] = color_rgb.b / 255
		tags[base_key .. "-hsl-h"] = color_hsl.h
		tags[base_key .. "-hsl-s"] = color_hsl.s
		tags[base_key .. "-hsl-l"] = color_hsl.l
	end

	return tags
end

local function render_template(path, tags)
	local template = io.open(path):read("*all")
	return mustache:render(template, tags)
end

local tags = get_tags(scheme_data)
io.stdout:write(render_template(args.template, tags))
