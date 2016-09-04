# oauth2_proxy
A docker image with https://github.com/bitly/oauth2_proxy and a wrapper to simplify running it.

## usage
### gitlab (cloud service)
```
docker run -d -p 4180:4180 \  
  -e PROVIDER="gitlab" \  
  -e CLIENT_ID="application id" -e CLIENT_SECRET="secret" \  
  -e EMAIL_DOMAIN="example.com" \  
  larsla/oauth2_proxy  
```

### gitlab (self hosted)
```
docker run -d -p 4180:4180 \  
  -e PROVIDER="gitlab" \  
  -e CLIENT_ID="application id" -e CLIENT_SECRET="secret" \  
  -e EMAIL_DOMAIN="example.com" \  
  -e GITLAB_URL="https://gitlab.example.com" \  
  larsla/oauth2_proxy
```

### github
```
docker run -d -p 4180:4180 \  
  -e PROVIDER="github" \  
  -e CLIENT_ID="application id" -e CLIENT_SECRET="secret" \  
  -e GITHUB_ORG="myorg" -e GITHUB_TEAM="developers" \  
  -e EMAIL_DOMAIN="example.com" \  
  larsla/oauth2_proxy  
```

### github enterprise
```
docker run -d -p 4180:4180 \  
  -e PROVIDER="github" \  
  -e CLIENT_ID="application id" -e CLIENT_SECRET="secret" \  
  -e GITHUB_ORG="myorg" -e GITHUB_TEAM="developers" \  
  -e EMAIL_DOMAIN="example.com" \  
  -e GITHUB_URL="https://github.example.com"  
  larsla/oauth2_proxy  
```

### google
```
docker run -d -p 4180:4180 \  
  -v /path/to/service_account.json:/google/service_account.json  \
  -e PROVIDER="google" \  
  -e CLIENT_ID="application id" -e CLIENT_SECRET="secret" \  
  -e GOOGLE_ADMIN_EMAIL="admin@example.com" -e GOOGLE_GROUP="developers" \  
  -e EMAIL_DOMAIN="example.com" \  
  -e GOOGLE_ACCOUNT_JSON="/google/service_account.json"
  larsla/oauth2_proxy  
```


## nginx config
This nginx config is an example usage for protecting Kibana:
```
server {
  listen 443 ssl;
  server_name kibana.example.com;
  ssl_certificate /path/to/cert.pem;
  ssl_certificate_key /path/to/key.pem;
  add_header Strict-Transport-Security max-age=2592000;

  location = /oauth2/auth {
    internal;
    proxy_pass http://127.0.0.1:4180;
  }

  location /oauth2/ {
    proxy_pass http://127.0.0.1:4180;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Scheme $scheme;
  }

  location / {
    auth_request /oauth2/auth;
    error_page 401 = https://kibana.example.com/oauth2/sign_in;

    proxy_pass http://127.0.0.1:5601;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Scheme $scheme;
  }
}

```
