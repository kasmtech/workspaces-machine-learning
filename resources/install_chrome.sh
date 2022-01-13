#!/usr/bin/env bash
set -ex

CHROME_ARGS="--password-store=basic --no-sandbox --ignore-gpu-blocklist --user-data-dir --no-first-run --simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"

ARCH=$(uname -p)

if [[ "${ARCH}" =~ ^aarch64$ ]] ; then
    # Install Chromium for arm64 platforms since Chrome is not available

    add-apt-repository ppa:saiarcot895/chromium-dev
    apt install -y chromium-browser

    sed -i 's/-stable//g' /usr/share/applications/chromium-browser.desktop

    cp /usr/share/applications/chromium-browser.desktop $HOME/Desktop/
    chown 1000:1000 $HOME/Desktop/chromium-browser.desktop
    chmod +x $HOME/Desktop/chromium-browser.desktop

    mv /usr/bin/chromium-browser /usr/bin/chromium-browser-orig
    cat >/usr/bin/chromium-browser <<EOL
    #!/usr/bin/env bash
    sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
    sed -i 's/"exit_type":"Crashed"/"exit_type":"None"/' ~/.config/chromium/Default/Preferences
    /usr/bin/chromium-browser-orig ${CHROME_ARGS} "\$@"
EOL
    chmod +x /usr/bin/chromium-browser
    cp /usr/bin/chromium-browser /usr/bin/chromium

    sed -i 's@exec -a "$0" "$HERE/chromium" "$\@"@@g' /usr/bin/x-www-browser
    cat >>/usr/bin/x-www-browser <<EOL
    exec -a "\$0" "\$HERE/chromium" "${CHROME_ARGS}"  "\$@"
EOL
    mkdir -p /etc/chromium/policies/managed/
    cat >>/etc/chromium/policies/managed/default_managed_policy.json <<EOL
    {"CommandLineFlagSecurityWarningsEnabled": false, "DefaultBrowserSettingEnabled": false}
EOL

else
    # Install Google Chrome for amd64 platforms for best performance

    apt-get update
    apt-get remove -y chromium-browser-l10n chromium-codecs-ffmpeg chromium-browser

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt-get install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb

    sed -i 's/-stable//g' /usr/share/applications/google-chrome.desktop

    cp /usr/share/applications/google-chrome.desktop $HOME/Desktop/
    chown 1000:1000 $HOME/Desktop/google-chrome.desktop

    mv /usr/bin/google-chrome /usr/bin/google-chrome-orig
    cat >/usr/bin/google-chrome <<EOL
    #!/usr/bin/env bash
    /opt/google/chrome/google-chrome ${CHROME_ARGS} "\$@"
EOL
    chmod +x /usr/bin/google-chrome
    cp /usr/bin/google-chrome /usr/bin/chrome

    sed -i 's@exec -a "$0" "$HERE/chrome" "$\@"@@g' /usr/bin/x-www-browser
    cat >>/usr/bin/x-www-browser <<EOL
    exec -a "\$0" "\$HERE/chrome" "${CHROME_ARGS}"  "\$@"
EOL

    mkdir -p /etc/opt/chrome/policies/managed/
    cat >>/etc/opt/chrome/policies/managed/default_managed_policy.json <<EOL
    {"CommandLineFlagSecurityWarningsEnabled": false, "DefaultBrowserSettingEnabled": false}
EOL

fi

