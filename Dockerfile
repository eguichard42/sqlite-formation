FROM python:3.13-slim-bookworm AS sqlite-build
RUN apt-get update && apt-get install -y --no-install-recommends gcc libc6-dev curl ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /build
RUN curl -fsSLo sqlite.zip https://www.sqlite.org/2026/sqlite-amalgamation-3540100.zip \
    && python -c "import hashlib,pathlib,zipfile; p=pathlib.Path('sqlite.zip'); assert hashlib.sha3_256(p.read_bytes()).hexdigest() == '92281c86e2957f9b9305890f9ac04204caa7b677cc868dc326d942689df28e30'; zipfile.ZipFile(p).extractall()" \
    && cd sqlite-amalgamation-3540100 \
    && gcc -O2 -fPIC -shared -DSQLITE_ENABLE_MATH_FUNCTIONS -DSQLITE_ENABLE_FTS5 -Wl,-soname,libsqlite3.so.0 -o /build/libsqlite3.so.0 sqlite3.c -lm -ldl -pthread \
    && gcc -O2 -DHAVE_READLINE=0 -o /build/sqlite3 shell.c /build/libsqlite3.so.0 -lm -ldl -pthread

FROM python:3.13-slim-bookworm
COPY --from=sqlite-build /build/libsqlite3.so.0 /usr/local/lib/
COPY --from=sqlite-build /build/sqlite3 /usr/local/bin/
RUN ldconfig \
    && pip install --no-cache-dir sqlite-web==0.8.2 \
    && sqlite3 --version \
    && python -c "import sqlite3; assert sqlite3.sqlite_version == '3.54.1', sqlite3.sqlite_version" \
    && groupadd --gid 10001 formation && useradd --uid 10001 --gid 10001 --create-home formation \
    && install -d -o formation -g formation /data /data/sauvegardes
WORKDIR /app
COPY sql ./sql
COPY scripts ./scripts
COPY scripts/sqlite.rc /home/formation/.sqliterc
COPY formation ./formation
USER formation
EXPOSE 8080
ENTRYPOINT ["/app/scripts/entree.sh"]
CMD ["sqlite_web", "-H", "0.0.0.0", "-p", "8080", "-x", "-f", "/data/formation.db"]
