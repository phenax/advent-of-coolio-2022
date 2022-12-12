#lang racket

(require megaparsack megaparsack/text)
(require data/monad data/applicative)

(define space-consumer/p (many/p space/p))

(define (key-val/p key val/p) (do
  (string/p key)
  (string/p ": ")
  [result <- val/p]
  space-consumer/p
  (pure result)))

(define expr/p (or/p integer/p (string/p "old")))
(define operator/p (or/p (char/p #\+) (char/p #\*)))

(define binary-op/p (do
  [first <- expr/p]
  space-consumer/p
  [op <- operator/p]
  space-consumer/p
  [second <- expr/p]
  (pure (list first op second))))

(struct monkey (index items operation test inspected) #:mutable #:inspector #f)

(define monkey/p
  (do
    (string/p "Monkey ")
    [num <- integer/p]
    (string/p ":")
    space-consumer/p

    [starting-items <- (key-val/p "Starting items" (many-until/p
      integer/p
      #:end (string/p "\n")
      #:sep (string/p ", ")
    ))]

    [operation <- (key-val/p "Operation" (do
      (string/p "new =")
      space-consumer/p
      binary-op/p
    ))]

    [test <- (key-val/p "Test" (do
      (string/p "divisible by ")
      [divisible-by <- integer/p]
      space-consumer/p
      [if-true <- (key-val/p "If true" (do (string/p "throw to monkey ") integer/p))]
      space-consumer/p
      [if-false <- (key-val/p "If false" (do (string/p "throw to monkey ") integer/p))]
      (pure (list divisible-by if-true if-false))
    ))]

    (pure (monkey num (first starting-items) operation test 0))))

(define (to-monkey-hash monkey)
  (for/hash ([item monkey])
    (values (monkey-index item) item)
  ))

(define (run-operation worry operation)
  (match (for/list ([op operation]) (if (equal? op "old") worry op))
    [ (list first #\+ second) (+ first second) ]
    [ (list first #\* second) (* first second) ]
    [ _ 0 ]
   ))

(define (throw-to-monkey from to worry monkeys)
  (begin
    (define from-monkey (hash-ref monkeys from))
    (define to-monkey (hash-ref monkeys to))
    (set-monkey-items!
      to-monkey
      (append (monkey-items to-monkey) (list worry))
    )
    (set-monkey-items!
      from-monkey
      (cdr (monkey-items from-monkey))
    )
    (set-monkey-inspected! from-monkey (+ (monkey-inspected from-monkey) 1))
    monkeys
  ))

(define (chase-monkey div-by monkeys)
  (define lcm (for/product ([m (hash-values monkeys)]) (car (monkey-test m))))

  (for/fold ([acc monkeys]) ([monkey (hash-values monkeys)])
    (if (null? (monkey-items monkey))
      acc
      (for/fold ([acc acc]) ([item (monkey-items monkey)])
        (let*
          ([ worry
            (modulo
              (quotient (run-operation item (monkey-operation monkey)) div-by)
              lcm) ]
           [ divisible?
            (zero? (modulo worry (car (monkey-test monkey)))) ])

          (match-let*
            ([(list divtest true-monkey false-monkey) (monkey-test monkey) ])
            (if divisible?
              (throw-to-monkey (monkey-index monkey) true-monkey worry acc)
              (throw-to-monkey (monkey-index monkey) false-monkey worry acc))
          )
      )
    )
  )
))

(define product-of-top-2
  (compose1
    (lambda (ls)
      (for/product ([m (take ls 2)]) (monkey-inspected m)))
    (lambda (ls) (sort ls > #:key monkey-inspected))
    hash-values
  ))

(define get-monkey-hash
  (compose1
    to-monkey-hash
    (curry map (compose1 parse-result! (curry parse-string monkey/p)))
  ))

(define evaluate-my-monkeys-1
  (compose1
    product-of-top-2
    (lambda (mks) (foldl (lambda (_ mks) (chase-monkey 3 mks)) mks (range 20)))
    get-monkey-hash
  ))

(define evaluate-my-monkeys-2
  (compose1
    product-of-top-2
    (lambda (mks) (foldl (lambda (_ mks) (chase-monkey 1 mks)) mks (range 10000)))
    get-monkey-hash
  ))

(define monkey-string-list (string-split (file->string "./input.txt") "\n\n"))

(print "Result 1: ")
(println (evaluate-my-monkeys-1 monkey-string-list))

(print "Result 2: ")
(println (evaluate-my-monkeys-2 monkey-string-list))

