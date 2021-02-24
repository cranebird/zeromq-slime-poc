(in-package :swank/zmq)

(defun start-server (&optional
		       (listen-address "tcp://*:5600")
		       (iopub-address "tcp://*:5700"))
  (pzmq:with-context nil
    (pzmq:with-sockets ((socket :rep) (iopub :pub))
      (pzmq:bind socket listen-address)
      (pzmq:bind iopub iopub-address)
      (format t ";; start server~%")
      (loop
	(let ((msg (pzmq:recv-string socket)))
	  (format t "Received: ~a~%" msg)
	  (let ((out
		  (with-output-to-string (*standard-output*)
		    (let ((result (eval (read-from-string msg))))
		      ;; (format t "Send: ~a~%" result)
		      (pzmq:send socket (format nil "~a" result))))))
	    (pzmq:send iopub out)))))))


