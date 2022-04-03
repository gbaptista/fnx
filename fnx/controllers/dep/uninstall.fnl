(local sn (require :fnx.helpers.supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local controller/dependencies (require :fnx.controllers.dep.dependencies))

(local logic/list (require :fnx.logic.dep.list))
(local logic/uninstall (require :fnx.logic.dep.uninstall))
(local logic/smk (require :fnx.logic.smk))
(local logic/version (require :fnx.logic.version))

(local controller {})

(fn controller.handle! [arguments]
   (let [{:core-fnx core-fnx :to-list  to-list}
          (controller/dependencies.load-data! arguments)
         working-directory (component/io.working-directory)
         main-dot-fnx-path (.. working-directory "/.fnx.fnl")
         dependencies (. (controller/dependencies.build-from main-dot-fnx-path) :candidates)]

    (port/shell-out.dispatch!
      [[:line  (logic/version.display core-fnx.version) ]
       [:line  ""]
       [:table (logic/list.build-sml-table to-list)]
       [:line  ""]])

    (when (not (. arguments.present :-f))
      (port/shell-out.dispatch! (logic/smk.line (. logic/uninstall :confirm)))
      (port/shell-out.dispatch! (logic/smk.fragment (sn.blue "[Yn]> ")))
      (let [answer (port/shell-out.retrieve!)]
        (if (= answer "n")
          (os.exit)
          (port/shell-out.dispatch! (logic/smk.line "")))))

    (each [_ dependency (pairs dependencies)]
      (match [dependency.language dependency.provider]
        [:fennel :fnx]  (controller.uninstall-fennel/fnx dependency)
        [:lua    :rock] (controller.uninstall-lua/rock dependency arguments)))))

(fn controller.uninstall-fennel/fnx [dependency]
  (let [path-to-remove (. dependency :usage-path)]
    (when path-to-remove (component/io.os (.. "rm -rf " path-to-remove))))
  (port/shell-out.dispatch!
      (logic/smk.line (.. (sn.cyan dependency.identifier) " successfully uninstalled."))))

(fn controller.uninstall-lua/rock [dependency arguments]
  (if (. logic/uninstall.luarocks/unsafe dependency.identifier)
    (port/shell-out.dispatch!
      (logic/smk.line (.. (sn.red dependency.identifier) " can't be uninstalled, sorry. It would be unsafe to do so.")))

    (let [command
          (.. "luarocks remove "
              (if (. arguments.present :--global) "--global" "--local")
              " "
              dependency.identifier)]
      (if (. arguments.present :--verbose)
        (do
          (port/shell-out.dispatch! (logic/smk.line "\n"))
          (component/io.os command))
        (do
          (component/io.os-output (.. command " 2>/dev/null"))
          (port/shell-out.dispatch!
            (logic/smk.line (.. (sn.blue dependency.identifier) " successfully uninstalled."))))))))

controller
