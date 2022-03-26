(local controller/bootstrap (require :fnx.controllers.dsl.bootstrap))
(local controller/debug (require :fnx.controllers.dsl.debug))

(local port {:debug {}})

(fn port.bootstrap! [?main-dot-fnx-path]
   (controller/bootstrap.handle! ?main-dot-fnx-path))

(fn port.debug.injections [?main-dot-fnx-path]
  (controller/debug.injections ?main-dot-fnx-path))

(fn port.debug.packages [?main-dot-fnx-path]
  (controller/debug.packages ?main-dot-fnx-path))

(fn port.debug.dot-fnx-path [?main-dot-fnx-path]
  (controller/debug.dot-fnx-path ?main-dot-fnx-path))

port
