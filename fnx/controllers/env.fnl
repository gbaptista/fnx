(local port/shell-out (require :fnx.ports.out.shell))

(local helpers/list (require :fnx.helpers.list))
(local logic/env (require :fnx.logic.env))

(local model/config (require :fnx.models.config))
(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! []
  (let [config (model/config.load (os.getenv :FNX_CONFIG_FILE_PATH))]
     (port/shell-out.dispatch!
       (helpers/list.map
         #[:line (.. "export " $1)]
         (logic/env.build config (os.getenv "FENNEL_PATH"))))))

controller
