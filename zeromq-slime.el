(require 'zmq)

(defvar *zeromq-context* nil)

(defun zeromq-slime-mode ()
  "toy slime"
  (interactive)
  (let ((buffer (get-buffer-create "*cl-scratch*")))
    (switch-to-buffer buffer)    
    (kill-all-local-variables)
    (setq zeromq-slime-mode-local-map (make-keymap))    
    (define-key zeromq-slime-mode-local-map "\C-j" 'zeromq-slime-send)
    (setq mode-name "ZMQ-SLIME")
    (setq major-mode 'zeromq-slime-mode)
    (setq *zeromq-context* (zmq-current-context))
    (use-local-map zeromq-slime-mode-local-map)))

(defun zeromq-slime-send ()
  (interactive)
  (let ((sexp (preceding-sexp))
	(socket (zmq-socket *zeromq-context* zmq-REQ))
	(iopub (zmq-socket *zeromq-context* zmq-SUB)))
    (zmq-connect socket "tcp://127.0.0.1:5600")
    (zmq-set-option iopub zmq-SUBSCRIBE "")
    (zmq-connect iopub "tcp://127.0.0.1:5700")
    (zmq-send socket (zmq-message (format "%S" sexp)))
    (insert "\n")
    (insert (zmq-recv iopub))
    (insert "\n")
    (insert (zmq-recv socket))
    (insert "\n")
    (zmq-close socket)
    (zmq-close iopub)))





