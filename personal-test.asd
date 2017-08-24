(in-package :cl-user)
(defpackage personal-test-asd
  (:use :cl :asdf))
(in-package :personal-test-asd)

(defsystem personal-test
  :author "Joe Kennedy"
  :license ""
  :depends-on (:personal
               :prove)
  :components ((:module "t"
                :components
                ((:file "personal"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
