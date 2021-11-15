(require 'buttercup)
(defvar file_path (if load-in-progress load-file-name (buffer-file-name)))
(defvar dir (file-name-directory file_path))
(defvar pathToLoad (expand-file-name "./../src/glinke.el" dir))
(load pathToLoad)

(describe "glinke-open-file-in-github"
  (describe "when triggered"
    :var ((glinke--get-base-repo-url nil)
          (magit-rev-parse nil)
          (magit-current-file nil)
          (browse-url-firefox nil))
    (before-each
      (spy-on 'glinke--get-base-repo-url :and-return-value "https://github.com/emacs-mirror/emacs")
      (spy-on 'magit-rev-parse :and-return-value "290fe093cd58eca3cb0a3634091bdaca12732893")
      (spy-on 'magit-current-file :and-return-value "myfile")
      (spy-on 'browse-url)
      (glinke-open-file-in-github)
      )
    (it "should then call get-base-repo-url"
      (expect 'glinke--get-base-repo-url :to-have-been-called))
    (it "should get the git HEAD"
      (expect 'magit-rev-parse :to-have-been-called-with "HEAD"))
    (it "should get the current file"
      (expect 'magit-current-file :to-have-been-called))
    (it "should open a web browser with correct url"
      (expect 'browse-url :to-have-been-called-with
              "https://github.com/emacs-mirror/emacs/blob/290fe093cd58eca3cb0a3634091bdaca12732893/myfile"))
    ))

(describe "glinke-open-root-in-github"
  :var (glinke--get-base-repo-url)
  (before-each
    (spy-on 'glinke--get-base-repo-url :and-return-value "https://github.com/emacs-mirror/emacs")
    (spy-on 'browse-url)
    (glinke-open-root-in-github))
  (it "should get the base repo url"
    (expect 'glinke--get-base-repo-url :to-have-been-called))
  (it "should open when browser at project root"
    (expect 'browse-url :to-have-been-called-with "https://github.com/emacs-mirror/emacs")))

(describe "glinke-open-pull-requests"
  :var (glinke--get-base-repo-url)
  (before-each
    (spy-on 'glinke--get-base-repo-url :and-return-value "https://github.com/emacs-mirror/emacs")
    (spy-on 'browse-url)
    (glinke-open-pull-requests))
  (it "should get the base repo url"
    (expect 'glinke--get-base-repo-url :to-have-been-called))
  (it "should open when browser at project pull requests"
    (expect 'browse-url :to-have-been-called-with "https://github.com/emacs-mirror/emacs/pulls")))

(describe "glinke-projectile-open-root-in-github"
  :var (glinke-open-root-in-github projectile-switch-project)
  (before-each
    (spy-on 'glinke-open-root-in-github)
    (spy-on 'projectile-switch-project :and-call-fake (lambda () (funcall projectile-switch-project-action)))
    (glinke-projectile-open-root-in-github))
  (it "should have called projectile-swith-project"
    (expect 'projectile-switch-project :to-have-been-called))
  (it "should call 'glinke-open-root-in-github as the project action after selecting a project"
    (expect 'glinke-open-root-in-github :to-have-been-called)))

(describe "glinke-projectile-open-pull-requests"
  :var (glinke-open-pull-requests projectile-switch-project)
  (before-each
    (spy-on 'glinke-open-pull-requests)
    (spy-on 'projectile-switch-project :and-call-fake (lambda () (funcall projectile-switch-project-action)))
    (glinke-projectile-open-pull-requests))
  (it "should have called projectile-swith-project"
    (expect 'projectile-switch-project :to-have-been-called))
  (it "should call 'glinke-open-pull-requests as the project action after selecting a project"
    (expect 'glinke-open-pull-requests :to-have-been-called)))