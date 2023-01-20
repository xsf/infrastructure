#!/bin/sh

cd /docker/xmpp-providers
git pull
git -C xmpp-providers-website pull
docker-compose up -d --build
