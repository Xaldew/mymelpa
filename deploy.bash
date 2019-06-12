#!/usr/bin/env bash
# Deploy the packages and website.

echo '[]' > html/download_counts.json
echo '{}' > html/build-status.json
for pkg in html/packages/archive-contents html/packages/*.tar;
do
    gpg2 --detach-sign --armor -o $pkg.sig $pkg
done
rsync --archive --copy-links --verbose --recursive html/* hsrv:/var/www/gustafwaldemarson.com/elpa
