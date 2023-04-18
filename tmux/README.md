# Tmux configuration

* [https://github.com/tmux/tmux](tmux) is a very nice remote screen manager that provides permanent presence.
* place `dottmux.conf` at `~/.tmux.conf`.
* Run it with `tmux a || tmux` which says: "first try to attach to a currently running tmux, then if that fails start a new one".

## Some configuration issues:

* I don't use the built-in copy/paste due to some issues, with the following workaround:
  * You need to use X11 forwarding for copy/paste to work properly.
  * You need to install `xsel` [https://github.com/kfish/xsel] and add it to your path to use the copy-paste solution I use here. You also need to configure XQuartz to synchronise your X11 clipboard to the main OS one.
  * On BC4 there is no guarantee that you'll get put on the same machine. So I have the command `ssh -X -t bc4login3 'tmux a || tmux'` run by my local iTerm2 profile.

