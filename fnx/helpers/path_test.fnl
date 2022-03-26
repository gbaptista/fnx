(local t (require :fspec))

(local helper (require :fnx.helpers.path))

(t.eq (helper.sanitize "/folder//file/") "/folder/file")

(t.eq (helper.directory "/folder//file/") "/folder")
(t.eq (helper.directory "/folder/lorem/file") "/folder/lorem")

(t.eq (helper.directory "../../radioactive/pastel_mint.lua") "../../radioactive")
(t.eq (helper.directory "./radioactive/pastel_mint.lua") "./radioactive")

(t.eq (helper.directory "radioactive/pastel_mint.lua") "./radioactive")

(t.eq (helper.previous "/folder/lorem") "/folder")
(t.eq (helper.previous "/radioactive") "/")

(t.eq
  (helper.expand "/home/blue" "./red/file.lua")
  "/home/blue/red/file.lua")

(t.eq
  (helper.expand "/home/blue" "./red/../yellow/file.lua")
  "/home/blue/yellow/file.lua")

(t.eq
  (helper.expand "/home/blue" "../red/file.lua")
  "/home/red/file.lua")

(t.eq
  (helper.expand "/home/blue" "../../red")
  "/red")

(t.eq
  (helper.expand "/home/blue" "/lorem")
  "/lorem")

(t.run!)
