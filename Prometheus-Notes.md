# Notes on Prometheus Experiment

By Kiet T. Tran, Ph.D.

Prometheus is a cool monitoring tool. I started this project at work; however, in this experiment, I am working on the monitoring of things at home. Various electornics things can be monitored. I work on this project using my brand new PC system my son Peter built for me.

## The system

This is the specifications of my system. The project does not requires this much power. I use this system for other things:

- 24 cores CPU
- 64 GB of memory
- 2 TB of hard-drive hosting Windows 10 Profession.
- Miscellenous hard-drive disk space amount to upward of 10+ TB.

I run Oracle Virtual Box 6.1. For this experiment, I run on a 32 GB Ubuntu 18.04.3 Desktop VM. I allocated 500GB of diskspace for this VM.

## The intention

The intention is to build a 'federated' prometheus for variety of environments I have access at home. For example, I want to monitor my garage door opener, various Raspberry Pi devices around the house.

I want to use Docker containers as much as possible; however, it may not be possible do so in many instances. For example, I wanted to monitor the VM that I am using for the experiment itself - this 12 core, 32 GB, 500 GB of Ubuntu.

- I installed latest Docker-CE on my VM using this website:
`https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04`

- I installed go-lang using this website: `https://github.com/golang/go/wiki/Ubuntu`

- I clone node-exporter located here: `https://github.com/prometheus/node_exporter`. I built the exporter using `make` command and then just simply ran it as `node-exporter` from the main directory.

- I followed the instruction given by `Schnk` at this website: `https://devconnected.com/how-to-install-prometheus-with-docker-on-ubuntu-18-04/`. Here is my scripts from this website to start up my Prometheus in a docker container.

```bash
sudo useradd -rs /bin/false prometheus
sudo mkdir /etc/prometheus
cd /etc/prometheus/ && sudo touch prometheus.yml
sudo mkdir -p /data/prometheus
sudo chown prometheus:prometheus /data/prometheus /etc/prometheus/*
sudo vim /etc/prometheus/prometheus.yml
sudo netstat -tulpn | grep 9090
sudo apt install net-tools
sudo netstat -tulpn | grep 9090
cat /etc/passwd | grep prometheus
docker run --name prometheus -p 9090:9090 --user 998:997 --net=host -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v /data/prometheus:/data/prometheus prom/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/data/prometheus
```

- I started a `grafana` server using this command:

```bash

docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker run --user 1000 --volume "$PWD/data:/var/lib/grafana" -p 3000:3000 --name grafana grafana/grafana
```

- I copied the prometheus.yml from the container, located at `/etc/prometheus/prometheus.yml` and added a new target at `http://localhost:9100`. The updated `yml` file is show below. The reason using 172.17.0.1 is because the prometheus is running inside a Docker container. 
  

```yaml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
    - targets: ['172.17.0.1:9100']
    - targets: ['192.168.1.60:9100']

  - job_name: 'jenkins'
    metrics_path: /jenkins/prometheus
    static_configs:
    - targets: ['192.168.1.60:8080']

  - job_name: 'spring_micrometer'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 5s
    static_configs:
    - targets: ['172.17.0.1:8181']
    
```

## Install golang on centos 7

- I used this website to install golang to centos 7: `https://tecadmin.net/install-go-on-centos/`
- I installed gcc using `sudo yum install gcc`.

- I clone node_exporter from here: `https://github.com/prometheus/node_exporter`. I build it using make.
- I ran exporter via `node_exporter` on port 9100. Need to open up the firewall: `sudo firewall-cmd --add-port=9100/tcp`.
- I updated the `prometheus.yml` to add `targets['192.168.1.60:9100']`

## Monitor Windows

- I searched and found `wmi_exporter` for Windows 10

## Spring Boot with Prometheus

Added a monitoring job to the prometheus:

```

  - job_name: 'spring_micrometer'
    metrics_path: '/actuator/prometheus'
    scrape_interval: 5s
    static_configs:
    - targets: ['172.17.0.1:8181']

```

## Import grafana

- I imported grafana dashboard by searching for a number:
  - 1860 (Prometheus node)
  - 2129 (Windows dashboard - wmi)
  - 4701 (JVM monitor)
  - 6756 (Spring Boot)
  - 2358 (jenkins ci)

