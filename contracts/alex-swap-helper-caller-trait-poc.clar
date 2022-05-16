;; alex-swap-helper-caller-trait-poc
;; Exchange STX by xBTC

(define-constant contract-owner tx-sender)

(define-constant err-not-owner (err 101))

(define-trait ft-trait
	(
		;; Transfer from the caller to a new principal
		(transfer (uint principal principal (optional (buff 34))) (response bool uint))

		;; the human readable name of the token
		(get-name () (response (string-ascii 32) uint))

		;; the ticker symbol, or empty if none
		(get-symbol () (response (string-ascii 32) uint))

		;; the number of decimals used, e.g. 6 would mean 1_000_000 represents 1 token
		(get-decimals () (response uint uint))

		;; the balance of the passed principal
		(get-balance (principal) (response uint uint))

		;; the current total supply (which does not need to be a constant)
		(get-total-supply () (response uint uint))

		;; an optional URI that represents metadata of this token
		(get-token-uri () (response (optional (string-utf8 256)) uint))
	)
)

(define-public (simple-swap-with-principals (token-x-trait <ft-trait>) (token-y-trait <ft-trait>) (amount uint) (min-dy (optional uint))) 
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (try! (contract-call? 'SP3K8BC0PPEVCV7NZ6QSRWPQ2JE9E5B6N3PA0KBR9.swap-helper-v1-01
                swap-helper
                token-x-trait
                token-y-trait
                amount
                min-dy))
    )
)
