# .bash_profile

# User specific environment and startup programs ===================================================

if [ -f "${HOME}/.profile" ] ; then
    source "${HOME}/.profile"
fi

# Export ===========================================================================================

# Get the aliases and functions if interactive shell
if [[ $- == *i* ]] && [ -f "${HOME}/.bashrc" ]; then
        source ~/.bashrc
fi
