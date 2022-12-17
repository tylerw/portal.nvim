local M = {}

---@param jump Portal.Jump
---@return boolean
local function is_marked(jump)
    local query = require("portal.query")
    if not query.valid(jump) then
        return false
    end

    local ok, buffer_name = pcall(vim.api.nvim_buf_get_name, jump.buffer)
    if not ok then
        return false
    end

    local file_path = require("harpoon.utils").normalize_path(buffer_name)
    local mark = require("harpoon.mark").get_marked_file(file_path)

    return query.different(jump) and mark ~= nil
end

function M.register()
    local ok, _ = pcall(require, "harpoon")
    if not ok then
        require("portal.log").debug("Unable to register query item. Please check that harpoon is installed.")
        return
    end

    require("portal.query").register("harpoon", is_marked, {
        name = "Harpoon",
        name_short = "H",
    })
end

return M
