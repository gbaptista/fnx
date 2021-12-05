(local port/shell-out (require :fnx.ports.out.shell))

(local helper/list (include :fnx.helpers.list))

(local logic/smk (require :fnx.logic.smk))

(local controller {})

(fn controller.handle! [should-trap arguments]
  (let [should (helper/list.exists? (. arguments.list 1) should-trap)]
    (when should (port/shell-out.dispatch! (logic/smk.fragment "t")))))

controller
