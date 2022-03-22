(local t (require :fspec))

(local logic (require :fnx.logic.bootstrap))

(t.eq (logic.working-directory) nil)
(t.eq (logic.working-directory ".fnx.fnl") nil)
(t.eq (logic.working-directory "/.fnx.fnl") "/")
(t.eq (logic.working-directory "/home/me/project/.fnx.fnl") "/home/me/project")

(t.run!)
