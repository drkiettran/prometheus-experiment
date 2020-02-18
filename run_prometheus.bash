#!/bin/bash

# Make sure to change port #, user id, and the content of your prometheus.yml
docker run -d --name prometheus -p 9090:9090 --user 998:997 --net=host -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v /data/prometheus:/data/prometheus prom/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/data/prometheus
