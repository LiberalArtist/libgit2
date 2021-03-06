#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))

; Types

(define _git_blame_flag_t
  (_bitmask '(GIT_BLAME_NORMAL = 0
           GIT_BLAME_TRACK_COPIES_SAME_FILE = 1
           GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES = 2
           GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES = 4
           GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES = 8
           GIT_BLAME_FIRST_PARENT = 16)))

(define-cstruct _git_blame_opts
  ([version _uint]
  [flags _uint32]
  [min_match_chars _uint16]
  [newest_commit _oid]
  [oldest_commit _oid]
  [min_line _size]
  [max_line _size]))

(define GIT_BLAME_OPTS_VERSION 1)

(define-cstruct _git_blame_hunk
  ([lines_in_hunk _size]
   [final_commit_id _oid]
   [final_start_line_number _size]
   [final_signature _signature]
   [orig_commit_id _oid]
   [orig_path _string]
   [orig_sart_line_number _size]
   [orig_signature _signature]
   [boundary _ubyte]))

; Functions

(define-libgit2/dealloc git_blame_free
  (_fun _blame -> _void))

(define-libgit2/alloc git_blame_buffer
  (_fun _blame _blame _string _size -> _int)
  git_blame_free)

(define-libgit2/alloc git_blame_file
  (_fun _blame _repository _string _git_blame_opts-pointer/null -> _int)
  git_blame_free)

(define-libgit2 git_blame_get_hunk_byindex
  (_fun _blame _uint32 -> _git_blame_hunk-pointer/null))

(define-libgit2 git_blame_get_hunk_byline
  (_fun _blame _size -> _git_blame_hunk-pointer/null))

(define-libgit2 git_blame_get_hunk_count
  (_fun _blame -> _uint32))

(define-libgit2/check git_blame_init_options
  (_fun _git_blame_opts-pointer _uint -> _int))
