(in-package :swank/zmq)

(defun start-server (&optional (listen-address "tcp://*:5600"))
  (pzmq:with-socket socket :rep
    (pzmq:bind socket listen-address)
    (format t ";; start server~%")
    (loop
      (let ((msg (pzmq:recv-string socket)))
	(format t "Received: ~a~%" msg)
	(let ((result (eval (read-from-string msg))))
	  (format t "Send: ~a~%" result)
	  (pzmq:send socket (format nil "~a" result)))))))

