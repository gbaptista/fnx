(local component/io (require :fnx.components.io))

(local helper/fennel (require :fnx.helpers.fennel))

(local model {})

(fn model.load [path]
  (->>
    path
    (component/io.read)
    (helper/fennel.string->data)))

model
