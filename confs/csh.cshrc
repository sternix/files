# $FreeBSD: releng/11.1/etc/csh.cshrc 50472 1999-08-27 23:37:10Z peter $
#
# System-wide .cshrc file for csh(1).

set path = (/sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin $HOME/bin)

setenv PGSQL_HOME /opt/pgsql/10_b4
setenv EDITOR vim
setenv INPUTRC /usr/local/etc/inputrc
setenv GOROOT /opt/go/1_9/go
setenv PATH ${PATH}:${GOROOT}/bin
setenv PATH ${PATH}:${PGSQL_HOME}/bin
setenv PKG_CONFIG_PATH /opt/efl/1_20_2/libdata/pkgconfig

setenv GODEBUG cgocheck=2
setenv CLICOLOR			   # colorize shell

bindkey "\e[1~" beginning-of-line  # Home
bindkey "\e[7~" beginning-of-line  # Home rxvt
bindkey "\e[2~" overwrite-mode     # Ins
bindkey "\e[3~" delete-char        # Delete
bindkey "\e[4~" end-of-line        # End
bindkey "\e[8~" end-of-line        # End rxvt
bindkey "^[[1;5D"   backward-word  # ctrl+left
bindkey "^[[1;5C"   forward-word   # ctrl+right
bindkey '^R'	i-search-back	   # Ctrl + R backward search

# add completion support
source /usr/share/examples/tcsh/complete.tcsh
