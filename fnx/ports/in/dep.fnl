(local adapter/argv (require :fnx.adapters.argv))

(local controller/doc (require :fnx.controllers.dep.doc))

(local controller/install (require :fnx.controllers.dep.install))
(local controller/list (require :fnx.controllers.dep.list))
(local controller/uninstall (require :fnx.controllers.dep.uninstall))

(local port {})

(fn port.handle! [input?]
  (let [input     (or input? arg)
        arguments (adapter/argv.parse input 1)]
    (match (. arguments :command)
      :install   (controller/install.handle! arguments)
      :list      (controller/list.handle! arguments)
      :uninstall (controller/uninstall.handle! arguments)
      _          (controller/doc.handle!))))

port
