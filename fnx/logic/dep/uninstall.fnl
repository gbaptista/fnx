(local sn (require :supernova))

{:confirm (.. "Are you sure you want to uninstall " (sn.red "all") " dependencies?")
 :luarocks/unsafe {
  :supernova true}}
