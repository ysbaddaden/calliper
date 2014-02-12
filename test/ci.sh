#! /bin/sh

browsers="firefox"
SAUCELABS_SETUP_URL="https://gist.github.com/santiycr/5139565/raw/sauce_connect_setup.sh"

if [ "$SAUCELABS" != "" ]; then
    curl "$SAUCELABS_SETUP_URL" | bash > /dev/null
    browsers="$browsers chrome internet_explorer"
fi

for browser in $browsers; do
    bundle exec rake test BROWSER=$browser
    [ $? -ne 0 ] && exit 1
done

exit 0
