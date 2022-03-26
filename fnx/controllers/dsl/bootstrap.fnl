(local fennel (require :fennel))

(local component/io (require :fnx.components.io))
(local helper/list (require :fnx.helpers.list))
(local logic (require :fnx.logic.bootstrap))
(local logic/dependencies (require :fnx.logic.dependencies))

(local controller/injection (require :fnx.controllers.injection))

(local controller {})

(fn controller.handle! [?main-dot-fnx-path]
  (let [dependencies (controller.build-injections! ?main-dot-fnx-path)]
    (each [_ dependency (pairs dependencies)]
      (match (. dependency :destination)
        :fennel-path  (controller.add-fennel-path!  (. dependency :path))
        :macro-path   (controller.add-macro-path!   (. dependency :path))
        :package-path (controller.add-package-path! (. dependency :path))))))

(fn controller.add-fennel-path! [path]
  (set fennel.path (.. path ";" fennel.path)))

(fn controller.add-macro-path! [path]
  (set fennel.macro-path (.. path ";" fennel.macro-path)))

(fn controller.add-package-path! [path]
  (set package.path (.. path ";" package.path)))

(fn controller.build-injections! [?main-dot-fnx-path]
  (let [dependencies (controller.build-dependencies! ?main-dot-fnx-path)]
    (logic/dependencies.to-injection dependencies.injections)))

(fn controller.build-dependencies! [?main-dot-fnx-path]
  (let [working-directory (or
                            (logic.working-directory ?main-dot-fnx-path)
                            (component/io.current-directory))
        main-dot-fnx-path (or ?main-dot-fnx-path (.. working-directory "/.fnx.fnl"))
        dependencies      (controller/injection.build-dependencies-from
                            main-dot-fnx-path (os.getenv "FNX_DATA_DIRECTORY"))]
    dependencies))

controller
