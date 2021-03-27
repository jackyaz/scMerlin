# scMerlin
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/bfd397624cdf4803a465d4ae1530e7fe)](https://www.codacy.com/app/jackyaz/scMerlin?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=jackyaz/scMerlin&amp;utm_campaign=Badge_Grade)
[![Build Status](https://travis-ci.com/jackyaz/scMerlin.svg?branch=master)](https://travis-ci.com/jackyaz/scMerlin)

## v2.2.0
### Updated on 2021-03-28
## About
scMerlin allows you to easily control the most common services/scripts on your router.

scMerlin is free to use under the [GNU General Public License version 3](https://opensource.org/licenses/GPL-3.0) (GPL 3.0).

### Supporting development
Love the script and want to support future development? Any and all donations gratefully received!

[**PayPal donation**](https://paypal.me/jackyaz21)

[**Buy me a coffee**](https://www.buymeacoffee.com/jackyaz)

## Installation
Using your preferred SSH client/terminal, copy and paste the following command, then press Enter:

```sh
/usr/sbin/curl --retry 3 "https://raw.githubusercontent.com/jackyaz/scmerlin/master/scmerlin.sh" -o "/jffs/scripts/scmerlin" && chmod 0755 /jffs/scripts/scmerlin && /jffs/scripts/scmerlin install
```

## Supported firmware versions
You must be running firmware Merlin 384.15/384.13_4 or Fork 43E5 (or later) [Asuswrt-Merlin](https://asuswrt.lostrealm.ca/)

## Usage
### WebUI
scMerlin can be used via the WebUI, in the Addons section.

### Command Line
To launch the scMerlin menu after installation, use:
```sh
scmerlin
```

If this does not work, you will need to use the full path:
```sh
/jffs/scripts/scmerlin
```

## Screenshots

![WebUI](https://puu.sh/GJrCb/a55ad1a913.png)

![CLI UI](https://puu.sh/GKEK4/015c2c0108.png)

## Help
Please post about any issues and problems here: [Asuswrt-Merlin AddOns on SNBForums](https://www.snbforums.com/forums/asuswrt-merlin-addons.60/?prefix_id=23)
