# Setup fzf
# ---------
if [[ ! "$PATH" == */home/italic/src/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/italic/src/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/italic/src/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/italic/src/fzf/shell/key-bindings.bash"
