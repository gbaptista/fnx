(local helper/list (require :fnx.helpers.list))
(local helper/string (require :fnx.helpers.string))
(local helper/path (require :fnx.helpers.path))

(local logic {})

(fn logic.build [working-directory fnx-data-directory raw-dependencies]
  (local result [])
  (each [identifier configuration (pairs raw-dependencies)]
    (table.insert
      result
      (logic.build-dependency
        identifier configuration working-directory fnx-data-directory)))
  (helper/list.sort-by :identifier result)
  result)

{:cyclic-key "fnx:/home/.fnx/packages/package-a/local"
 :dot-fnx-candidate-path "/home/.fnx/packages/package-a/local/.fnx.fnl"
 :identifier "package-a"
 :install-from {:mode "local" :path "/lorem"}
 :language "fennel"
 :provider "fnx"
 :usage-path "/home/.fnx/packages/package-a/local"}

(fn logic.build-fnx [dependency identifier configuration working-directory fnx-data-directory]
  (var mode nil)

  (when (. configuration :path)          (set mode :path))
  (when (. configuration :git/url)       (set mode :git/url))
  (when (. configuration :git/github)    (set mode :git/github))
  (when (. configuration :git/sourcehut) (set mode :git/sourcehut))

  (match mode
     :git/url
       (tset dependency :install-from { :mode :git :url (. configuration :git/url) })
     :git/github
       (tset
         dependency
         :install-from
         { :mode :git
           :url (.. "https://github.com/" (. configuration :git/github) ".git")})
     :git/sourcehut
       (tset
         dependency
         :install-from
         { :mode :git
           :url (.. "https://git.sr.ht/" (. configuration :git/sourcehut))})
     :path
       (do
         (if (not (string.match (. configuration :path) "^%/"))
           (error
             (.. "fnx packages don't accept relative paths: " "[" identifier "] "
                 "\"" (. configuration :path) "\"")))

         (tset dependency
           :install-from
           { :mode :local
             :path (helper/path.expand working-directory (. configuration :path))})))
  
  (var version nil)

  (when (= dependency.install-from.mode :git)
    (when (. configuration :commit)
      (let [commit (. configuration :commit)]
        (tset dependency.install-from :commit commit)
        (if (not version) (set version (string.sub commit 1 7)))))

    (when (. configuration :branch)
      (let [branch (. configuration :branch)]
        (tset dependency.install-from :branch branch)
        (if (not version) (set version branch))))

    (when (. configuration :tag)
      (let [tag (. configuration :tag)]
        (tset dependency.install-from :tag tag)
        (if (not version) (set version tag)))))

  (if version nil (set version "local"))

  (tset dependency.install-from :version version)

  (tset dependency
    :usage-path
    (helper/path.expand
      "/"
      (.. fnx-data-directory "packages/" identifier "/" version))))

(fn logic.build-dependency [identifier configuration working-directory fnx-data-directory]
  (local dependency { :identifier identifier })
  (each [strategy configuration (pairs configuration)]
    (let [parts (helper/string.split "/" strategy)
          language (. parts 1)
          provider (. parts 2)]
      (tset dependency :language language)
      (tset dependency :provider provider)
      (match provider
        :local (tset dependency :usage-path (helper/path.expand working-directory configuration))
        :rock  (tset dependency :install-from { :mode :luarocks :version configuration })
        :fnx   (logic.build-fnx dependency identifier configuration working-directory fnx-data-directory))))

  (match dependency.provider
    :fnx   (tset dependency :cyclic-key (.. "fnx:" dependency.usage-path))
    :rock  (tset dependency :cyclic-key (.. "rock:" dependency.identifier))
    :local (tset dependency :cyclic-key (.. dependency.language ":" dependency.usage-path)))

  (if (. dependency :usage-path)
    (tset
      dependency
      :dot-fnx-candidate-path
      (let [path (. dependency :usage-path)]
        (if (string.match path "%.%a%a%a$")
          (.. (helper/path.directory path) "/.fnx.fnl")
          (.. path "/.fnx.fnl")))))

  dependency)

(fn logic.injection-candidates [dependencies]
  (helper/list.filter #(. $1 :usage-path) dependencies))

(fn logic.injection-path [usage-path extension]
  (if (string.match usage-path (.. "%." extension "$"))
    (let [directory (helper/path.directory usage-path)]
      (.. directory "/?." extension))
    (.. usage-path "/?." extension)))

(fn logic.to-injection [dependencies is-debug]
  (let [injections
          (->>
            dependencies
            (helper/list.map
              #(match (. $1 :language)
                :fennel (.. "--add-fennel-path "  (logic.injection-path (. $1 :usage-path) :fnl))
                :lua    (.. "--add-package-path " (logic.injection-path (. $1 :usage-path) :lua)))
              dependencies))]
  
    (if is-debug
      (do
        (helper/list.sort injections)
        (.. (helper/list.join "\n" injections) "\n"))
      (.. " " (helper/list.join " " injections)))))

logic
