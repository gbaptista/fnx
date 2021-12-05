(local adapter/luarocks (require :fnx.adapters.luarocks))

(local component/io (require :fnx.components.io))

(local port {})

(fn port.installed-version [dependency arguments]
  (->>
    (adapter/luarocks.dependency->show dependency arguments)
    (component/io.os-output)
    (adapter/luarocks.show->version)))

port
