#  Password-protected nginx WebDAV server with fail2ban Docker image

**Disclaimer**: If you want a WebDAV server that is actually practical to use, [this](https://github.com/sashgorokhov/docker-nginx-webdav) is probably closer to what you are looking for, although it does not include fail2ban.

Currently there is only one user called "test" whose password is "test". This is stored in the `.passwords.list` file in the `conf.d` directory. The file's layout is [username]:[hashedpassword]. As such, the process of adding a new user (on a Unix-based system with openssl installed) consists of changing directory to `conf.d` and running these two commands.

```shell
echo -n '[username]:' >> .passwords.list
openssl passwd -apr1 >> .passwords.list
```

Removing users is done by removing the appropriate line from `.passwords.list`.

After changing passwords and users, you would need to build the image again by running `docker build --tag nginx-webdav-fail2ban .` in the project's root. Alternatively, you could just have run the docker container, then run `docker exec --interactive --tty test sh` and changed everything within the docker container while it was running and then run `nginx -s reload` to make nginx reload the configuration files.

The command to run the image is this:

```
docker run --detach --mount type=volume,source=webdav,target=/var/www/webdav --publish 80:80 --name webdav --cap-add=NET_ADMIN nginx-webdav-fail2ban
```

The `cap-add=NET_ADMIN` line is what allows fail2ban to ban IP addresses. Note that these IP addresses are blocked on the host machine, not the container. Also note that the WebDAV data is stored in a docker volume called `webdav`.
