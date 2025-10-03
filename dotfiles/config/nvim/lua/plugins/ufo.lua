return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}

        -- Get the closing line text
        local endText = vim.api.nvim_buf_get_lines(0, endLnum - 1, endLnum, false)[1] or ""
        endText = endText:gsub("^%s*", "") -- trim leading whitespace

        local suffix = " ... "
        local endSuffix = " " .. endText
        local totalSufWidth = vim.fn.strdisplaywidth(suffix .. endSuffix)
        local targetWidth = width - totalSufWidth
        local curWidth = 0

        -- Add the first line content, but remove the opening bracket if present
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            break
          end
          curWidth = curWidth + chunkWidth
        end

        -- Add ellipsis
        table.insert(newVirtText, { suffix, "Comment" })

        -- Add closing bracket/brace
        table.insert(newVirtText, { endText, "Normal" })

        return newVirtText
      end

      require("ufo").setup({
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },
}
