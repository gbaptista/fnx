(local adapter/shell (require :fnx.adapters.shell))

(local port {})

(fn port.dispatch! [smk]
  (if (= (. (. smk 1) 1) :fragment)
    (do
      (io.write (adapter/shell.smk->string smk))
      (io.flush))
    (print (adapter/shell.smk->string smk))))

(fn port.retrieve! []
  (io.read "*line"))

port
