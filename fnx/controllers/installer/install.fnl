(local sn (require :fnx.helpers.supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local helper/fennel (require :fnx.helpers.fennel))
(local helper/path (require :fnx.helpers.path))

(local logic/installer (require :fnx.logic.installer))
(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.core-package! [setup-config arguments]
  (let [to   (.. (helper/path.sanitize (. setup-config :fnx-data-directory)) "/core")
        from (helper/path.sanitize (. setup-config :install-from-path))]  
    (controller.ensure-manipulation-allowance! (.. to "/") arguments)
    (component/io.ensure-directory (helper/path.directory to))
    (component/io.os (.. "rm -rf " to))
    (if (. arguments.present :-d)
      (component/io.os (.. "ln -s " from " " to))
      (component/io.os (.. "cp -R " from " " to)))
    (controller.created! (. setup-config :fnx-data-directory) arguments)
    (controller.created! (.. to "/") arguments :symbolic-link)))

(fn controller.binary! [setup-config arguments]
  (let [path (helper/path.sanitize (. setup-config :fnx-binary-path))]
    (controller.ensure-manipulation-allowance! path arguments)
    (component/io.ensure-directory (helper/path.directory path))
    (component/io.write path (controller.binary-source setup-config arguments))
    (component/io.os (.. "chmod +x " path))
    (controller.created! (. setup-config :fnx-binary-path) arguments)))

(fn controller.config-file! [setup-config arguments]
  (let [path   (helper/path.sanitize (. setup-config :fnx-config-file-path))
        config {:fnx-binary-path      (. setup-config :fnx-binary-path)
                :fnx-config-file-path (. setup-config :fnx-config-file-path)
                :fnx-data-directory   (. setup-config :fnx-data-directory)
                :fnx-core-mode        (if (. arguments.present :-d) :symbolic-link :duplicate-files)
                :fnx-core-path        (.. (helper/path.sanitize (. setup-config :fnx-data-directory)) "/core/")}]
    (controller.ensure-manipulation-allowance! path arguments)
    (component/io.ensure-directory (helper/path.directory path))
    (component/io.write path (helper/fennel.data->string config))
    (controller.created! path arguments)))

(fn controller.binary-source [setup-config arguments]
  (let [core-path (.. (helper/path.sanitize (. setup-config :fnx-data-directory)) "/core/")
        data-path (.. (helper/path.sanitize (. setup-config :fnx-data-directory)) "/")]
    (->
      (component/io.read "bin/fnx")
      (string.gsub ":FNX_BINARY_PATH"      (. setup-config :fnx-binary-path))
      (string.gsub ":FNX_CONFIG_FILE_PATH" (. setup-config :fnx-config-file-path))
      (string.gsub ":FNX_DATA_DIRECTORY"   data-path)
      (string.gsub ":FNX_CORE_MODE"        (if (. arguments.present :-d) :symbolic-link :duplicate-files))
      (string.gsub ":FNX_CORE_PATH"        core-path)
      (tostring))))

(fn controller.created! [path arguments kind]
  (if (and (. arguments.present :-d) (= kind :symbolic-link))
    (port/shell-out.dispatch!
      (logic/smk.line
        (.. "created: " (sn.cyan (.. "\""  path "\"")))))
    (port/shell-out.dispatch!
      (logic/smk.line
        (.. "created: " (sn.green (.. "\""  path "\"")))))))

(fn controller.ensure-manipulation-allowance! [path arguments]
  (let [exists? (component/io.exists? path)]
    (if (and exists? (not (. arguments.present :-f)))
      (controller.confirm-overwrite! path))))

(fn controller.confirm-overwrite! [path]
  (port/shell-out.dispatch! (logic/smk.line (sn.yellow (.. "\n\""  path "\""))))
  (port/shell-out.dispatch! (logic/smk.line (.. (. logic/installer :overwrite))))
  (port/shell-out.dispatch! (logic/smk.fragment (sn.blue "[Yn]> ")))
  (let [answer (port/shell-out.retrieve!)]
    (when (= answer "n")
      (port/shell-out.dispatch! (logic/smk.line (.. "\n" logic/installer.canceled)))
      (os.exit))))

controller
