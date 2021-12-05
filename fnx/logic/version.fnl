(local logic {})

(local sn (require :supernova))

(fn logic.display [version]
  (sn.gradient
    (.. "fnx " version)
    ["#FF0000" "#FFFF00" "#00FF00" "#0FF0FE" "#233CFE"]))

logic
