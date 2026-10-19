# Claude remarks

Notes from sessions with Claude Code about decisions that aren't obvious from the config itself.

## Hyprland: hardware cursors (`WLR_NO_HARDWARE_CURSORS`)

*2026-10-19*

- The `WLR_NO_HARDWARE_CURSORS` env var (formerly the `hyprland.wlr_no_hardware_cursors` option in `modules/hyprland.nix`) was removed. Hyprland dropped wlroots for its own backend, aquamarine, in v0.42.0 and no longer reads any `WLR_*` variable.
  - Verified locally: the string `WLR_` appears 0 times in the installed Hyprland 0.56.2 binary and in libaquamarine 0.15.0. Supported vars such as `HYPRLAND_NO_RT` and `AQ_NO_MODIFIERS` are present.
- The replacement is the Hyprland option `cursor:no_hardware_cursors`:
  - `0`: use hardware cursors if possible
  - `1`: never use hardware cursors (what the old env var meant)
  - `2`: auto, which disables them when tearing (**default**)
- **It is intentionally not set** in `dotfiles/.config/hypr/hyprland.lua`. The old env var was already ignored, so the system has been running on the default `2` all along, and the cursor works fine on nouveau. Setting `1` would change behavior: software cursor, slightly more overhead and possible lag.
- **When to set it:** if the cursor becomes invisible or glitchy, e.g. after switching to the proprietary NVIDIA driver, set `no_hardware_cursors = 1` in the `cursor` section of `hyprland.lua`.

Sources:
- [Hyprland v0.42.0 release notes](https://github.com/hyprwm/Hyprland/releases/tag/v0.42.0): "Wlroots has been dropped, and is no longer a dependency of Hyprland."
- [Hyprland Wiki: Variables](https://wiki.hypr.land/Configuring/Basics/Variables/), section `cursor`, `no_hardware_cursors`
- [Hyprland Wiki: Environment variables](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/) (only `HYPR*` / `AQ_*` are listed)
