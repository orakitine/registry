set dotenv-load := true

# List available commands
default:
    @just --list

# Install the registry (first-time setup)
install:
    claude --dangerously-skip-permissions --model opus "/registry install"

# Add a new skill, agent, prompt, output style, or config to the catalog
add prompt:
    claude --dangerously-skip-permissions --model opus "/registry add {{prompt}}"

# Pull a skill from the catalog (install or refresh)
use name:
    claude --dangerously-skip-permissions --model opus "/registry use {{name}}"

# Push local changes back to the source
push name:
    claude --dangerously-skip-permissions --model opus "/registry push {{name}}"

# Remove an entry from the catalog (local deletion optional)
remove name:
    claude --dangerously-skip-permissions --model opus "/registry remove {{name}}"

# Sync all installed items (re-pull from source)
sync:
    claude --dangerously-skip-permissions --model opus "/registry sync"

# List all entries in the catalog with install status
list:
    claude --dangerously-skip-permissions --model opus "/registry list"

# Search the catalog by keyword
search keyword:
    claude --dangerously-skip-permissions --model opus "/registry search {{keyword}}"
