#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function run_all_tests () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local ITEM= TITLE= RV=
  for ITEM in [a-z]*Test.lua; do
    TITLE="${ITEM%.lua}"
    echo "=== Test $TITLE: ==="
    lua "$ITEM"; RV=$?
    echo "=== Test $TITLE: rv=$RV ==="
    echo
    [ "$RV" == 0 ] || return $RV$(echo "E: test failed, rv=$?" >&2)
  done
}




run_all_tests "$@"; exit $?
