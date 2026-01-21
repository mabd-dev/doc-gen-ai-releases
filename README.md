# doc-gen-ai

AI-powered documentation generator for Kotlin/Android development using local LLMs.

## Installation

### Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/mabd-dev/doc-gen-ai-releases/main/install.sh | sh
```

This installs to `~/.local/bin` by default. Make sure it's in your PATH:

```bash
export PATH="$PATH:$HOME/.local/bin"
```

### Custom Install Location

```bash
INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/mabd-dev/doc-gen-ai-releases/main/install.sh | sh
```

### Specific Version

```bash
VERSION=v0.2.0 curl -fsSL https://raw.githubusercontent.com/mabd-dev/doc-gen-ai-releases/main/install.sh | sh
```

### Manual Download

Download the appropriate archive from the [releases page](https://github.com/mabd-dev/doc-gen-ai-releases/releases):

| OS | Architecture | File |
|----|--------------|------|
| Linux | x86_64 | `doc-gen-ai_*_linux_amd64.tar.gz` |
| Linux | ARM64 | `doc-gen-ai_*_linux_arm64.tar.gz` |
| macOS | Intel | `doc-gen-ai_*_darwin_amd64.tar.gz` |
| macOS | Apple Silicon | `doc-gen-ai_*_darwin_arm64.tar.gz` |
| Windows | x86_64 | `doc-gen-ai_*_windows_amd64.zip` |
| Windows | ARM64 | `doc-gen-ai_*_windows_arm64.zip` |

### Verify Installation

```bash
doc-gen-ai --version
```

## Requirements

- [Ollama](https://ollama.ai) running locally (default), OR
- OpenAI-compatible API endpoint (Groq, etc.)

## Usage

```bash
# Generate KDoc for a Kotlin function (reads from stdin)
echo 'fun add(a: Int, b: Int): Int = a + b' | doc-gen-ai

# Use a specific model
doc-gen-ai < function.kt

# Use remote provider (e.g., Groq)
doc-gen-ai --base-url https://api.groq.com/openai/v1 --base-model llama-3.3-70b-versatile < function.kt
```

## Neovim Integration

See [doc-gen-ai.nvim](https://github.com/mabd-dev/doc-gen-ai.nvim) for seamless editor integration.

## Checksums

Each release includes a `checksums.txt` file with SHA256 hashes for verification:

```bash
# Download and verify
curl -fsSLO https://github.com/mabd-dev/doc-gen-ai-releases/releases/latest/download/checksums.txt
sha256sum -c checksums.txt --ignore-missing
```

## License

Proprietary. See LICENSE for terms.
