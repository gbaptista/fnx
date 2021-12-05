(local port/shell-out (require :fnx.ports.out.shell))

(local helper/fennel (require :fnx.helpers.fennel))

(local logic/version (require :fnx.logic.version))

(local model/config (require :fnx.models.config))
(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! []
  (let [core-fnx (model/xpackage.load (.. (os.getenv :FNX_CORE_PATH) "/.fnx.fnl"))
        config        (model/config.load  (os.getenv :FNX_CONFIG_FILE_PATH))]
    (port/shell-out.dispatch!
      [[:line (logic/version.display core-fnx.version)]
       [:line (helper/fennel.data->string config)]])))

controller
