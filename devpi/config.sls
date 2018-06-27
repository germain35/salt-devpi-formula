{%- from "devpi/map.jinja" import devpi with context %}

include:
  - devpi.install

devpi_init:
  cmd.wait:
    - name: devpi-server --init --serverdir={{devpi.serverdir}}
    - runas: {{ devpi.user }}
    - watch:
      - pip: devpi_packages
