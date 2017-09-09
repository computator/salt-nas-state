{% set root_path = salt['pillar.get']('nas:root_path') %}

include:
  - nginx
  - serviio

{% for path, config in salt['pillar.get']('nas:paths', []).iteritems() %}
{% if 'dlna' in config %}
naspath-{{ path }}-dlna:
  file.accumulated:
    - filename: /etc/minidlna.conf
    - text: media_dir={{ root_path }}/{{ path }}
    - require_in:
      - file: minidlna-config
{% endif %}
{% endfor %}