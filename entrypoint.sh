#!/bin/bash
set -e

# Clean X locks
rm -f /tmp/.X*-lock
rm -f /tmp/.X11-unix/X*

# Set defaults
export DISPLAY=${DISPLAY:-:0}
DISPLAY_NUMBER=$(echo $DISPLAY | cut -d: -f2)
export NOVNC_PORT=${NOVNC_PORT:-8080}
export VNC_PORT=${VNC_PORT:-5900}
export VNC_RESOLUTION=${VNC_RESOLUTION:-1280x800}

# Set VNC password if given
if [ -n "$VNC_PASSWORD" ]; then
  mkdir -p /root/.vnc
  echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
  chmod 0600 /root/.vnc/passwd
  export VNC_SEC=
else
  export VNC_SEC="-securitytypes TLSNone,X509None,None"
fi

# Calculate local framebuffer port
export LOCALFBPORT=$((${VNC_PORT} + DISPLAY_NUMBER))

# Enable GPU acceleration
if [ -n "$ENABLEHWGPU" ] && [ "$ENABLEHWGPU" = "true" ]; then
  export VGLRUN="/usr/bin/vglrun"
else 
  export VGLRUN=
fi

export SUPD_LOGLEVEL="${SUPD_LOGLEVEL:-TRACE}"
export VGL_DISPLAY="${VGL_DISPLAY:-egl}"

# --- NEW: Ensure config dir exists ---
mkdir -p /configs/.config/OrcaSlicer
chown -R orcaslicer:orcaslicer /configs/.config

# Fix all other perms
chown -R orcaslicer:orcaslicer /home/orcaslicer/ /configs/ /prints/ /dev/stdout

# Run supervisord as orcaslicer
exec gosu orcaslicer supervisord -e "$SUPD_LOGLEVEL"
