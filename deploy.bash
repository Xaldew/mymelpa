#!/usr/bin/env bash
# Deploy the packages and website.

sign=false
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
        *)        # Default case.
            printf "Unexpected argument: $1."
            exit 1
            ;;
    esac
    shift
done

echo '[]' > html/download_counts.json
echo '{}' > html/build-status.json
for pkg in html/packages/archive-contents html/packages/*.tar;
do
    if [ "$sign" = true ]; then
        gpg2 --detach-sign --armor -o $pkg.sig $pkg
    fi
done
rsync --archive --copy-links --verbose --recursive html/* hsrv:/var/www/gustafwaldemarson.com/elpa
