#!/usr/bin/env bash

export SESSION='{{cookiecutter.repo_name}}'
export WEB_URL='{{cookiecutter.web_url}}'


# Check if the session already exists
tmux has-session -t $SESSION 2>/dev/null

# shellcheck disable=SC2181
if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION -n 'backend'

    # Set up the backend window
    tmux send-keys -t $SESSION:backend "cd backend" C-m
    tmux select-window -t $SESSION:backend
    tmux send-keys -t $SESSION:backend "just dev" C-m


    tmux new-window -t $SESSION:1 -n 'web'
    # Set up the web window
    tmux send-keys -t $SESSION:web "cd web" C-m
    tmux send-keys -t $SESSION:web "just dev" C-m

    tmux new-window -t $SESSION:2 -n 'database'
    tmux send-keys -t $SESSION:database 'cd backend/db' C-m
    tmux send-keys -t $SESSION:database "just dev" C-m

    sleep 5s
    xdg-open $WEB_URL
fi

tmux attach-session -t $SESSION
