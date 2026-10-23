# https://nix-community.github.io/home-manager/faq/session-variables.html#why-are-the-session-variables-not-set
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# nix develop sources this before exporting its env, so the tag is expanded at prompt time
if [[ -n $PS1 && $PS1 != *IN_NIX_SHELL* ]]; then
  nix_tag='${IN_NIX_SHELL:+(nix:${name%-env}) }'
  if [[ $PS1 == '\n'* ]]; then PS1="\n$nix_tag${PS1:2}"; else PS1="$nix_tag$PS1"; fi
  unset nix_tag
fi
