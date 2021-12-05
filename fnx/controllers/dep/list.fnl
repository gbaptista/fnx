(local port/shell-out (require :fnx.ports.out.shell))

(local controller/dependencies (require :fnx.controllers.dep.dependencies))

(local logic/list (require :fnx.logic.dep.list))
(local logic/version (require :fnx.logic.version))

(local controller {})

(fn controller.handle! [arguments]
  (let [{:core-fnx core-fnx
         :to-list       to-list}
          (controller/dependencies.load-data! arguments)]

    (port/shell-out.dispatch!
      [[:line  (logic/version.display core-fnx.version) ]
       [:line  ""]
       [:table (logic/list.build-sml-table to-list)]
       [:line  ""]])))

controller
