(local adapter/argv (require :fnx.adapters.argv))

(local controller/installer (require :fnx.controllers.installer))

(local port {})

(fn port.handle! [input?]
  (let [input     (or input? arg)
        arguments (adapter/argv.parse input)]
    (controller/installer.handle! arguments)))

port
