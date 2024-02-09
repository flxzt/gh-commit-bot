#!/usr/bin/env bash
set -euxo pipefail

repo_dir=$(realpath "$0" | xargs dirname)
app_name="app.py"
unit_name="gh-commit-bot"
systemd_user_unit_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

mkdir -p "${systemd_user_unit_dir}"

# Write systemd service and timer units
cat << EOF > "${systemd_user_unit_dir}/${unit_name}.service"
[Unit]
Description="gh-commit-bot script"

[Service]
WorkingDirectory=${repo_dir}
ExecStart=$(command -v python3) ${repo_dir}/${app_name}

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > "${systemd_user_unit_dir}/${unit_name}.timer"
[Unit]
Description=Run gh-commit-bot.service periodically

[Timer]
OnCalendar=*-*-* 06:00:00
AccuracySec=12h
RandomizedDelaySec=12h
Persistent=true
Unit=${unit_name}.service

[Install]
WantedBy=timers.target
EOF

git config --local commit.gpgsign false
git branch -D bot || true
git push -d origin bot || true
git checkout -b bot
git push -u origin bot

systemctl --user daemon-reload
systemctl --user enable --now ${unit_name}.timer
systemctl --user start ${unit_name}.service
