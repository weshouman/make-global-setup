#!/bin/bash

install_tool() {
  local mode=""
  local TOOL_NAME=""
  local TOOL_VERSION=""
  local TOOL_TMP=""
  local TOOL_URL=""
  local TOOL_BIN=""

  display_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --mode MODE        Installation mode: 'direct' or 'archived'."
    echo "  --name NAME        Name of the tool."
    echo "  --version VERSION  Version of the tool."
    echo "  --tmp TMP          Temporary file or archive."
    echo "  --url URL          Download URL."
    echo "  --bin BIN          Installation directory."
    echo "  -h, --help         Display this help and exit."
  }

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --mode) mode="$2"; shift ;;
      --name) TOOL_NAME="$2"; shift ;;
      --version) TOOL_VERSION="$2"; shift ;;
      --tmp) TOOL_TMP="$2"; shift ;;
      --url) TOOL_URL="$2"; shift ;;
      --bin) TOOL_BIN="$2"; shift ;;
      -h|--help) display_help; return ;;
      *) echo "Unknown option: $1"; display_help; return 1 ;;
    esac
    shift
  done

  if [[ "$mode" == "direct" ]]; then
    echo "Attempting to download ${TOOL_NAME} version ${TOOL_VERSION}..."
    status=$(curl -L -w "%{http_code}" -o "${TOOL_TMP}" "${TOOL_URL}" -s -S)
    if [ "$status" -ne 200 ]; then
      echo -e "\033[1;31mError downloading ${TOOL_NAME}: Version ${TOOL_VERSION} not found or download failed.\033[0m"
      echo "Status code: $status"
      echo "URL: ${TOOL_URL}"
      rm "${TOOL_TMP}"
      return 1
    else
      echo "Download succeeded."
      chmod +x "${TOOL_TMP}"
      sudo mv "${TOOL_TMP}" "${TOOL_BIN}"
      echo -e "\033[1;32m${TOOL_NAME} installed successfully to ${TOOL_BIN}.\033[0m"
    fi
  elif [[ "$mode" == "archived" ]]; then
    local TOOL_ARCHIVE="${TOOL_TMP}.tar.gz"
    echo "Attempting to download and install ${TOOL_NAME} version ${TOOL_VERSION}..."
    status=$(curl -L -w "%{http_code}" -o "${TOOL_ARCHIVE}" "${TOOL_URL}" -s -S)
    if [ "$status" -ne 200 ]; then
      echo -e "\033[1;31mError downloading ${TOOL_NAME}: Version ${TOOL_VERSION} not found or download failed.\033[0m"
      echo "Status code: $status"
      echo "URL: ${TOOL_URL}"
      rm "${TOOL_ARCHIVE}"
      return 1
    else
      echo "Download succeeded, extracting..."
      # Create a specific temporary directory for extraction
      EXTRACT_DIR=$(mktemp -d)
      tar -xzf "${TOOL_ARCHIVE}" -C "${EXTRACT_DIR}"

      # Find the binary in the extracted contents
      BINARY_PATH=$(find "${EXTRACT_DIR}" -type f -name "${TOOL_NAME}" | head -n 1)

      if [[ -z "$BINARY_PATH" ]]; then
        echo -e "\033[1;31m${TOOL_NAME} binary not found in the archive.\033[0m"
        # Optionally show the structure if tree is installed
        echo "Archive structure (if available):"
        tree "${EXTRACT_DIR}" || echo "tree command not available."
        # Ensure to remove the temporary directory
        rm -rf "${EXTRACT_DIR}"
        return 1
      else
        echo "Binary found at ${BINARY_PATH}, proceeding with installation."
        chmod +x "${BINARY_PATH}"
        sudo mv "${BINARY_PATH}" "${TOOL_BIN}"
        echo -e "\033[1;32m${TOOL_NAME} installed successfully to ${TOOL_BIN}.\033[0m"
        # Cleanup
        rm -rf "${EXTRACT_DIR}"
      fi
    fi
  else
    echo "Invalid mode specified. Use 'direct' or 'archived'."
    display_help
    return 1
  fi
}

install_tool $@
