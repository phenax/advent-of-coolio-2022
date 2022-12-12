#lang racket

(require megaparsack megaparsack/text)
(require data/monad data/applicative)

#|
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3
|#

(define space-consumer/p (many/p space/p))

(define (parse-key-val key val/p) (do
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

(define monkey/p
  (do
    (string/p "Monkey ")
    [num <- integer/p]
    (string/p ":")
    space-consumer/p

    [starting-items <- (parse-key-val "Starting items" (many-until/p
      integer/p
      #:end (string/p "\n")
      #:sep (string/p ", ")
    ))]

    [operation <- (parse-key-val "Operation" (do
      (string/p "new =")
      space-consumer/p
      binary-op/p
    ))]

    [test <- (parse-key-val "Test" (do
      (string/p "divisible by ")
      [divisible-by <- integer/p]
      space-consumer/p
      [if-true <- (parse-key-val "If true" (do (string/p "throw to monkey ") integer/p))]
      space-consumer/p
      [if-false <- (parse-key-val "If false" (do (string/p "throw to monkey ") integer/p))]
      (pure (list divisible-by if-true if-false))
      ))]

    (pure (list num (first starting-items) operation test))
  ))

(define monkey-stuff (string-split (file->string "./input.txt") "\n\n"))

(define (somefunc monkey) (parse-string monkey/p monkey))

(println (map somefunc monkey-stuff))

