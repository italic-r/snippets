# .profile

export QT_QPA_PLATFORMTHEME="qt6ct"
export EDITOR=vim
export GTK2_RC_FILES="${HOME}/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=firefox

# Vars =============================================================================================
PATH="${HOME}/bin:${PATH}"

LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
LD_LIBRARY_PATH="/usr/lib:${LD_LIBRARY_PATH}"
LD_LIBRARY_PATH="/usr/lib64:${LD_LIBRARY_PATH}"

# Add to LD_LIBRARY_PATH if libnio.so not found, or `unset LD_LIBRARY_PATH`
LD_LIBRARY_PATH="/usr/lib/jvm/default/lib/server:${LD_LIBRARY_PATH}"

# Ruby
#export GEM_HOME=${HOME}/.gem
#PATH=${HOME}/.gem/bin:${HOME}:${PATH}

# Rust
[ -f "${HOME}/.cargo/env" ] && source "${HOME}/.cargo/env"  # includes path to bin
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Go
PATH="${HOME}/go/bin:${PATH}"

# Export ===========================================================================================

# export PYTHONPATH
export PATH
export LD_LIBRARY_PATH

# export TF_FORCE_GPU_ALLOW_GROWTH="true"
# export CUDA_VISIBLE_DEVICES="0"

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export SSH_ASKPASS=/usr/bin/qt4-ssh-askpass

if [ -n "$BASH"  ] && [ -r "${HOME}/.bashrc"  ]; then
        source "${HOME}/.bashrc"
fi
