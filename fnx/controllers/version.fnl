(local port/shell-out (require :fnx.ports.out.shell))

(local logic/smk (require :fnx.logic.smk))
(local logic/version (require :fnx.logic.version))

(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! []
  (let [core-fnx (model/xpackage.load (.. (os.getenv :FNX_CORE_PATH) "/.fnx.fnl"))]
    (port/shell-out.dispatch!
      (logic/smk.line
        (logic/version.display core-fnx.version)))))

controller
