(local sn (require :fnx.helpers.supernova))

(local port/shell-out (require :fnx.ports.out.shell))

(local component/io (require :fnx.components.io))

(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.fnx-file-exists? [arguments]
  (let [working-directory (component/io.working-directory)
        fnx-file-path     (.. working-directory "/.fnx.fnl")]
    (if (component/io.exists? fnx-file-path)
      true
      (do
        (port/shell-out.dispatch!
          (logic/smk.line
            (sn.red "Could not locate .fnx.fnl")))
        false))))

controller
