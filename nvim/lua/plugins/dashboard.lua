return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  opts = function(_, opts)
    local logo = [[
                                        ▓▓▓▒▒▒░░░                                    
                                     ▓▓▓▓▓                                           
                                   ▓███▓  ▓▓▓▓                                       
                                  ▓██▓  ▓█████▓                                      
                                ░████  ▓████████▓                                    
                                ████▓  ▓█████████▓                                   
                               ▓████▓    █████████▓                                  
                               ▓██▒ ██▓▓▓ █████████                                  
                              ▒▓ █████████ ████████▓ ▓▓                              
                               ████████████████████▓ ▓██▓                            
                              ▓███████████▓ ███████▓ ▓████░                          
                            ░████████████   ▓██████▓ ▓██████                         
                           ▓██████████ ██   ▓█▓▓▓▓▓▓   ▓████                         
                  ░        █████████ ░███████            ████                        
                   ▓      ▓████████ ██████████▓▓▓▓▓▓▓▓▓▓▓ ▓██░                       
                    █░    ▓███████ ▓▓████████████████████  ███                       
                     ██▓   ▓▓▓▓▓█░   ████████████████████▒ ▓█▓                       
                       ▓▓▓▓         ▓█  ████▓▓███████▓▓▓▓  ▓█                        
                         ▓▓███▓▓▓▓▓████████    ▒█▓█▒       ▓▓                        
                            ░█▓▓▓▓▓▓▓▓▓▓█                  █                         
                                                          █░                         
                                                         ░█                          
    ]]

    logo = logo .. "\n"
    opts.config.header = vim.split(logo, "\n")
    return opts
  end,
}