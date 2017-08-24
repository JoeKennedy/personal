(in-package :cl-user)
(defpackage personal.web
  (:use :cl
        :caveman2
        :personal.config
        :personal.view
        :personal.db
        :personal.model
        :datafly
        :sxql)
  (:import-from :personal.db
                :db
                :with-connection)
  (:import-from :personal.db
                :db
                :with-connection)
  ; (:import-from :personal.model
  ;               :get-projects
  ;               :get-project
  ;               :get-links)
  (:export :*web*))
(in-package :personal.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Models
(defmodel (project (:inflate created-at #'datetime-to-timestamp)
                   (:inflate updated-at #'datetime-to-timestamp)
                   (:has-many (links link)
                    (select :* 
                      (from :link)
                      (where (:= :project-id id))
                      (order-by (:desc :order)))))
  id
  project-type
  name
  description
  created-at
  updated-at
  )

(defun get-projects ()
  "Select all projects from DB"
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :project)
       (order-by (:desc :name))))))

(defun get-project (id)
  "Select project by id from DB"
  (with-connection (db)
    (retrieve-one
      (select :*
        (from :project)
        (where (:= :id id)))
      :as 'project)))

(defun get-links (project)
  "Get links by project"
  (with-connection (db) (project-links project)))

;; Helpers

(defun project-type-options ()
  "Project types with their values"
  '(("Project" . "project")
    ("Library" . "library")))

(defun link-type-options ()
  "Link types with their values"
  '(("Website"   . "website")
    ("Image"     . "image")
    ("Github"    . "github")
    ("Language"  . "language")
    ("Database"  . "database")
    ("Framework" . "framework")))

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))
(defroute "/employment" ()
  (render #P"employment.html"))
(defroute "/libraries" ()
  (render #P"libraries.html"))
(defroute "/projects" ()
  (render #P"projects.html"))
(defroute "/about" ()
  (render #P"about.html"))

(defroute ("/admin" :method :GET) ()
  (render #P"admin.html"
          (list :projects (get-projects)
                :project-type-options (project-type-options)
                :link-type-options (link-type-options)
                :link (list :order 0))))

(defroute ("/admin" :method :POST) ()
  (format nil "~S" (cdr (assoc "project" _parsed :test #'string=)))
          )

(defroute ("/admin/:id" :method :GET) (&key id)
  (let ((project (get-project id)))
    (let ((links (get-links project)))
      (render #P"admin.html"
              (list :projects (get-projects)
                    :project-id (project-id project)
                    :project-name (project-name project)
                    :project-type (project-project-type project)
                    :project-description (project-description project)
                    :project-type-options (project-type-options)
                    :links links
                    :link (list :order (length links))
                    :link-type-options (link-type-options))))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
