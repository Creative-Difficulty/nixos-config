hm_session_vars="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
[ -f "$hm_session_vars" ] && . "$hm_session_vars"
unset hm_session_vars

# bash login shells (SSH, TTY) don't read .bashrc on their own
if [ -n "$BASH_VERSION" ]; then
  case $- in *i*) . "$HOME/.bashrc" ;; esac
fi
