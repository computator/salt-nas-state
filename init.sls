{% set root_path = salt['pillar.get']('nas:root_path') %}

include:
  - nginx
  - serviio
  - samba

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

nas-samba-conf:
  file.blockreplace:
    - name: /etc/samba/smb.conf
    - content: |
        {%- for path, config in salt['pillar.get']('nas:paths', []).iteritems() %}
        {%- if 'smb' in config %}
        [{{ path.replace('/', '-') }}]
        path = {{ root_path }}/{{ path }}
        guest ok = {% if config['smb']['public']|default(true) %}yes{% else %}no{% endif %}
        read only = yes
        {%- if 'allow_write' in config['smb'] %}
        write list = {{ config['smb']['allow_write'] }}
        {%- endif %}
        {% endif %}
        {%- endfor %}
    - append_if_not_found: true
    - require:
      - pkg: samba
    - watch_in:
      - service: samba

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
