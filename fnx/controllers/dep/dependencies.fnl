(local port/luarocks-out (require :fnx.ports.out.luarocks))

(local component/io (require :fnx.components.io))

(local logic/dependencies (require :fnx.logic.dependencies))
(local logic/list (require :fnx.logic.dep.list))

(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.load-data! [arguments ?working-directory]
  (let [working-directory (or ?working-directory (component/io.working-directory))
        core-fnx          (model/xpackage.load (.. (os.getenv :FNX_CORE_PATH) "/.fnx.fnl"))
        dependencies
          (->>
            (.. working-directory "/.fnx.fnl")
            (model/xpackage.load)
            (#(. $1 :dependencies))
            (logic/dependencies.build working-directory (os.getenv "FNX_DATA_DIRECTORY")))
        state
          (controller.retrieve-state! dependencies arguments)
        installable (logic/list.installable dependencies)
        not-installed
          (if (or (. arguments.present :--force) (. arguments.present :-f))
            installable
            (logic/list.not-installed dependencies state))
        to-list
          (->>
            (logic/list.prepare dependencies state)
            (logic/list.sort-to-display))]

    {:dependencies  dependencies
     :core-fnx      core-fnx
     :installable   installable
     :not-installed    not-installed
     :to-list       to-list}))

(fn controller.retrieve-state! [dependencies arguments]
  (local state {})
  (each [_ dependency (pairs dependencies)]
    (if (. dependency :usage-path)
      (tset state
        dependency.identifier
        (component/io.exists? (. dependency :usage-path)))
      (match dependency.provider
        :rock
          (tset state
            dependency.identifier
            (port/luarocks-out.installed-version dependency arguments))
        _ (tset state dependency.identifier false))))
  state)

(fn controller.build-from [dot-fnx-path ?acc]
  (let [acc (or ?acc {:candidates [] :cyclic-control { :dot-fnx {} :candidate {} }})]
    (if (. acc.cyclic-control.dot-fnx dot-fnx-path)
      acc
      (let [dependencies (controller.dependencies-for dot-fnx-path)]
        (if dot-fnx-path
          (tset acc.cyclic-control.dot-fnx dot-fnx-path true))

        (each [_ dependency (pairs dependencies)]
          (controller.build-from (. dependency :dot-fnx-candidate-path) acc)

          (when (not (. acc.cyclic-control.candidate dependency.cyclic-key))
            (tset acc.cyclic-control.candidate dependency.cyclic-key true)
            (table.insert acc.candidates dependency)))
        acc))))

(fn controller.dependencies-for [dot-fnx-path]
  (let [working-directory (component/io.working-directory)]
    (if (or (not dot-fnx-path) (not (component/io.exists? dot-fnx-path)))
      []
      (->>
        dot-fnx-path
        (model/xpackage.load)
        (#(. $1 :dependencies))
        (logic/dependencies.build working-directory (os.getenv "FNX_DATA_DIRECTORY"))
        (logic/list.installable)))))

controller
