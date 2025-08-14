;; Store contract owner
(define-data-var contract-owner principal tx-sender)

;; Store certificate counter
(define-data-var cert-counter uint u0)

(define-map certifiers
  { certifier: principal }
  { approved: bool })

(define-map skills
  { cert-id: uint }
  {
    recipient: principal,
    skill-name: (string-ascii 50),
    level: (string-ascii 20),
    issued-by: principal,
    revoked: bool
  })
;; Contract owner approves a certifier
(define-public (approve-certifier (certifier principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
    (map-set certifiers { certifier: certifier } { approved: true })
    (ok "Certifier approved")
  ))

;; Certifier issues a skill to a user
(define-public (issue-skill (recipient principal) (skill-name (string-ascii 50)) (level (string-ascii 20)))
  (let ((is-approved (default-to false (get approved (map-get? certifiers { certifier: tx-sender })))))
    (asserts! is-approved (err u101))
    (let ((cert-id (var-get cert-counter)))
      (map-set skills { cert-id: cert-id }
        {
          recipient: recipient,
          skill-name: skill-name,
          level: level,
          issued-by: tx-sender,
          revoked: false
        })
      (var-set cert-counter (+ cert-id u1))
      (ok { certificate-id: cert-id })
    )))

;; Certifier revokes a skill certification
(define-public (revoke-skill (cert-id uint))
  (let ((cert (unwrap! (map-get? skills { cert-id: cert-id }) (err u102))))
    (asserts! (is-eq tx-sender (get issued-by cert)) (err u103))
    (map-set skills { cert-id: cert-id }
      (merge cert { revoked: true }))
    (ok "Skill certification revoked")
  ))

;; Read-only function to verify skill details
(define-read-only (verify-skill (cert-id uint))
  (ok (map-get? skills { cert-id: cert-id })))
