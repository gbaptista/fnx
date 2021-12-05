(local sn (require :supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.install [dependency cyclic-control arguments]
  (when (not (. cyclic-control dependency.cyclic-key))
    (tset cyclic-control dependency.cyclic-key true)
    (tset cyclic-control :_any? true)

    (match dependency.install-from.mode
      :local (controller.install-local dependency arguments)
      :git   (controller.install-git   dependency arguments)
      _      (error
               (.. "[controllers.dep.install/fnx] "
                   "I don't know how to install it: \"" dependency.install-from.mode "\"")))))

(fn controller.install-git [dependency arguments]
  (let [commands
          [(..
             "git clone "
             dependency.install-from.url " "
             dependency.usage-path)]]

    (if dependency.install-from.tag
      (table.insert
        commands
        (..
          "cd " dependency.usage-path
          " && git checkout tags/" dependency.install-from.tag)))

    (if dependency.install-from.branch
      (table.insert
        commands
        (..
          "cd " dependency.usage-path
          " && git checkout " dependency.install-from.branch)))

    (if dependency.install-from.commit
      (table.insert
        commands
        (..
          "cd " dependency.usage-path
          " && git checkout " dependency.install-from.commit)))

    (port/shell-out.dispatch!
        (logic/smk.fragment (.. "Installing " (sn.cyan dependency.identifier))))

    (component/io.os (.. "rm -rf " dependency.usage-path))

    (if (. arguments.present :--verbose)
      (do
        (port/shell-out.dispatch! (logic/smk.line ""))
        (each [_ command (pairs commands)]
          (port/shell-out.dispatch!
            (logic/smk.line (.. (sn.yellow "> ") command)))
          (component/io.os command)))
      (do
        (port/shell-out.dispatch!
          (logic/smk.fragment (sn.yellow "...")))
        (each [_ command (pairs commands)]
          (component/io.os (.. command "&>/dev/null")))
        (port/shell-out.dispatch!
          (logic/smk.fragment " "))))

    (port/shell-out.dispatch!
      (logic/smk.fragment (.. (sn.green "done!") "\n")))))

(fn controller.install-local [dependency arguments]
  (let [from-path dependency.install-from.path
          to-path   dependency.usage-path]
    (port/shell-out.dispatch!
      (logic/smk.fragment (.. "Installing " (sn.cyan dependency.identifier))))

    (component/io.os (.. "mkdir -p " to-path))
    (if (not (. arguments.present :--verbose))
      (port/shell-out.dispatch!
        (logic/smk.fragment (sn.yellow "."))))

    (component/io.os (.. "rm -rf " to-path))
    (if (not (. arguments.present :--verbose))
      (port/shell-out.dispatch!
        (logic/smk.fragment (sn.yellow "."))))

    (let [command (.. "cp -r " from-path " " to-path)]
      (if (. arguments.present :--verbose)
        (port/shell-out.dispatch!
          (logic/smk.line (.. "\n" (sn.yellow "> ") command))))
      (component/io.os command))

    (if (not (. arguments.present :--verbose))
      (port/shell-out.dispatch!
        (logic/smk.fragment (sn.yellow "."))))

    (port/shell-out.dispatch!
      (logic/smk.fragment (.. " " (sn.green "done!") "\n")))))

controller
