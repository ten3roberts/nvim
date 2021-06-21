syn match    customHeader1     "^# .*"
syn match    customHeader2     "^## .*"
syn match    customHeader3     "^### .*"
syn match    customHeader4     "^#### .*"
syn match    customHeader5     "^##### .*"
syn match    customHeader6     "^###### .*"

hi! link customHeader1 PurpleBold
hi! link customHeader2 GreenBold
hi! link customHeader3 YellowBold
hi! link customHeader4 OrangeBold
hi! link customHeader5 RedBold

set textwidth=80
