_default:
    just --list

# Install deps and tools
install:

# Update deps and tools
update:
    pre-commit autoupdate

alias up := update

# =============================================================================
# Development
# =============================================================================

# Run all checks (lint and test for A SINGLE TEMPLATE as a smoke test)
ci: lint (test "nix")

# Autoformat code
format:
    shfmt --write --list .

alias fmt := format

# Run all linters
lint:
    git ls-files --cached --others --exclude-standard '*.sh' | xargs shellcheck

# Test a template
test template:
    ./scripts/test-template.sh '{{template}}'

# =============================================================================
# Utility
# =============================================================================

# Remove temporary files
clean:
    find . -path '*.log*' -delete
