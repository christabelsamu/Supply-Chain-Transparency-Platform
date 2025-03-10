;; Consumer Verification Contract

(define-map verifications
  { product-id: uint }
  {
    hash: (buff 32),
    issuer: principal
  }
)

(define-data-var contract-owner principal tx-sender)

(define-public (add-verification (product-id uint) (hash (buff 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u403))
    (ok (map-set verifications { product-id: product-id } { hash: hash, issuer: tx-sender }))
  )
)

(define-read-only (verify-product (product-id uint) (hash (buff 32)))
  (match (map-get? verifications { product-id: product-id })
    verification (is-eq (get hash verification) hash)
    false
  )
)

