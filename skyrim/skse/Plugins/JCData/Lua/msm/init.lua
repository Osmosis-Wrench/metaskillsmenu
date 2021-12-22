local jc = jrequire 'jc'

local msm = {}

function msm.returnSkillTreeObject(collection)
    local ret = JMap.object()

    for x = 1, #collection do
        local file = io.open(collection[x], "r")
        local content = file:read "*a"
        file:close()
        --local lines = {}
        --for line in io.lines(file) do
        --    lines[#lines + 1] = line
        --end
        ret[collection[x]] = content
    end
    return ret
end

return msm