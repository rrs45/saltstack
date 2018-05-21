install_nfs_utils:
 pkg.installed:
  - name: nfs-utils
  
/etc/fstab:
 file.append: 
    - text: |
       #Mount NetApp NFS SSD storage for Tesseract Prometheus
       <<mountpoint1>>	/mnt/prometheus		nfs  noatime,nfsvers=3,actimeo=1800,rsize=8192,wsize=8192,intr,tcp

/mnt/prometheus:
  mount.mounted:
    - name: /mnt/prometheus
    - device: <<mountpoint1>>
    - fstype: nfs
    - opts: "noatime,vers=3,actimeo=1800,rsize=65535,wsize=65535,intr,tcp"
    - persist: 'True'
    - mkmnt: 'True'

/mnt/prometheus/{{ pillar['site'] }}_prom{{ pillar['prom_instance'] }}_data:
  file.directory

/opt/prometheus:
  file.directory
  
/opt/prometheus/prometheus:
  file.managed:
    - source:
       - salt://prometheus/prometheus-{{ pillar['prom_version'] }}.linux-amd64/prometheus
    - user: root
    - group: root
    - mode: 755
    
/opt/prometheus/prom_config.yml:
  file.managed:
    - source:
       - salt://prometheus/configs/{{ pillar['site'] }}_prom{{ pillar['prom_instance'] }}_config.yml
    - user: root
    - group: root
    - mode: 644

prometheus_systemd_unit:
  file.managed:
    - name: /etc/systemd/system/prometheus.service
    - contents: |
        [Unit]
        Description=Prometheus Time-Seris Monitoring 
        Documentation=https://prometheus.io/docs/introduction/overview/
        After=network.target blackbox.service
        [Service]
        Type=simple
        ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prom_config.yml --storage.tsdb.path=/mnt/prometheus/{{ pillar['site'] }}_prom{{ pillar['prom_instance'] }}_data --log.level=debug  --storage.tsdb.retention=12d        
        [Install]
        WantedBy=multi-user.target
        
prometheus_daemonize:
   module.run:
     - name: service.systemctl_reload
     - onchanges:
        - file: prometheus_systemd_unit
 
prometheus_service:
   service.running:
     - name: prometheus
     - enable: True

