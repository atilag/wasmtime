;;! target = "x86_64"
;;! test = "winch"

(module
  (func $dummy)
  (func (export "as-if-condition") (param i32) (result i32)
    (if (result i32)
      (if (result i32) (local.get 0)
        (then (i32.const 1)) (else (i32.const 0))
      )
      (then (call $dummy) (i32.const 2))
      (else (call $dummy) (i32.const 3))
    )
  )
)
;; wasm[0]::function[0]::dummy:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    8(%rdi), %r11
;;       movq    (%r11), %r11
;;       addq    $0x10, %r11
;;       cmpq    %rsp, %r11
;;       ja      0x31
;;   1b: movq    %rdi, %r14
;;       subq    $0x10, %rsp
;;       movq    %rdi, 8(%rsp)
;;       movq    %rsi, (%rsp)
;;       addq    $0x10, %rsp
;;       popq    %rbp
;;       retq
;;   31: ud2
;;
;; wasm[0]::function[1]:
;;       pushq   %rbp
;;       movq    %rsp, %rbp
;;       movq    8(%rdi), %r11
;;       movq    (%r11), %r11
;;       addq    $0x20, %r11
;;       cmpq    %rsp, %r11
;;       ja      0xc8
;;   5b: movq    %rdi, %r14
;;       subq    $0x20, %rsp
;;       movq    %rdi, 0x18(%rsp)
;;       movq    %rsi, 0x10(%rsp)
;;       movl    %edx, 0xc(%rsp)
;;       movl    0xc(%rsp), %eax
;;       testl   %eax, %eax
;;       je      0x86
;;   7c: movl    $1, %eax
;;       jmp     0x8b
;;   86: movl    $0, %eax
;;       testl   %eax, %eax
;;       je      0xad
;;   93: movq    %r14, %rdi
;;       movq    %r14, %rsi
;;       callq   0
;;       movq    0x18(%rsp), %r14
;;       movl    $2, %eax
;;       jmp     0xc2
;;   ad: movq    %r14, %rdi
;;       movq    %r14, %rsi
;;       callq   0
;;       movq    0x18(%rsp), %r14
;;       movl    $3, %eax
;;       addq    $0x20, %rsp
;;       popq    %rbp
;;       retq
;;   c8: ud2
