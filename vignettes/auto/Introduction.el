(TeX-add-style-hook
 "Introduction"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("jss" "nojss")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8")))
   (TeX-run-style-hooks
    "latex2e"
    "jss"
    "jss10"
    "amsmath"
    "amsfonts"
    "enumitem"
    "inputenc"))
 :latex)

