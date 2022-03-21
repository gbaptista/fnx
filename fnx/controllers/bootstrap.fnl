(local fennel (require :fennel))

(local component/io (require :fnx.components.io))
(local logic/dependencies (require :fnx.logic.dependencies))
(local helper/list (require :fnx.helpers.list))

(local controller/injection (require :fnx.controllers.injection))

(local controller {})

(fn controller.handle! []
  (let [dependencies (controller.build-dependencies)]
    (each [_ dependency (pairs dependencies)]
      (match (. dependency :language)
        :fennel (controller.add-fennel-path! (. dependency :path))
        :lua    (controller.add-lua-path! (. dependency :path))))))

(fn controller.add-fennel-path! [path]
  (set fennel.path (.. fennel.path ";" path)))

(fn controller.add-lua-path! [path]
  (set package.path (.. package.path ";" path)))

(fn controller.build-dependencies []
  (let [working-directory (component/io.current-directory)
        main-dot-fnx-path (.. working-directory "/.fnx.fnl")
        dependencies      (controller/injection.build-dependencies-from
                            main-dot-fnx-path (os.getenv "FNX_DATA_DIRECTORY"))]
    (helper/list.map
       #(match (. $1 :language)
         :fennel
           {:language :fennel
            :path (logic/dependencies.injection-path (. $1 :usage-path) :fnl)}
         :lua
           {:language :lua
            :path (logic/dependencies.injection-path (. $1 :usage-path) :lua)})
       dependencies.injections)))

controller
