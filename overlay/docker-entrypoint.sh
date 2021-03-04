#!/usr/bin/env sh
set -e

PUID="${PUID:-101}"
PGID="${PGID:-101}"
export TZ="${TZ:-UTC}"

echo ""
echo "----------------------------------------"
echo " Starting FlexGet using the following:  "
echo "                                        "
echo "     UID: $PUID                         "
echo "     GID: $PGID                         "
echo "     TZ:  $TZ                           "
echo "----------------------------------------"
echo ""

# Copy default config files
if [ ! -f "/config/config.yml" ]; then
    cp /defaults/config.yml /config/config.yml
fi

# Clear "config lock", if it exists
rm -f /config/.config-lock

# Set UID/GID of user
sed -i "s/^flexget\:x\:101\:101/flexget\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^flexget\:x\:101/flexget\:x\:$PGID/" /etc/group

# Set permissions
chown -R $PUID:$PGID /config

exec "$@"
