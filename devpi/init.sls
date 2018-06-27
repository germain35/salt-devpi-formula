{%- from "devpi/map.jinja" import devpi with context %}

include:
  - devpi.install
  - devpi.config
  - devpi.service