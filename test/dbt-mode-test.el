;;; dbt-mode-test.el --- Tests for dbt-mode

;;; Commentary:

;;; Code:

(require 'dbt-mode nil t)

(require 'htmlfontify)

(defun dbt-mode-test-read-file (name)
  "Read file NAME and return it as a string."
  (with-temp-buffer
    (insert-file-contents name)
    (buffer-string)))

;; Adapted from pm-test-run-on-file from polymode-test-utils
(defun dbt--fontify (file)
  (let ((poly-lock-allow-background-adjustment nil)
        (buf "*dbt/test-file-buffer*"))
    (when (get-buffer buf)
      (kill-buffer buf))
    (with-current-buffer (get-buffer-create buf)
      (switch-to-buffer buf)
      (insert-file-contents file)
      (funcall-interactively #'dbt-mode)
      (goto-char (point-min))
      ;; need this to activate all chunks
      (font-lock-ensure)
      (goto-char (point-min))
      (save-excursion
        (let ((font-lock-mode t))
          (pm-map-over-spans
           (lambda (_)
             (setq font-lock-mode t)
             ;; This is not picked up because font-lock is nil on innermode
             ;; initialization. Don't know how to fix this more elegantly.
             ;; For now our tests are all with font-lock, so we are fine for
             ;; now.
             ;; !! Font-lock is not activated in batch mode !!
             (setq-local poly-lock-allow-fontification t)
             (poly-lock-mode t)
             ;; redisplay is not triggered in batch and often it doesn't trigger
             ;; fontification in X either (waf?)
             (add-hook 'after-change-functions #'pm-test-invoke-fontification t t))
           (point-min) (point-max))))
      (font-lock-ensure)
      (current-buffer))))


(defun dbt-mode-test-htmlize-file (name)
  "Read file NAME, fontify it and return the HTML as a string."
  (save-current-buffer
    (let ((hfy-optimizations (list 'body-text-only 'merge-adjacent-tags 'skip-refontification)))
      (with-current-buffer (dbt--fontify name)
	(with-current-buffer (htmlfontify-buffer) (buffer-string))))))

(ert-deftest dbt-mode-test-fontification ()
  (should
   (equal
    (dbt-mode-test-htmlize-file "test/test.dbt")
    (dbt-mode-test-read-file "test/test.sql.html"))))

;;----------------------------------------------------------------------------

(provide 'dbt-mode-test)

;;; dbt-mode-test.el ends here
