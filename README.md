# docker-mod-auth-oidc

Docker packaging of mod-auth-openidc to test Gluu Server.

## Running The Container

### Required Files

1. SSL certificate (i.e. `apache.crt`).
2. SSL key (i.e. `apache.key`).
3. OpenID client ID (saved in `oidc_client_id` file).
4. OpenID client secret (saved in `oidc_client_secret` file).
5. OpenID passphrase (saved in `oidc_passphrase` file).

### Environment Variables

* `SERVER_NAME`: server name (default to `localhost`)
* `OIDC_PROVIDER`: Base URL of OpenID provider (default to `https://localhost`)
* `OIDC_CACHE_TYPE`: mod-auth-openidc caching type (default to `shm`; valid choices are `shm` and `redis`)
* `OIDC_CACHE_SHM_MAXSIZE`: maximum entry size for `shm` cache (default to `32678`)
* `OIDC_CACHE_REDIS_URL`: URL of Redis server (default to `localhost:6379`)

### Example

```
docker run \
    --rm \
    --name mod-auth-oidc \
    --add-host single.gluu.local:192.168.100.4 \
    -v $PWD/apache.crt:/etc/apache2/ssl/apache.crt \
    -v $PWD/apache.key:/etc/apache2/ssl/apache.key \
    -v $PWD/oidc_client_id:/etc/certs/oidc_client_id \
    -v $PWD/oidc_client_secret:/etc/certs/oidc_client_secret \
    -v $PWD/oidc_passphrase:/etc/certs/oidc_passphrase \
    -v $PWD/tmp:/app/tmp \
    -e OIDC_PROVIDER=https://single.gluu.local \
    -e SERVER_NAME=rp.gluu.local \
    iromli/mod-auth-openidc
```
