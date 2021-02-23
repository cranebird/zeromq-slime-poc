(defsystem :zeromq-slime-poc
  :depends-on (:pzmq)
  :serial t
  :components ((:file "package")
	       (:file "zmq-swank")))
