(defconst theta-syntax-table
  (let ((table (make-syntax-table)))

    ;; _ is a word character in Theta
    (modify-syntax-entry ?_ "w")

    ;; Brackets
    (modify-syntax-entry ?\[ "(]" table)
    (modify-syntax-entry ?\] ")[" table)
    (modify-syntax-entry ?\{ "(}" table)
    (modify-syntax-entry ?\} "){" table)

    ;; Comments
    (modify-syntax-entry ?/ ". 12" table) ;; // starts comments
    (modify-syntax-entry ?\n ">" table) ;; \n ends comments

    table))

                                        ; Syntax Highlighting
(defconst theta-version-keywords
  '("language-version" "avro-version")
  "Keywords that specify version constraints in Theta module headers.")

(defconst theta-definition-keywords
  '("type" "alias")
  "Theta keywords that define new type names.")

(defconst theta-primitive-types
  '("Bool" "Bytes" "Int" "Long" "Float" "Double" "String" "Date" "Datetime")

  "Types that are built into Theta, indexed by the version of
  Theta they were introduced in.")

(defconst theta-font-lock-version-constraints
  (list
   (rx-to-string
    `(: (group-n 1 (or ,@theta-version-keywords))
        (0+ space)
        ":"
        (0+ space)
        (group-n 2 (: (1+ digit) "." (1+ digit) "." (1+ digit)))))
   '(1 font-lock-keyword-face)
   '(2 font-lock-constant-face)))

(defconst theta-font-lock-definitions
  (list
   (rx-to-string
    `(: (group-n 1 (or ,@theta-definition-keywords))
        (1+ space)
        (group-n 2 (1+ word))))
   '(1 font-lock-keyword-face)
   '(2 font-lock-type-face)))

(defconst theta-font-lock-field-definitions
  (list
   (rx-to-string
    `(: (group-n 1 (1+ word))
        (0+ space)
        ":"))
   '(1 font-lock-function-name-face)))

(defconst theta-font-lock-imports
  (list
   (rx-to-string
    `(: (group-n 1 "import")
        (1+ space)
        (group-n 2 (: (0+ (: (1+ word) ".")) (1+ word)))))
   '(1 font-lock-keyword-face)
   '(2 font-lock-reference-face)))

(defconst theta-font-lock-builtin
  (list
   (rx-to-string
    `(: word-start (or ,@theta-primitive-types) word-end))
   '(0 font-lock-builtin-face)))

(defconst theta-font-lock-keywords
  (list theta-font-lock-version-constraints
        theta-font-lock-definitions
        theta-font-lock-field-definitions
        theta-font-lock-imports
        theta-font-lock-builtin))

                                        ; Indentation
(defcustom theta-indent-level 4
  "The indentation level for Theta expressions.")

(require 'smie)

;; Simple grammar for Theta modules
(defconst theta-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((id)

      (version (version-keyword ":" version-number))
      (version-keyword ("language-version")
                       ("avro-version"))
      (version-number (id "." id "." id))

      (statement ("import" id)
                 ("type" type-definition)
                 ("alias" alias-definition))

      (type-definition (id "=" type-body))
      (alias-definition (id "=" id))

      (type-body (type-body "|" type-body)
                 ("{" fields "}"))

      (fields (fields "," fields)
              (id ":" id)))

    '((assoc "|"))
    '((assoc "="))
    '((assoc ","))
    '((assoc ":")))))

(defun theta-indentation-rules (kind token)
  (progn
    (print (cons kind token))
    (pcase (cons kind token)
      ;; The module header should not be indented at all.
      (`(:before . "avro-version") '(column . 0))
      (`(:before . "language-version") '(column . 0))

      ;; Top-level keywords never need to be indented (declarations like
      ;; `type Foo = ...` always start at the beginning of the line)
      (`(:before . "type") '(column . 0))
      (`(:before . "alias") '(column . 0))
      (`(:before . "import") '(column . 0))

      ;; Introduce exactly one extra level of indentation after the =
      ;; in `type Foo = ...` and `alias Foo = ...`
      (`(:after . "=") theta-indent-level)
      (`(:before . "=")
       (if (smie-rule-hanging-p) 0 theta-indent-level))

      ;; Don't introduce any indentation after a record or variant
      ;; body.
      ;;
      ;; In a perfect world we would differentiate between records and
      ;; variants here, but I can't figure out a way to do that as
      ;; things stand now. (Maybe with a custom lexer that
      ;; differentiates between the "}" in records and invariants?)
      (`(:after . "}") (if (smie-rule-bolp) '(column . 0)))

      ;; On lines like `type Foo = {`, don't introduce an extra level of
      ;; indentation on the next line. (One level is introduced by the =
      ;; already.)
      (`(:before . "{")
       (if (smie-rule-hanging-p) (smie-rule-parent)))

      ;; Align fields and variant cases to each other.
      (`(:before . "|") (smie-rule-separator kind))
      (`(:before . ",") (smie-rule-separator kind)))))

                                        ; Mode Definition
(define-derived-mode theta-mode prog-mode "Θ"
  "A mode for working with Theta schema defintions."
  :syntax-table theta-syntax-table

  (set (make-local-variable 'font-lock-defaults) '(theta-font-lock-keywords))
  (set (make-local-variable 'comment-start) "//")

  ;; Hack to fix "(void-variable smie--parent)" errors SMIE was
  ;; generating on calling `smie-rule-parent-p`-style functions.
  (set (make-local-variable 'smie--parent) nil)
  (set (make-local-variable 'smie--after) nil)
  (set (make-local-variable 'smie--token) nil)

  (font-lock-fontify-buffer)

  (smie-setup theta-grammar 'theta-indentation-rules))

(provide 'theta-mode)
