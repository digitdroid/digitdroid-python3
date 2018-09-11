#!/bin/sh
set -e

for f in /docker-entrypoint.d/*; do
    [ ! -f "$f" ] && continue

    case "$f" in
        *.sh)
            echo "==> Running: $f";
            "$f";;

        *.py)
            echo "==> Running: $f";
            gosu app python "$f";;

        *);;
    esac
done

case "$1" in
    python|pip|-)
        [ ${1} = '-' ] && shift

        set -- gosu app "$@"

        ;;
esac

echo "==> Running: $@"
exec "$@"
