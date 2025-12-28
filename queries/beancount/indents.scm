; Indentation queries for Beancount
; Following nvim-treesitter pattern from Python indents.scm

; ============================================================================
; INDENT BEGIN - Start indentation blocks
; ============================================================================

; Transaction entries should indent their content (postings, metadata)
[
  (transaction)
  (open)
  (close)
  (balance)
  (commodity)
  (pad)
  (note)
  (event)
  (price)
  (query)
  (document)
  (custom)
] @indent.begin

; ============================================================================
; INDENT IMMEDIATE - Indent immediately after these patterns
; ============================================================================

; Transaction headers immediately indent the next line
((transaction) @indent.begin
  (#set! indent.immediate 1))

; All entry types immediately indent their content
((open) @indent.begin
  (#set! indent.immediate 1))

((close) @indent.begin
  (#set! indent.immediate 1))

((balance) @indent.begin
  (#set! indent.immediate 1))

((commodity) @indent.begin
  (#set! indent.immediate 1))

((pad) @indent.begin
  (#set! indent.immediate 1))

((note) @indent.begin
  (#set! indent.immediate 1))

((event) @indent.begin
  (#set! indent.immediate 1))

((price) @indent.begin
  (#set! indent.immediate 1))

((query) @indent.begin
  (#set! indent.immediate 1))

((document) @indent.begin
  (#set! indent.immediate 1))

((custom) @indent.begin
  (#set! indent.immediate 1))

; ============================================================================
; INDENT BRANCH - Handle control flow and block endings
; ============================================================================

; All entry types can branch (end their indentation blocks)
[
  (transaction)
  (open)
  (close)
  (balance)
  (commodity)
  (pad)
  (note)
  (event)
  (price)
  (query)
  (document)
  (custom)
  (plugin)
  (option)
  (include)
  (pushtag)
  (poptag)
  (pushmeta)
  (popmeta)
] @indent.branch

; Section headers also branch
(headline) @indent.branch

; ============================================================================
; INDENT AUTO - Auto-handle indentation for certain elements
; ============================================================================

; Comments should follow context indentation
(comment) @indent.auto

; ============================================================================
; INDENT ALIGN - Handle alignment for cost specifications and parentheses
; ============================================================================

; Cost specifications with braces should align
((cost_spec) @indent.align
  (#set! indent.open_delimiter "{")
  (#set! indent.close_delimiter "}"))

; Price annotations with parentheses should align  
((price_annotation) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))