(local adapter/argv (require :fnx.adapters.argv))

(local controller (require :fnx.controllers.installer))

(local port {})

(fn port.handle! [input?]
  (let [input     (or input? arg)
        arguments (adapter/argv.parse input)]
    (controller.handle! arguments)))

port
