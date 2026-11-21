#!/bin/bash
# Entry point that dev containers / Codespaces / Cursor run automatically when they install dotfiles.
# Everything lives in setup_machine.sh, which is non-interactive and safe to re-run.
exec bash "$(dirname "${BASH_SOURCE[0]}")/setup_machine.sh" "$@"
