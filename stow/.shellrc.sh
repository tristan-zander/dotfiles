# Shell configurations that are sourced by all shells.

alias=(
    "ll=ls -l"
    "la=ls -a"
    "l=ls -alh"
    "g=git"
    "gst=git status"
    "gch=git checkout"
    "gcm=git commit"
    "gps=git push origin"
    "gpl=git pull origin"
    "gb=git branch --show-current"
)

# Setup aliases
for a in "${alias[@]}"; do
    alias "$a"
done

export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL="http://localhost:11434"
