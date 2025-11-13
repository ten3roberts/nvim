return {
  filetypes = { 'vue' },
  init_options = {
    typescript = {
      tsdk = vim.fn.exepath('vtsls')
    }
  },
  settings = {
    vue = {
      server = {
        hybridMode = false
      }
    }
  }
}