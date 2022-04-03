(local sn (require :fnx.helpers.supernova))
(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local controller/injection (require :fnx.controllers.injection))
(local controller/bootstrap (require :fnx.controllers.dsl.bootstrap))

(local logic/dependencies (require :fnx.logic.dependencies))
(local logic/smk (require :fnx.logic.smk))
(local helper/list (require :fnx.helpers.list))
(local helper/fennel (require :fnx.helpers.fennel))

(local controller {})

(fn controller.handle! [arguments]
  (controller.dot-fnx!)
  (if (or (. arguments.present :-b))
    (controller.debug-bootstrap! arguments)
    (controller.debug-injections! arguments)))

(fn controller.dot-fnx! []
  (let [working-directory (component/io.working-directory)
        dot-fnx-path      (.. working-directory "/.fnx.fnl")]
    (if (component/io.exists? dot-fnx-path)
      (port/shell-out.dispatch!
        [[:line (sn.yellow dot-fnx-path)]
         [:line ""]])
      (port/shell-out.dispatch!
        (logic/smk.line
          (sn.red "Could not locate .fnx.fnl"))))))

(fn controller.debug-injections! [arguments]
  (let [injections (controller/injection.build-injections! arguments)]
    (controller.display! injections controller.injection-label)))

(fn controller.debug-bootstrap! [arguments]
  (let [injections (controller/bootstrap.build-injections!)]
    (controller.display! injections controller.bootstrap-label)))

(fn controller.display! [injections label-fn]
  (let [names (controller.names-summary injections)
        list  (->> injections
                (helper/list.insert-between-if
                  {:destination "" :path ""}
                  #(not (= (. $1 :destination) (. $2 :destination))))
                (helper/list.map
                  #[[(label-fn (. $1 :destination)) "right" (controller.color-for (. $1 :destination))]
                    [(. $1 :path) "left"]]))]

    (port/shell-out.dispatch!
      [[:line  names]
       [:line  ""]
       [:table list]])))

(fn controller.bootstrap-label [kind]
  (match kind
    :package-path "package.path"
    :fennel-path  "fennel.path"
    :macro-path   "fennel.macro-path"
    _             ""))

(fn controller.injection-label [kind]
  (match kind
    :package-path "--add-package-path"
    :fennel-path  "--add-fennel-path"
    :macro-path   "--add-macro-path"
    _             ""))

(fn controller.names-summary [injections]
  (->> injections
    (helper/list.filter #(not= (. $1 :destination) :macro-path))
    (helper/list.map #((controller.color-for (. $1 :destination)) (. $1 :identifier)))
    (helper/list.uniq)
    (helper/list.join " ")))

(fn controller.color-for [kind]
  (match kind
    :package-path #(sn.blue $1)
    :fennel-path  #(sn.cyan $1)
    :macro-path   #(sn.magenta $1)))

controller
