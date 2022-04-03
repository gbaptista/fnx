(local controller/install (require :fnx.controllers.dep.install))

(local controller {})

(fn controller.handle! [arguments]
  (table.insert arguments.list "--global")
  (tset arguments.present "--global" true)

  (controller/install.handle!
    arguments
    (string.gsub (os.getenv :FNX_CORE_PATH) "%/$" "")))

controller
