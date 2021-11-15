(require 'buttercup)
(defvar file_path (if load-in-progress load-file-name (buffer-file-name)))
(defvar dir (file-name-directory file_path))
(defvar pathToLoad (expand-file-name "./../src/glinke.el" dir))
 (load pathToLoad)
(describe "When using glinke--get-base-repo-url"
  :var (magit-config-get-from-cached-list fut)

  (describe "and on github and origin is set to http"
    (before-each
      (spy-on 'magit-config-get-from-cached-list :and-return-value '("https://github.com/emacs-mirror/emacs.git"))
      (setq fut (glinke--get-base-repo-url)))
    (it "then 'magit-config-get-from-cached-list' is called asking for the remote url"
      (expect 'magit-config-get-from-cached-list :to-have-been-called-with "remote.origin.url"))

    (it "then the return url for viewing on github is set correctly"
      (expect fut :to-equal "https://github.com/emacs-mirror/emacs")))

  (describe "and on github and origin is set to git"
    (before-each
      (spy-on 'magit-config-get-from-cached-list :and-return-value '("git@github.com:emacs-mirror/emacs.git"))
      (setq fut (glinke--get-base-repo-url)))
    (it "then 'magit-config-get-from-cached-list' is called asking for the remote url"
      (expect 'magit-config-get-from-cached-list :to-have-been-called-with "remote.origin.url"))

    (it "then the return url for viewing on github is set correctly"
      (expect fut :to-equal "https://github.com/emacs-mirror/emacs"))
    )
  
  (describe "and not using github"
    (before-each
      (spy-on 'magit-config-get-from-cached-list :and-return-value '("https://gitlab.com/howardabrams/hamacs.git"))
      )
    (it "then an exception should be thrown"
      (expect (glinke--get-base-repo-url) :to-throw 'user-error '("must be a github repo")))
    )

  (describe "and no origin remote is set"
    (before-each
      (spy-on 'magit-config-get-from-cached-list :and-return-value nil))
    (it "then should throw an exception"
      (expect (glinke--get-base-repo-url) :to-throw 'user-error '("no origin set")))
  ))