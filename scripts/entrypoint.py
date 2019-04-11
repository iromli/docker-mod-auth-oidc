import os


def get_file_content(fn):
    txt = ""
    try:
        with open(fn) as f:
            txt = f.read()
    except IOError:
        pass
    return txt.strip()


def main():
    ctx = {
        "server_name": os.environ.get("SERVER_NAME", "localhost"),
        "oidc_client_id": r"{}".format(get_file_content("/etc/certs/oidc_client_id")) or "client_id",
        "oidc_client_secret": get_file_content("/etc/certs/oidc_client_secret") or "client_secret",
        "oidc_provider": os.environ.get("OIDC_PROVIDER", "https://localhost"),
        "oidc_passphrase": get_file_content("/etc/certs/oidc_passphrase") or "secret",
        "oidc_cache_type": os.environ.get("OIDC_CACHE_TYPE", "shm"),
        "oidc_cache_shm_maxsize": int(os.environ.get("OIDC_CACHE_SHM_MAXSIZE", 32678)),
        "oidc_cache_redis_url": os.environ.get("OIDC_CACHE_REDIS_URL", "redis:6379"),
    }
    with open("/app/templates/default-ssl.conf") as fr:
        txt = fr.read()

        with open("/etc/apache2/sites-available/default-ssl.conf", "w") as fw:
            fw.write(txt % ctx)


if __name__ == "__main__":
    main()
