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
      smb:
        public: false
        allow_write: ubuntu
    public:
      http: []
      dlna: []
      smb: []
    nested/loc1:
      http: []
      smb: []
    nested/loc2:
      http: []
