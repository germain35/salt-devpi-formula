{%- from "devpi/map.jinja" import devpi with context %}

{%- if devpi.manage_user %}

devpi_group:
  group.present:
    - name: {{ devpi.group }}
    - system: True

devpi_user:
  user.present:
    - name: {{ devpi.user }}
    - home: {{ devpi.serverdir }}
    - shell: /bin/bash
    - system: True
    - createhome: False
    - groups:
      - {{ devpi.group }}
    - require:
      - group: devpi_group
    - require_in:
      - file: devpi_serverdir

{%- endif %}

devpi_serverdir:
  file.directory:
    - name: {{ devpi.serverdir }}
    - user: {{ devpi.user }}
    - group: {{ devpi.group }}
    - mode: 755
    - require:
      - user: devpi_user

{%- if devpi.python.get('version', False) %}
  {%- set string_version = devpi.python.version|string %}
  {%- set major_version  = string_version.split('.')[0]|int %}

devpi_python_packages:
  pkg.installed:
    - pkgs: 
      - python{{major_version}}-pip
      - python{{major_version}}-setuptools
    - reload_modules: true

devpi_packages:
  pip.installed:
    - pkgs: {{ devpi.pkgs }}
    - bin_env: {{ devpi.python.pip.bin_env }}
    {%- if devpi.python.pip.get('no_index', False) %}
    - no_index: True
    {%- endif %}
    {%- if devpi.python.pip.get('index_url', False) %}
    - index_url: {{ devpi.python.pip.index_url }}
      {%- if devpi.python.pip.get('trusted_host', False) %}
    - trusted_host: {{ devpi.python.pip.trusted_host }}
      {%- endif %}
    {%- endif %}
    {%- if devpi.python.pip.get('find_links', False) %}
    - find_links: {{ devpi.python.pip.find_links }}
    {%- endif %}
    - require:
      - pkg: devpi_python_packages

{%- else %}

devpi_python_packages:
  pkg.installed:
    - pkgs: 
      - python-pip
      - python-setuptools
    - reload_modules: true

devpi_packages:
  pip.installed:
    - pkgs: {{ devpi.pkgs }}
    - require:
      - pkg: devpi_python_packages

{%- endif %}