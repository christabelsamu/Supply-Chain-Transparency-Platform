;; Quality Assurance Contract

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_NOT_FOUND (err u301))

;; Data structures
(define-map inspectors
  { inspector-id: principal }
  {
    name: (string-utf8 100),
    certification-level: uint
  }
)

(define-map quality-checks
  { id: uint }
  {
    product-id: uint,
    inspector: principal,
    passed: bool
  }
)

;; Public functions
(define-public (register-inspector (name (string-utf8 100)) (certification-level uint))
  (begin
    (map-set inspectors
      { inspector-id: tx-sender }
      {
        name: name,
        certification-level: certification-level
      }
    )
    (ok true)
  )
)

(define-public (perform-check (id uint) (product-id uint) (passed bool))
  (ok (map-set quality-checks { id: id }
      { product-id: product-id, inspector: tx-sender, passed: passed }))
)

(define-public (finalize-check (check-id uint) (passed bool))
  (let ((check (unwrap! (map-get? quality-checks { id: check-id }) ERR_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get inspector check)) ERR_UNAUTHORIZED)
    (map-set quality-checks
      { id: check-id }
      (merge check {
        passed: passed
      })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-inspector (inspector-id principal))
  (map-get? inspectors { inspector-id: inspector-id })
)

(define-read-only (get-check (id uint))
  (map-get? quality-checks { id: id })
)

