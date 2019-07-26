## Installation

1. Install docker toolbox or docker CE.
2. Clone [Sourcegraph](https://github.com/sourcegraph/sourcegraph) project at the root of this project.
 ```
git clone https://github.com/sourcegraph/sourcegraph.git code
```
3. Update the following env variable in code/dev/launch.sh
```
export REDIS_ENDPOINT=redis:6379
```
4.Remove the following lines in `code/dev/launch.sh`
```
# Verify postgresql config.
hash psql 2>/dev/null || {
    # "brew install postgresql@9.6" does not put psql on the $PATH by default;
    # try to fix this automatically if we can.
    hash brew 2>/dev/null && {
        if [[ -x "$(brew --prefix)/opt/postgresql@9.6/bin/psql" ]]; then
            export PATH="$(brew --prefix)/opt/postgresql@9.6/bin:$PATH"
        fi
    }
}
if ! psql -wc '\x' >/dev/null; then
    echo "FAIL: postgreSQL config invalid or missing OR postgreSQL is still starting up."
    echo "You probably need, at least, PGUSER and PGPASSWORD set in the environment."
    exit 1
fi
```
5. Create a copy of `/code/dev/launch.sh` as `install.sh`
6. Remove the following lines in `install.sh`
```
printf >&2 "\nStarting all binaries...\n\n"
export GOREMAN="goreman --set-ports=false --exit-on-error -f ${PROCFILE:-dev/Procfile}"
exec $GOREMAN start
```
7. Go to the root of the project using the terminal and run:
```
docker-compose up
```
8. Let's wait until Sourcegraph initializes.
9. Open `http://localhost:3080` or if your are using docker machine would be `http://<docker-machine ip>:3080`

Note:
If you are running docker using docker-machine you should replace `localhost` with the docker machine IP in the Sourcegraph project.

Any contribution will be appreciated.
