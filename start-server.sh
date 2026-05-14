#!/bin/bash

LOG_FILE="server.log"
PORT=8080
DOC_ROOT="."
SERVER_PID=""

check_php() {
  if ! command -v php >/dev/null 2>&1; then
    echo "[ERROR] PHP CLI is not installed."
    exit 1
  fi
  echo "[OK] $(php -v | head -n 1)"
}

start_server() {
  : > "$LOG_FILE"
  echo "[INFO] Starting PHP server at http://127.0.0.1:$PORT"
  php -S 127.0.0.1:$PORT -t "$DOC_ROOT" > "$LOG_FILE" 2>&1 &
  SERVER_PID=$!
  sleep 2
  echo "[INFO] Server started with PID $SERVER_PID"
}

live_log() {
  echo "[INFO] Live log started. Press Ctrl+C to stop viewing."
  tail -n 20 -f "$LOG_FILE"
}

cleanup() {
  if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
    kill "$SERVER_PID"
    echo
    echo "[INFO] Server stopped."
  fi
}

trap cleanup EXIT

check_php
start_server
live_log 

