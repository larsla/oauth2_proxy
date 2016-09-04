#!/bin/bash

function generatesecret() {
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;
}

COOKIE_SECRET=${COOKIE_SECRET:-`generatesecret`}
PROVIDER=${PROVIDER:-"gitlab"}
EMAIL_DOMAIN=${EMAIL_DOMAIN:-"*"}
UPSTREAM_URL=${UPSTREAM_URL:-"http://127.0.0.1:1234"}

HTTP_ADDRESS=${HTTP_ADDRESS:-"0.0.0.0:4180"}
HTTPS_ADDRESS=${HTTPS_ADDRESS:-":443"}

case $PROVIDER in
"gitlab")
  if [ -n "${GITLAB_URL}" ]; then
    /go/bin/oauth2_proxy -provider="gitlab" \
      -http-address="${HTTP_ADDRESS}" \
      -https-address="${HTTPS_ADDRESS}" \
      -cookie-secret="${COOKIE_SECRET}" \
      -cookie-secure=true \
      -client-id="${CLIENT_ID}" \
      -client-secret="${CLIENT_SECRET}" \
      -login-url="${GITLAB_URL}/oauth/authorize" \
      -redeem-url="${GITLAB_URL}/oauth/token" \
      -validate-url="${GITLAB_URL}/api/v3/user" \
      -upstream="${UPSTREAM_URL}" \
      -email-domain="${EMAIL_DOMAIN}"
  else
    /go/bin/oauth2_proxy -provider="gitlab" \
      -http-address="${HTTP_ADDRESS}" \
      -https-address="${HTTPS_ADDRESS}" \
      -cookie-secret="${COOKIE_SECRET}" \
      -cookie-secure=true \
      -client-id="${CLIENT_ID}" \
      -client-secret="${CLIENT_SECRET}" \
      -upstream="${UPSTREAM_URL}" \
      -email-domain="${EMAIL_DOMAIN}"
  fi
  ;;
"github")
  if [ -n "${GITHUB_URL}" ]; then
    /go/bin/oauth2_proxy -provider="github" \
      -http-address="${HTTP_ADDRESS}" \
      -https-address="${HTTPS_ADDRESS}" \
      -cookie-secret="${COOKIE_SECRET}" \
      -cookie-secure=true \
      -client-id="${CLIENT_ID}" \
      -client-secret="${CLIENT_SECRET}" \
      -login-url="${GITHUB_URL}/login/oauth/authorize" \
      -redeem-url="${GITHUB_URL}/login/oauth/access_token" \
      -validate-url="${GITHUB_URL}/api/v3" \
      -upstream="${UPSTREAM_URL}" \
      -email-domain="${EMAIL_DOMAIN}" \
      -github-org="${GITHUB_ORG}" \
      -github-team="${GITHUB_TEAM}"
  else
    /go/bin/oauth2_proxy -provider="github" \
      -http-address="${HTTP_ADDRESS}" \
      -https-address="${HTTPS_ADDRESS}" \
      -cookie-secret="${COOKIE_SECRET}" \
      -cookie-secure=true \
      -client-id="${CLIENT_ID}" \
      -client-secret="${CLIENT_SECRET}" \
      -upstream="${UPSTREAM_URL}" \
      -email-domain="${EMAIL_DOMAIN}" \
      -github-org="${GITHUB_ORG}" \
      -github-team="${GITHUB_TEAM}"
  fi
  ;;
"google")
  /go/bin/oauth2_proxy -provider="google" \
    -http-address="${HTTP_ADDRESS}" \
    -https-address="${HTTPS_ADDRESS}" \
    -cookie-secret="${COOKIE_SECRET}" \
    -cookie-secure=true \
    -client-id="${CLIENT_ID}" \
    -client-secret="${CLIENT_SECRET}" \
    -upstream="${UPSTREAM_URL}" \
    -email-domain="${EMAIL_DOMAIN}" \
    -google-admin-email="${GOOGLE_ADMIN_EMAIL}" \
    -google-group="${GOOGLE_GROUP}" \
    -google-service-account-json="${GOOGLE_ACCOUNT_JSON}"
  ;;
*)
  echo "Not a known provider.."
  ;;
esac
