(local sn (require :supernova))

(local logic {
  :confirm "Proceed with the installation?"
  :overwrite "Already exists. May I overwrite it?"
  :canceled (sn.red "Installation canceled.")
  :setup-keys [
    :install-from-path    :fnx-binary-path
    :fnx-config-file-path :fnx-data-directory]
  :setup-config {
    :install-from-path {
      :verification (.. "We need to ensure that we have the correct path for the "
                        (sn.cyan "fnx")
                        " source code directory. Is this path right?")
      :correction   "Provide the correct path:"
      :confirmation (.. "   " (sn.cyan "fnx") " source code directory:") }
    :fnx-binary-path {
      :verification (.. "We need to create a " (sn.red "binary") " for fnx. "
                        "Is this destination the desired one?")
      :correction   "Provide the desired destination:"
      :confirmation (.. "         " (sn.red "binary") " path for fnx:") }
    :fnx-config-file-path {
      :verification (.. "We need to create a global "
                        (sn.blue "config file")
                        " in your home directory. Is this path ok?")
      :correction   "Provide the desired path:"
      :confirmation (.. "          global " (sn.blue "config file") ":") }
    :fnx-data-directory {
      :verification (.. "We need a directory to install your future Fennel "
                        (sn.green "packages") " and " (sn.magenta "metadata")
                        ". Does this one work for you?")
      :correction   "Provide the desired directory:"
      :confirmation (.. "future " (sn.green "packages") " and " (sn.magenta "metadata") ":") }}})

(fn logic.welcome [version]
  (sn.gradient
    (.. "\nWelcome to fnx " version "! :)")
    ["#FF0000" "#FFFF00" "#00FF00" "#0FF0FE" "#233CFE"]))

logic
