; Some utility functions that you may find useful.
(define (apply-to-all proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
            (apply-to-all proc (cdr items)))))

(define (keep-if predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (keep-if predicate (cdr sequence))))
        (else (keep-if predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (cadar x) (car (cdr (car x))))

; Problem 18
;; Turns a list of pairs into a pair of lists
(define (zip pairs)

  (define (append x lst)
    (cond
      ((null? lst) (cons x nil))
      (else (cons (car lst) (append x (cdr lst))))
    )
  )

  (define (zip-helper pairs curr)
    (if (eq? nil pairs)
      curr
      (zip-helper (cdr pairs)
        (cons 
          (append (caar pairs) (car curr)) 
          (cons (append (cadar pairs) (cadr curr)) nil)))))
  
  (zip-helper pairs '(() ()))
)

(zip '())
; expect (() ())
(zip '((1 2)))
; expect ((1) (2))
(zip '((1 2) (3 4) (5 6)))
; expect ((1 3 5) (2 4 6))

; Problem 19

;; A list of all ways to partition TOTAL, where  each partition must
;; be at most MAX-VALUE and there are at most MAX-PIECES partitions.
(define (list-partitions total max-pieces max-value)
  (define pred (lambda (x) (<= (length x) max-pieces)))
  (define (part-helper n m)
    (cond
      ((> 0 n) '())
      ((zero? m) '())
      ((zero? n) '((0)))
      (else 
          (define yes (part-helper (- n m) m))
          (define no (part-helper n (- m 1)))
          (define (add-m s) (if (eq? s '(0)) (cons m nil) (cons m s)))
          (define yes (keep-if pred (apply-to-all add-m yes)))
          (append yes no))))
  (if (zero? total) '((0)) (part-helper total max-value)))

(list-partitions 5 2 4)
; expects a permutation of ((4 1) (3 2))
(list-partitions 7 3 5)
; expects a permutation of ((5 2) (5 1 1) (4 3) (4 2 1) (3 3 1) (3 2 2))


; Problem 20
;; Returns a function that takes in an expression and checks if it is the special
;; form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (analyze expr)
  (cond ((atom? expr)
         expr
         )
        ((quoted? expr)
         expr
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
            (define body (apply-to-all analyze body))
               (cons form (cons params body))
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           (define params (car (zip values)))
              (define formals (cadr (zip values)))
              (analyze (cons (cons 'lambda (cons params body)) formals))
           ))
        (else
         expr
         )))

(analyze 1)
; expect 1
(analyze 'a)
; expect a
(analyze '(+ 1 2))
; expect (+ 1 2)

;; Quoted expressions remain the same
(analyze '(quote (let ((a 1) (b 2)) (+ a b))))
; expect (quote (let ((a 1) (b 2)) (+ a b)))

;; Lambda parameters not affected, but body affected
(analyze '(lambda (let a b) (+ let a b)))
; expect (lambda (let a b) (+ let a b))
(analyze '(lambda (x) a (let ((a x)) a)))
; expect (lambda (x) a ((lambda (a) a) x))

(analyze '(let ((a 1)
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) 1 2)
(analyze '(let ((a (let ((a 2)) a))
                (b 2))
            (+ a b)))
; expect ((lambda (a b) (+ a b)) ((lambda (a) a) 2) 2)
(analyze '(let ((a 1))
            (let ((b a))
              b)))
; expect ((lambda (a) ((lambda (b) b) a)) 1)


;; Problem 21 (optional)
;; Draw the hax image using turtle graphics.
(define (hax d k)
  'YOUR-CODE-HERE
  nil)




