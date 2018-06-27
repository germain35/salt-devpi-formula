{%- from "devpi/map.jinja" import devpi with context %}

include:
  - devpi.install
  - devpi.config

devpi_service_file:
  file.managed:
    - name: /etc/systemd/system/{{ devpi.service }}.service
    - source: salt://devpi/files/devpi.service.jinja
    - template: jinja
    - user: root
    - group: root

devpi_systemctl_reload:
  module.wait:
    - service.systemctl_reload: []
    - watch:
      - file: devpi_service_file
    - watch_in:
      - service: devpi_service

devpi_service:
  service.running:
    - name: {{ devpi.service }}
    - enable: {{ devpi.service_enabled }}
    - watch:
      - file: devpi_service_file
      - cmd: devpi_init
