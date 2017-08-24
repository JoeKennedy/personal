(in-package :cl-user)
(defpackage personal-asd
  (:use :cl :asdf))
(in-package :personal-asd)

(defsystem personal
  :version "0.1"
  :author "Joe Kennedy"
  :license "MIT"
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop

               ;; for @route annotation
               :cl-syntax-annot

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql)
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "model"))
                 (:file "view" :depends-on ("config"))
                 (:file "migration" :depends-on ("db"))
                 (:file "model" :depends-on ("db"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op personal-test))))
