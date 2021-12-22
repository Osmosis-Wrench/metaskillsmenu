local jc = jrequire 'jc'

local msm = {}

function msm.returnSkillTreeObject(collection)
    local ret = JMap.object()

    for x = 0, #collection do
        local file = io.open(collection[x], "r")
        local content
        content = file:read "*a"
        file:close()
        local lines = {}
        --for line in io.lines(file) do
        --    lines[#lines + 1] = line
        --end
        ret[collection[x]] = content
        x = x + 1
    end

    return ret
end

return msm