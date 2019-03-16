#!/usr/bin/env sh
set -e

PUID="${PUID:-100}"
PGID="${PGID:-101}"

echo ""
echo "----------------------------------------"
echo " Starting FlexGet, using the following: "
echo "                                        "
echo "     UID: $PUID                         "
echo "     GID: $PGID                         "
echo "----------------------------------------"
echo ""

# Copy default config files
if [ ! -f "/config/config.yml" ]; then
    cp /defaults/config.yml /config/config.yml
fi

# Set UID/GID of user
sed -i "s/^flexget\:x\:100\:101/flexget\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^flexget\:x\:101/flexget\:x\:$PGID/" /etc/group

# Set permissions
chown -R $PUID:$PGID /config

exec "$@"
