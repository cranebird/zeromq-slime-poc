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
	(socket (zmq-socket *zeromq-context* zmq-REQ)))
    (zmq-connect socket "tcp://127.0.0.1:5600")
    (zmq-send socket (zmq-message (format "%s" sexp)))
    (insert "\n")
    (insert (zmq-recv socket))
    (insert "\n")
    (zmq-close socket)))





