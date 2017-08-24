(in-package :cl-user)
(defpackage personal.model
  (:use :cl
        :sxql
        :datafly)
  (:import-from :personal.config
                :config)
  (:import-from :personal.db
                :db
                :with-connection)
  (:import-from :datafly
                :execute
                :retrieve-all
                :retrieve-one))
  ; (:export :get-projects
  ;          :get-project
  ;          :get-links))
(in-package :personal.model)

; (defmodel (link (:inflate created-at #'datetime-to-timestamp)
;                 (:inflate updated-at #'datetime-to-timestamp))
;   id
;   type
;   project-id
;   url
;   order
;   created-at
;   updated-at
;   )
