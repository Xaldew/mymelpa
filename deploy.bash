#!/usr/bin/env bash
# Deploy the packages and website.

sign=false
location=hsrv
while :; do
    case $1 in
        -h|-\?|--help)
            printf "deploy.bash "
            printf "[-h|--help]"
            printf "[-s|--sign]\n"
            exit 0
            ;;
        -s|--sign)
            sign=true
            ;;
        -l|--location)
            location=$2
            shift
            ;;
        -?*)
            printf "Unexpected argument: $1."
            exit 1
            ;;
        *)
            break
            ;;
    esac
    shift
done

echo '[]' > html/download_counts.json
echo '{}' > html/build-status.json
pin=
if [ "$sign" = true ]; then
    read -s -p "PIN: " pin
fi
for pkg in html/packages/archive-contents html/packages/*.tar;
do
    if [ "$sign" = true ]; then
        echo ${pin} | gpg2 --batch --yes --pinentry-mode loopback --passphrase-fd 0 --detach-sign --armor -o $pkg.sig $pkg
    fi
done
pin=
rsync --archive --copy-links --verbose --recursive html/packages/* hsrv:/var/www/gustafwaldemarson.com/elpa
