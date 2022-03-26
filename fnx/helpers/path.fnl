(local helper/string (require :fnx.helpers.string))
(local helper/list (require :fnx.helpers.list))

(local helper {})

(fn helper.directory [input]
  (let [parts (->> input (helper.sanitize) (helper/string.split "/"))]
  (table.remove parts (length parts))
  (let [path (helper/list.join "/" parts)]
    (if (string.match input "^%.")
      path
      (if (string.match input "^%/")
        (.. "/" path)
        (.. "./" path))))))
  
(fn helper.sanitize [input]
  (-> input (string.gsub "//" "/") (string.gsub "/$" "")))

(fn helper.previous [path]
  (helper.expand path ".."))

(fn helper.expand [reference path]
  (if (not (string.match reference "^%/"))
    (error (.. "invalid reference path: \"" reference "\"")))

  (if (string.match path "^%/")
    (helper.expand "/" (string.gsub path "^%/" ""))
    (do
      (let [breadcrumb (->> reference (helper.sanitize) (helper/string.split "/"))
            navigation (->> path (helper.sanitize) (helper/string.split "/"))]

        (each [_ direction (pairs navigation)]
          (match direction
            "."  nil
            ".." (table.remove breadcrumb (length breadcrumb))
            _    (table.insert breadcrumb direction)))

        (.. "/" (helper/list.join "/" breadcrumb))))))

helper
