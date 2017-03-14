#!/bin/bash
# script to setup the core of the image

# update and upgrade all packages.
apt-get update
apt-get dist-upgrade -y --no-install-recommends

# Install init process.
cp /build/bin/my_init /sbin/
chmod 750 /sbin/my_init
mkdir -p /etc/my_init.d
mkdir -p /etc/container_environment
touch /etc/container_environment.sh
touch /etc/container_environment.json
chmod 700 /etc/container_environment

groupadd -g 8377 docker_env
chown :docker_env /etc/container_environment.sh /etc/container_environment.json
chmod 640 /etc/container_environment.sh /etc/container_environment.json
ln -s /etc/container_environment.sh /etc/profile.d/
echo ". /etc/container_environment.sh" >> /root/.bashrc

# install runit.
apt-get install -y --no-install-recommends runit cron

# install cron daemon.
mkdir -p /etc/service/cron
mkdir -p /var/log/cron
mkdir -p /etc/corntabs
chmod 600 /etc/crontabs
cp /build/runit/cron /etc/service/cron/run
cp /build/config/cron_log_config /var/log/cron/config
chown -R nobody  /var/log/cron
chmod +x /etc/service/cron/run

# remove useless cron entries.
rm -f /etc/cron.daily/standard
rm -f /etc/cron.daily/upstart
rm -f /etc/cron.daily/dpkg
rm -f /etc/cron.daily/password
rm -f /etc/cron.weekly/fstrim

# Often used tools.
apt-get install -y --no-install-recommends curl less nano psmisc wget

# cleaning up
rm -rf /var/lib/apt/lists/*
