
if [ ! -f /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    if_verbose echo "powerline could not be sourced missing binding"
    return
fi
POWERLINE_CONFIG_COMMAND=/usr/bin/powerline-config
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

source /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

