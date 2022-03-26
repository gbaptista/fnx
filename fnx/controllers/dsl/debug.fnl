(local helper/list (require :fnx.helpers.list))

(local component/io (require :fnx.components.io))

(local controller/bootstrap (require :fnx.controllers.dsl.bootstrap))
(local controller/dependencies (require :fnx.controllers.dep.dependencies))

(local controller {})

(fn controller.injections [?main-dot-fnx-path]
  (let [dependencies (controller/bootstrap.build-injections! ?main-dot-fnx-path)]
    (helper/list.map
      #{:package     (. $1 :identifier)
        :destination (controller.bootstrap-label (. $1 :destination))
        :path        (. $1 :path) }
      dependencies)))

(fn controller.dot-fnx-path [?main-dot-fnx-path]
  (or ?main-dot-fnx-path (.. (component/io.current-directory) "/.fnx.fnl")))

(fn controller.packages [?main-dot-fnx-path]
  (let [dot-fnx-path (controller.dot-fnx-path ?main-dot-fnx-path)
        dependencies (controller/dependencies.dependencies-for dot-fnx-path)]
    (helper/list.map
          #{:package      (. $1 :identifier)
            :language     (. $1 :language)}
          dependencies)))

(fn controller.packages-backup [?main-dot-fnx-path]
  (let [dependencies (controller/bootstrap.build-dependencies! ?main-dot-fnx-path)]
    (helper/list.map
          #{:package  (. $1 :identifier)
            :language (. $1 :language)
            :path     (. $1 :usage-path)
          } dependencies.injections)))

(fn controller.bootstrap-label [kind]
  (match kind
    :package-path "package.path"
    :fennel-path  "fennel.path"
    :macro-path   "fennel.macro-path"
    _             ""))

controller
