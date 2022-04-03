(local sn (require :fnx.helpers.supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local controller/install (require :fnx.controllers.installer.install))
(local controller/setup (require :fnx.controllers.installer.setup))

(local logic/installer (require :fnx.logic.installer))
(local logic/smk (require :fnx.logic.smk))
(local logic/version (require :fnx.logic.version))

(local model/xpackage (require :fnx.models.xpackage))

(local controller {})

(fn controller.handle! [arguments]
  (let [fnx-to-install
           (model/xpackage.load (.. (component/io.current-directory) "/.fnx.fnl"))]
    (port/shell-out.dispatch!
      (logic/smk.line
        (logic/version.display fnx-to-install.version)))

    (local setup-config
      (controller/setup.ensure-config! {
        :install-from-path      (.. (component/io.current-directory) "/")
        :fnx-binary-path        (.. (component/io.directory-for :executable) "/fnx")
        :fnx-config-file-path   (.. (component/io.directory-for :config) "/.fnx.config.fnl")
        :fnx-data-directory     (.. (component/io.directory-for :data) "/.fnx/")}
        arguments))

    (controller/setup.double-check! setup-config arguments)

    (port/shell-out.dispatch! (logic/smk.line "\nInstalling..."))

    (if (. arguments.present :-f)
      (port/shell-out.dispatch! (logic/smk.line "")))

    (controller/install.config-file! setup-config arguments)
    (controller/install.core-package! setup-config arguments)
    (controller/install.binary! setup-config arguments)

    (port/shell-out.dispatch! (logic/smk.line (sn.green "\nFinished!")))

    (port/shell-out.dispatch!
      (logic/smk.line
        (logic/installer.welcome fnx-to-install.version)))))

controller
