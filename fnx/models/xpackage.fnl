(local component/io (require :fnx.components.io))

(local helper/fennel (require :fnx.helpers.fennel))

(local model {})

(fn model.load [path]
  (let [data (->>
              path
              (component/io.read)
              (helper/fennel.string->data))]
    (when (not (. data :dependencies))
      (tset data :dependencies {}))
    data))

model
