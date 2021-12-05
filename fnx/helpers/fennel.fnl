(local fennel (require :fennel))

(local helper {})

(fn helper.string->data [data]
  (fennel.eval data))

(fn helper.data->string [data]
  (fennel.view data))

helper
