{% set root_path = salt['pillar.get']('nas:root_path') %}

include:
  - nginx
  - serviio

serviio-library:
  serviio.library:
    - library:
      {% for path, config in salt['pillar.get']('nas:paths', []).iteritems() %}
      {% if 'dlna' in config %}
      - {{ root_path }}/{{ path }}
      {% endif %}
      {% endfor %}
    - require:
      - service: serviio
