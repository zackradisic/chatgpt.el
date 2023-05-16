;;; chatgpt.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Zack Radisic
;;
;; Author: Zack Radisic <zack@theradisic.com>
;; Maintainer: Zack Radisic <zack@theradisic.com>
;; Created: May 15, 2023
;; Modified: May 15, 2023
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/zackradisic/chatgptz
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; ChatGPT
;;
;;; Code:
(require 'url)
(require 'json)

(defgroup chatgpt nil
  "Configuration for chatgpt."
  :prefix "chatgpt-"
  :group 'ai)

(defvar chatgpt-buffer "*ChatGPT*"
  "Name of the buffer for ChatGPT.")

(defvar chatgpt-api-key "YOUR-API-KEY"
  "API Key for OpenAI's ChatGPT.")

(defvar chatgpt-api-url "https://api.openai.com/v1/chat/completions"
  "API URL for OpenAI's ChatGPT.")

(defun chatgpt-request (prompt)
  "Send PROMPT to ChatGPT and return the response."
  (let ((url-request-method "POST")
        (url-request-extra-headers
         `(("Content-Type" . "application/json")
           ("Authorization" . ,(concat "Bearer " chatgpt-api-key))))
        (url-request-data
         (json-encode `(("messages" . [((("role" . "user") ("content" . ,prompt)))])
                        ("model" . "gpt-4")))))
    (with-current-buffer (url-retrieve-synchronously chatgpt-api-url)
      (goto-char url-http-end-of-headers)
      (json-read))))

(defun chatgpt (prompt)
  "Chat with ChatGPT.
PROMPT is the text to send to ChatGPT."
  (interactive "sPrompt: ")
  (let ((response (chatgpt-request prompt)))
    (with-current-buffer (get-buffer-create chatgpt-buffer)
      (goto-char (point-max))
      (insert (format "You: %s\n" prompt))
      (insert (format "ChatGPT: %s\n" (cdr (assoc 'text (cdr (assoc 'choices (assoc 'model (assoc 'model response))))))))
      (display-buffer chatgpt-buffer))))

(defun chatgpt-sidebar ()
  "Open a sidebar for chatting with ChatGPT."
  (interactive)
  (let ((buffer (get-buffer-create chatgpt-buffer)))
    (display-buffer-in-side-window buffer '((side . right)))))


(provide 'chatgpt)
;;; chatgpt.el ends here
