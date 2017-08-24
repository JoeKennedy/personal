(in-package :cl-user)
(defpackage personal.migration
  (:use :cl
        :sxql
        :datafly)
  (:import-from :personal.db
                :db
                :with-connection
                :with-transaction)
  (:import-from :datafly
                :execute)
  (:export :create-tables
           :create-project-table
           :create-link-table))
(in-package :personal.migration)

;; Create all tables
(defun create-tables ()
  "Create all tables that don't yet exist"
  (create-project-table)
  (create-link-table))

;; 1st migration
(defun create-project-table ()
  "Create project table if it doesn't exist yet."
  (with-connection (db)
    (execute
      (create-table (:project :if-not-exists t)
          ((id :type 'serial :primary-key t)
           (project-type :type 'varchar :not-null t)
           (name :type 'varchar :not-null t :unique t)
           (description :type 'text :not-null t :unique t)
           (created-at :type 'timestamp :not-null t)
           (updated-at :type 'timestamp :not-null t))))))

;; 2nd migration
(defun create-link-table ()
  "Create link table if it doesn't exist yet."
  (with-connection (db)
    (execute
      (create-table (:link :if-not-exists t)
          ((id :type 'serial :primary-key t)
           (project-id :type 'integer :not-null t)
           (link-type :type 'varchar :not-null t)
           (name :type 'varchar :not-null t :unique t)
           (url :type 'varchar :not-null t :unique t)
           (order :type 'integer :not-null t)
           (created-at :type 'timestamp :not-null t)
           (updated-at :type 'timestamp :not-null t))
        (foreign-key '(:project-id) :references '(:project :id))))))
