#!/bin/bash
set -e
cd "$(dirname "$0")"

# Check prerequisites
if ! command -v node &>/dev/null; then
  echo "Error: Node.js is not installed."
  echo
  echo "Install it with Homebrew:"
  echo "  brew install node"
  echo
  echo "Or download from https://nodejs.org"
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  echo "Error: Python 3 is not installed."
  echo
  echo "Install it with Homebrew:"
  echo "  brew install python@3.11"
  exit 1
fi

if ! python3 -c "import distutils" 2>/dev/null; then
  echo "Error: Python is missing 'distutils' (required by node-gyp to compile native modules)."
  echo
  echo "Fix it by running:"
  echo "  python3 -m pip install --upgrade pip setuptools"
  echo
  echo "If that doesn't work, install Python 3.11 and point npm to it:"
  echo "  brew install python@3.11"
  echo "  npm config set python \$(brew --prefix python@3.11)/bin/python3.11"
  exit 1
fi

if ! command -v claude &>/dev/null; then
  echo "Error: Claude Code CLI is not installed."
  echo
  echo "Install it by running:"
  echo "  npm install -g @anthropic-ai/claude-code"
  exit 1
fi

if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

echo "Building Clui CC..."
if ! npx electron-vite build --mode production; then
  echo
  echo "Build failed. Try these steps:"
  echo "1) Ensure Xcode Command Line Tools are installed:"
  echo "     xcode-select --install"
  echo "2) Ensure Python setuptools is installed:"
  echo "     python3 -m pip install --upgrade pip setuptools"
  echo "3) Reinstall dependencies:"
  echo "     npm install"
  exit 1
fi

echo "Clui CC running. Alt+Space to toggle. Use ./stop.command or tray icon > Quit to close."
exec npx electron .
