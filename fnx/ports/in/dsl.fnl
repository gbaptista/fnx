(local component/io (require :fnx.components.io))
(local logic/dependencies (require :fnx.logic.dependencies))
(local helper/list (require :fnx.helpers.list))

(local controller/injection (require :fnx.controllers.injection))

(local dsl {})

(fn dsl.boot! [fnx-data-directory]
  (let [working-directory (component/io.current-directory)
        main-dot-fnx-path (.. working-directory "/.fnx.fnl")
        dependencies      (controller/injection.build-dependencies-from
                            main-dot-fnx-path fnx-data-directory)]
    (helper/list.map
       #(match (. $1 :language)
         :fennel
           {:language :fennel
            :path (logic/dependencies.injection-path (. $1 :usage-path) :fnl)}
         :lua
           {:language :lua
            :path (logic/dependencies.injection-path (. $1 :usage-path) :lua)})
       dependencies.injections)))

dsl
