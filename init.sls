{% set root_path = salt['pillar.get']('nas:root_path') %}

include:
  - nginx
  - serviio

nas-dlna-conf:
  serviio.library:
    - library:
      {% for path, config in salt['pillar.get']('nas:paths', []).iteritems() %}
      {% if 'dlna' in config %}
      - {{ root_path }}/{{ path }}
      {% endif %}
      {% endfor %}
    - require:
      - service: serviio

nas-nginx-conf:
  file.managed:
    - name: /etc/nginx/conf.d/nas.conf
    - source: salt://nas/nginx.conf
    - template: jinja
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

{% for path, config in salt['pillar.get']('nas:paths', []).iteritems() %}
{% if 'http' in config and 'auth' in config['http'] %}
nas-nginx-auth-{{ path|replace('/', '-') }}:
  file.managed:
    - name: /etc/nginx/auth/{{ path|replace('/', '-') }}.htpasswd
    {% if config['http']['auth_data']|default %}
    - contents_pillar: nas:paths:{{ path }}:http:auth_data
    {% else %}
    - source: {{ config['http']['auth_file'] }}
    {% endif %}
    - makedirs: true
    - require:
      - file: nas-nginx-conf
    - watch_in:
      - service: nginx
{% endif %}
{% endfor %}
