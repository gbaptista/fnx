(local t (require :fspec))

(local component (require :fnx.components.io))

(t.eq (component.exists? "fnx/components/io.fnl") true)
(t.eq (component.exists? "iox.fnl") false)

(t.run!)
