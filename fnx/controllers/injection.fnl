(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local helper/list (require :fnx.helpers.list))
(local helper/path (require :fnx.helpers.path))

(local logic/dependencies (require :fnx.logic.dependencies))
(local logic/smk (require :fnx.logic.smk))

(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! [arguments]
  (let [injections (controller.build-injections! arguments)]
    (port/shell-out.dispatch!
      (logic/smk.fragment
        (.. " "
          (->> injections
            (helper/list.map
              #(match (. $1 :destination)
                :fennel-path  (.. "--add-fennel-path " (. $1 :path))
                :macro-path   (.. "--add-macro-path "  (. $1 :path))
                :package-path (.. "--add-package-path "  (. $1 :path))))
            (helper/list.join " ")))))))

(fn controller.build-injections! [arguments]
  (let [working-directory (component/io.working-directory)
        main-dot-fnx-path (.. working-directory "/.fnx.fnl")
        dependencies      (controller.build-dependencies-from
                            main-dot-fnx-path
                            (os.getenv "FNX_DATA_DIRECTORY")
                            (controller.self-injection working-directory))]

    (logic/dependencies.to-injection dependencies.injections)))

(fn controller.self-injection [working-directory]
  {:injections [{:cyclic-key (.. "self:" working-directory)
   :dot-fnx-candidate-path (.. working-directory "/.fnx.fnl")
   :identifier "fspec"
   :language "fennel"
   :provider "local"
   :usage-path working-directory}] :cyclic-control { :dot-fnx {} :injection {} }})

(fn controller.build-dependencies-from [dot-fnx-path fnx-data-directory ?acc]
  (let [acc (or ?acc {:injections [] :cyclic-control { :dot-fnx {} :injection {} }})]
    (if (. acc.cyclic-control.dot-fnx dot-fnx-path)
      acc
      (let [dependencies (controller.dependencies-for dot-fnx-path fnx-data-directory)]
        (tset acc.cyclic-control.dot-fnx dot-fnx-path true)
        (each [_ dependency (pairs dependencies)]
          (controller.build-dependencies-from
            (. dependency :dot-fnx-candidate-path)
            fnx-data-directory
            acc)

          (when (not (. acc.cyclic-control.injection dependency.cyclic-key))
            (tset acc.cyclic-control.injection dependency.cyclic-key true)
            (table.insert acc.injections dependency)))
        acc))))

(fn controller.dependencies-for [dot-fnx-path fnx-data-directory]
  (let [working-directory (helper/path.directory dot-fnx-path)]
    (if (not (component/io.exists? dot-fnx-path))
      []
      (->>
        dot-fnx-path
        (model/xpackage.load)
        (#(. $1 :dependencies))
        (logic/dependencies.build working-directory fnx-data-directory)
        (logic/dependencies.injection-candidates)
        (helper/list.filter #(component/io.exists? (. $1 :usage-path)))))))

controller
