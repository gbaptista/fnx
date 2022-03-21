(local helper/string (require :fnx.helpers.string))

(local component [])

(fn component.directory-for [purpose]
  (match purpose
    :data       (component.build-directory "XDG_DATA_HOME" "/.local/share")
    :config     (component.build-directory "XDG_CONFIG_HOME" "/.config")
    :executable (component.build-directory nil "/.local/bin")))

(fn component.build-directory [env-var default]
  (or
    (when env-var (os.getenv env-var))
    (.. (component.home-directory) default)))

(fn component.home-directory []
  (or
    (os.getenv "HOME")
    (string.gsub (component.os-output "echo ~") "\n" "")))

(fn component.os-output [command]
  (let [pipe    (io.popen command)
        output  (pipe:read "*a")]
    output))

(fn component.os [command]
  (os.execute command))

(fn component.ensure-directory [path]
  (os.execute (.. "mkdir -p " path)))

(fn component.current-directory [command]
  (helper/string.strip (component.os-output "pwd")))

(fn component.exists? [file-path]
  (if (= (component.os-output (.. "ls " file-path " 2>/dev/null")) "")
    false true))

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
