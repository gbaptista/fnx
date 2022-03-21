(local controller (require :fnx.controllers.bootstrap))

(local port {})

(fn port.bootstrap! [?main-dot-fnx-path] (controller.handle! ?main-dot-fnx-path))

port
