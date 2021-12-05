(local component [])

(local lfs (require :lfs))

(fn component.os-output [command]
  (let [pipe    (io.popen command)
        output  (pipe:read "*a")]
    output))

(fn component.os [command]
  (os.execute command))


(fn component.ensure-directory [path]
  (os.execute (.. "mkdir -p " path)))

(fn component.current-directory [command]
  (lfs.currentdir))

(fn component.exists? [file-path]
  (let [details (lfs.attributes file-path)]
    (if details true false)))

(fn component.read [file-path]
  (match (io.open file-path)
    (nil message) (error message)
    file          (let [content (: file :read "*all")]
                    (: file :close)
                    content)))

(fn component.write [file-path content]
  (match (io.open file-path :w)
    (nil message) (error message)
    file          (do (: file :write content) (: file :close))))

component
