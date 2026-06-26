# macos always-on jupyter lab

# install uv, mkdir ~/jpuyter, uv tool install jupyterlab, uv tool update-shell, which jupyter-lab

###############

# to make password hash 
#   uv run --with jupyterlab python3 -c "from jupyter_server.auth import passwd; print(passwd('XXXXXXXX'))"

cat > /Users/nikita/Library/Jupyter/launch-jupyter-lab.sh << EOF
!/usr/bin/env bash
set -euo pipefail

cd "/Users/nikita/jupyter"

exec "/Users/nikita/.local/bin/jupyter-lab"\
    --no-browser --ip=127.0.0.1 --port=8888 \
    --ServerApp.open_browser=False \
    --IdentityProvider.token='' \
    --PasswordIdentityProvider.password_required=True \
    --PasswordIdentityProvider.hashed_password='...'
EOF

# chmod +x /Users/nikita/Library/Jupyter/launch-jupyter-lab.sh 

###############

cat > ~/Library/LaunchAgents/com.nikita.jupyter-lab.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.nikita.jupyter-lab</string>

  <key>ProgramArguments</key>
  <array>
    <string>/Users/nikita/Library/Jupyter/launch-jupyter-lab.sh</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <dict>
    <key>SuccessfulExit</key>
    <false/>
  </dict>

  <key>StandardOutPath</key>
  <string>/Users/nikita/Library/Logs/Jupyter/jupyter-lab.out.log</string>

  <key>StandardErrorPath</key>
  <string>/Users/nikita/Library/Logs/Jupyter/jupyter-lab.err.log</string>

  <key>WorkingDirectory</key>
  <string>/Users/nikita/wrk</string>
</dict>
</plist>
EOF

###############

launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.nikita.jupyter-lab.plist
