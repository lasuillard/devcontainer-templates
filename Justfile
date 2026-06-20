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
ci: (format "yes") lint (test "nix")

# Autoformat code
[arg("check", long="check", value="yes")]
format check="no":
    git ls-files --cached --others --exclude-standard '*.sh' \
        | xargs shfmt {{ if check == "yes" { "--list" } else { "--list --write" } }}

alias fmt := format

# Run all linters
lint:
    git ls-files --cached --others --exclude-standard '*.sh' \
        | tee /dev/tty \
        | xargs shellcheck

# Test a template
test template:
    ./scripts/test-template.sh '{{ template }}'

# =============================================================================
# Utility
# =============================================================================

# Remove temporary files
clean:
    find . -path '*.log*' -delete
