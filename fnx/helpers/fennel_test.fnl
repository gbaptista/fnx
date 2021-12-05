(local t (require :fspec))

(local helper (require :fnx.helpers.fennel))

(t.eq
  (helper.string->data "{:a 7}")
  {:a 7})

(t.eq
  (helper.data->string {:b 3})
  "{:b 3}")

(t.run!)
