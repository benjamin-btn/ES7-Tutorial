#!/bin/bash

function tmux_key_download() {
    wget http://ec2-52-221-155-168.ap-southeast-1.compute.amazonaws.com/ES-Key-7th.tar.gz
    tar xvfz ES-Key-7th.tar.gz
}

function my_tmux() {
    tmux new-session -d -s mytmux-$(hexdump -n 2 -v -e '/1 "%02X"' /dev/urandom)
    
    HOSTS=$@
    KEY="ES-Key-7th.pem"
    
    for i in $HOSTS
    do
            tmux split-window -h "ssh -i $KEY -l ec2-user -o StrictHostKeyChecking=no $i"
            tmux select-layout tiled > /dev/null
    done
    
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

if [ -z $1 ]; then
        echo "##################### Menu ##############"
        echo " $ ./tmux [Command]"
        echo "#####################%%%%%%##############"
        echo "         1 : download a pem key"
        echo "         2 : connect multi ssh sessions"
        echo "#########################################";
        exit 1;
fi

case "$1" in
        "1" ) tmux_key_download;;
        "2" ) my_tmux $@;;
        *) echo "Incorrect Command" ;;
esac
