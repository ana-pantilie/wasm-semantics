(module
  (memory 1)
  (data (i32.const 0) "~!@#$%\u{1}\u{11}\u{334}\u{EDFF}\u{BBBBB}\u{10EFEF}")
  (func (export "load8_u") (param $i i32) (result i64)
    (i64.load8_u offset=0 (local.get $i))
  )
  (func (export "load16_u") (param $i i32) (result i64)
    (i64.load16_u offset=0 (local.get $i))
  )
  (func (export "load32_u") (param $i i32) (result i64)
    (i64.load32_u offset=0 (local.get $i))
  )
)

(assert_return (invoke "load8_u" (i32.const 0)) (i64.const 126))
(assert_return (invoke "load8_u" (i32.const 3)) (i64.const 35))
(assert_return (invoke "load8_u" (i32.const 6)) (i64.const 1))
(assert_return (invoke "load8_u" (i32.const 9)) (i64.const 180))
(assert_return (invoke "load8_u" (i32.const 11)) (i64.const 183))
(assert_return (invoke "load8_u" (i32.const 14)) (i64.const 187))
(assert_return (invoke "load8_u" (i32.const 15)) (i64.const 174))

(assert_return (invoke "load16_u" (i32.const 0)) (i64.const 8574))
(assert_return (invoke "load16_u" (i32.const 1)) (i64.const 16417))
(assert_return (invoke "load16_u" (i32.const 2)) (i64.const 9024))
(assert_return (invoke "load16_u" (i32.const 4)) (i64.const 9508))
(assert_return (invoke "load16_u" (i32.const 12)) (i64.const 62143))
(assert_return (invoke "load16_u" (i32.const 13)) (i64.const 48114))
(assert_return (invoke "load16_u" (i32.const 16)) (i64.const 62651))

(assert_return (invoke "load32_u" (i32.const 2)) (i64.const 623125312))
(assert_return (invoke "load32_u" (i32.const 3)) (i64.const 19211299))
(assert_return (invoke "load32_u" (i32.const 6)) (i64.const 3033272577))
(assert_return (invoke "load32_u" (i32.const 7)) (i64.const 4004826129))
(assert_return (invoke "load32_u" (i32.const 11)) (i64.const 3153248183))
(assert_return (invoke "load32_u" (i32.const 16)) (i64.const 3213817019))
(assert_return (invoke "load32_u" (i32.const 19)) (i64.const 44991))

#clearConfig
