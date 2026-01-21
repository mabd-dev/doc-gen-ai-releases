#!/bin/sh
# Install script for doc-gen-ai
# Usage: curl -fsSL https://raw.githubusercontent.com/mabd-dev/doc-gen-ai-releases/main/install.sh | sh

set -e

REPO="mabd-dev/doc-gen-ai-releases"
BINARY_NAME="doc-gen-ai-releases"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { printf "${GREEN}▸${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}▸${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "darwin" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) error "Unsupported operating system: $(uname -s)" ;;
    esac
}

# Detect architecture
detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64) echo "amd64" ;;
        arm64|aarch64) echo "arm64" ;;
        *) error "Unsupported architecture: $(uname -m)" ;;
    esac
}

# Get latest version from GitHub
get_latest_version() {
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | \
        grep '"tag_name"' | \
        sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
}

# Main installation
main() {
    OS=$(detect_os)
    ARCH=$(detect_arch)
    
    info "Detected: ${OS}/${ARCH}"
    
    # Get version (use VERSION env var or fetch latest)
    VERSION="${VERSION:-$(get_latest_version)}"
    if [ -z "$VERSION" ]; then
        error "Could not determine latest version"
    fi
    
    # Strip 'v' prefix for filename
    VERSION_NUM="${VERSION#v}"
    
    info "Installing ${BINARY_NAME} ${VERSION}..."
    
    # Determine archive extension
    if [ "$OS" = "windows" ]; then
        EXT="zip"
    else
        EXT="tar.gz"
    fi
    
    # Build download URL
    FILENAME="${BINARY_NAME}_${VERSION_NUM}_${OS}_${ARCH}.${EXT}"
    URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"
    
    # Create temp directory
    TMP_DIR=$(mktemp -d)
    trap "rm -rf $TMP_DIR" EXIT
    
    info "Downloading from ${URL}..."
    
    # Download
    if ! curl -fsSL "$URL" -o "$TMP_DIR/archive"; then
        error "Failed to download ${FILENAME}"
    fi
    
    # Extract
    info "Extracting..."
    cd "$TMP_DIR"
    if [ "$EXT" = "zip" ]; then
        unzip -q archive
    else
        tar -xzf archive
    fi
    
    # Find binary
    if [ "$OS" = "windows" ]; then
        BINARY="${BINARY_NAME}.exe"
    else
        BINARY="${BINARY_NAME}"
    fi
    
    if [ ! -f "$BINARY" ]; then
        error "Binary not found in archive"
    fi
    
    # Install
    mkdir -p "$INSTALL_DIR"
    mv "$BINARY" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/$BINARY"
    
    info "Installed to ${INSTALL_DIR}/${BINARY}"
    
    # Verify
    if command -v "$INSTALL_DIR/$BINARY" > /dev/null 2>&1; then
        info "Installation successful!"
        "$INSTALL_DIR/$BINARY" --version 2>/dev/null || true
    else
        warn "Installed, but ${INSTALL_DIR} may not be in your PATH"
        warn "Add this to your shell config:"
        echo ""
        echo "    export PATH=\"\$PATH:${INSTALL_DIR}\""
        echo ""
    fi
}

main "$@"
