(local sn (require :fnx.helpers.supernova))

{:confirm (.. "Are you sure you want to uninstall " (sn.red "all") " dependencies?")
 :luarocks/unsafe {
  :supernova true}}
