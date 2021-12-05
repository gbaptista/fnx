(local port/shell-out (require :fnx.ports.out.shell))

(local logic/version (require :fnx.logic.version))

(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! []
  (let [core-fnx (model/xpackage.load (.. (os.getenv :FNX_CORE_PATH) "/.fnx.fnl"))]
    (port/shell-out.dispatch!
      [[:line (logic/version.display core-fnx.version)]
       [:line ""]
       [:line "usage:"]
       [:line "  fnx dep install [-f --global]"]
       [:line "  fnx dep uninstall [-f --global]"]
       [:line "  fnx dep list [--global]"]
       [:line ""]])))

controller