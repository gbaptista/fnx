(local sn (require :supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.install [dependency cyclic-control arguments]
  (when (not (. cyclic-control dependency.cyclic-key))
    (tset cyclic-control dependency.cyclic-key true)
    (tset cyclic-control :_any? true)

    (let [command
          (.. "luarocks install "
              (if (. arguments.present :--global) "--global" "--local")
              " "
              dependency.identifier)]
      (port/shell-out.dispatch!
        (logic/smk.fragment (.. "Installing " (sn.blue dependency.identifier) "...")))

      (if (. arguments.present :--verbose)
        (do
          (port/shell-out.dispatch! (logic/smk.line "\n"))
          (component/io.os command))
        (do
          (component/io.os-output command))))))

controller
