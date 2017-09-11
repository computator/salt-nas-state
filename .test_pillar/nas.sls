nas:
  http:
    server_name: nas
  root_path: /srv/storage
  paths:
    private: []
    protected:
      http:
        auth: Testing
        auth_data: |
          test:{PLAIN}test
    public:
      http: []
      dlna: []
    nested/loc1:
      http: []
    nested/loc2:
      http: []
