(local sn (require :supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local logic/installer (require :fnx.logic.installer))
(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.ensure-config! [default-values arguments]
  (if (or (. arguments.present :-f) (. arguments.present :-s))
    default-values
    (do
      (local result default-values)
      (each [_ key (pairs logic/installer.setup-keys)]
        (port/shell-out.dispatch! (logic/smk.line (.. "\n" (. logic/installer.setup-config key :verification) "")))
        (port/shell-out.dispatch! (logic/smk.line (sn.yellow (.. "\"" (. result key)) "\"")))
        (port/shell-out.dispatch! (logic/smk.fragment (sn.blue "[Yn]> ")))
        (let [answer (port/shell-out.retrieve!)]
          (when (= answer "n")
            (port/shell-out.dispatch! (logic/smk.line (. logic/installer.setup-config key :correction)))
            (port/shell-out.dispatch! (logic/smk.fragment (sn.blue "    > ")))
            (let [answer (port/shell-out.retrieve!)]
            (tset result key answer)))))

      result)))

(fn controller.double-check! [setup-config arguments]
  (port/shell-out.dispatch! (logic/smk.line ""))
  (each [_ key (pairs logic/installer.setup-keys)]
    (port/shell-out.dispatch! (logic/smk.line
      (..
        (. logic/installer.setup-config key :confirmation) " "
        (sn.yellow (.. "\"" (. setup-config key) "\""))))))

  (when (not (. arguments.present :-f))
    (port/shell-out.dispatch! (logic/smk.line (.. "\n" (. logic/installer :confirm))))
    (port/shell-out.dispatch! (logic/smk.fragment (sn.blue "[Yn]> ")))
    (let [answer (port/shell-out.retrieve!)]
        (when (= answer "n")
          (port/shell-out.dispatch! (logic/smk.line (.. "\n" logic/installer.canceled)))
          (os.exit)))))

controller
