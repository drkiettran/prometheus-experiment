#!/bin/bash

# Make sure to change port #, user id, and the content of your prometheus.yml
docker run -d --user 1000 --volume "$HOME/data:/var/lib/grafana" -p 3000:3000 --name grafana grafana/grafana
