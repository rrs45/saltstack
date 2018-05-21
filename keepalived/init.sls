install_keepalived_ipvsadm:
 pkg.installed:
   - pkgs:
     - keepalived
     - ipvsadm

sysctl_tuning:
 file.append:
  - name: /etc/sysctl.conf
  - text: |
       net.ipv4.ip_forward = 1
copy_config:
 file.managed:
  - name: /etc/keepalived/keepalived.conf
{% if "dc1" in grains['id'] %}
  - source: salt://keepalived/dc1.conf
{% elif "dc2" in grains['id'] %}
  - source: salt://keepalived/dc2.conf
{% endif %}
  - replace: True
  - template: jinja

keepalived_service:
 service.running:
 - name: keepalived
 - enable: True
 - watch:
   - file: /etc/keepalived/keepalived.conf
