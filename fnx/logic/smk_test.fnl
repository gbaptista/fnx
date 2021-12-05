(local t (require :fspec))

(local logic (require :fnx.logic.smk))

(t.eq
  (logic.line "content")
  [[:line "content"]])

(t.eq
  (logic.line "fragment")
  [[:line "fragment"]])

(t.run!)
