local jc = jrequire 'jc'

local msm = {}

function msm.returnSkillTreeObject(collection)
    local ret = JMap.object()

    local function trim(s)
        -- from PiL2 20.4
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end

    for x = 1, #collection do
        local file = io.open(collection[x], "r")
        local content = file:read "*a"
        file:close()
        --ret[collection[x]] = content
        local t = JMap.object()
        --for k, v in string.gmatch(content, "(%w+) = (\"?%w+.?%w?\"?)") do
        for k, v in string.gmatch(content, "(%w+) =(.-\n)") do
            t[k] = v
            -- cleanup crap
            t[k] = string.gsub(t[k], "\n", "")
            t[k] = string.gsub(t[k], " \\ ", "")
            t[k] = string.gsub(t[k], "\"", "")
            --t[k] = string.gsub(t[k], ".nif", ".dds")
            t[k] = trim(t[k])
        end
        if t["Name"] then
            local r = JMap.object()
            r["Name"] = t["Name"]
            r["Description"] = t["Description"]

            r["Skydome"] = t["Skydome"]
            r["Skydome_tex_file_possible_loc"] = "data\\textures\\" + string.gsub(t["Skydome"], ".nif", ".dds")
            r["icon_exists"] = 0
            r["icon_loc"] = ""

            r["ShowMenuFile"] = t["ShowMenuFile"]
            r["ShowMenuId"] = t["ShowMenuId"]
            ret[collection[x]] = r
        end
    end
    return ret
end

return msm