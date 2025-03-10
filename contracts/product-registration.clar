;; Product Registration Contract

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_NOT_FOUND (err u101))

;; Data structures
(define-map products
  { id: uint }
  {
    name: (string-utf8 100),
    owner: principal
  }
)

;; Public functions
(define-public (register-product (id uint) (name (string-utf8 100)))
  (ok (map-set products { id: id } { name: name, owner: tx-sender }))
)

(define-public (transfer-product (id uint) (new-owner principal))
  (let ((product (unwrap! (map-get? products { id: id }) (err u404))))
    (asserts! (is-eq tx-sender (get owner product)) (err u403))
    (ok (map-set products { id: id } (merge product { owner: new-owner })))
  )
)

;; Read-only functions
(define-read-only (get-product (id uint))
  (map-get? products { id: id })
)

