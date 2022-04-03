(local port/dep-in (require :fnx.ports.in.dep))

(local adapter/argv (require :fnx.adapters.argv))

(local controller/config (require :fnx.controllers.config))
(local controller/sudo (require :fnx.controllers.sudo))
(local controller/env (require :fnx.controllers.env))
(local controller/help (require :fnx.controllers.help))
(local controller/injection (require :fnx.controllers.injection))
(local controller/debug (require :fnx.controllers.debug))
(local controller/trap (require :fnx.controllers.trap))
(local controller/version (require :fnx.controllers.version))

(local port {
  :trapable [:config :sudo :debug :dep :env :help :version]})

(fn port.handle! [input?]
  (let [input     (or input? arg)
        arguments (adapter/argv.parse input)]
  (match (. arguments :command)
    :sudo    (controller/sudo.handle! arguments)
    :config  (controller/config.handle!)
    :env     (controller/env.handle!)
    :debug   (controller/debug.handle! arguments)
    :dep     (port/dep-in.handle! input?)
    :help    (controller/help.handle!)
    :inject  (controller/injection.handle! arguments)
    :trap    (controller/trap.handle! port.trapable arguments)
    :version (controller/version.handle!))))

port
