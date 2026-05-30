# macos always-on jupyter lab

# install uv, mkdir ~/wrk, cd ~/wrk, uv venv, activate, uv pip install jupyterlab

###############

cat > /Users/nikita/Library/Jupyter/launch-jupyter-lab.sh << EOF
#!/usr/bin/env bash
set -euo pipefail

export HOME="/Users/nikita"

NOTEBOOK_DIR="/Users/nikita/wrk"
JUPYTER_LAB="/Users/nikita/wrk/.venv/bin/jupyter-lab"

cd "$NOTEBOOK_DIR"

exec "$JUPYTER_LAB" \
  --no-browser \
  --ip=127.0.0.1 \
  --port=8888 \
  --ServerApp.open_browser=False \
  --ServerApp.token='' \
  --ServerApp.password=''
EOF

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
