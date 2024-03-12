# scMerlin
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/bfd397624cdf4803a465d4ae1530e7fe)](https://www.codacy.com/app/jackyaz/scMerlin?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=jackyaz/scMerlin&amp;utm_campaign=Badge_Grade)
![Shellcheck](https://github.com/jackyaz/scMerlin/actions/workflows/shellcheck.yml/badge.svg)

## v2.4.1
### Updated on 2022-01-05
## About
scMerlin allows you to easily control the most common services/scripts on your router. scMerlin also augments your router's WebUI with a Sitemap and dynamic submenus for the main left menu of Asuswrt-Merlin.

scMerlin is free to use under the [GNU General Public License version 3](https://opensource.org/licenses/GPL-3.0) (GPL 3.0).

### Supporting development
Love the script and want to support future development? Any and all donations gratefully received!

| [![paypal](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=47UTYVRBDKSTL) <br /><br /> [**PayPal donation**](https://www.paypal.com/donate/?hosted_button_id=47UTYVRBDKSTL) | [![paypal](https://puu.sh/IAhtp/3788f3a473.png)](https://www.paypal.com/donate/?hosted_button_id=47UTYVRBDKSTL) |
| :----: | --- |

## Installation
Using your preferred SSH client/terminal, copy and paste the following command, then press Enter:

```sh
/usr/sbin/curl -fsL --retry 3 "https://jackyaz.io/scmerlin/master/install/scmerlin.sh" -o "/jffs/scripts/scmerlin" && chmod 0755 /jffs/scripts/scmerlin && /jffs/scripts/scmerlin install
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

![WebUI](https://puu.sh/HLbzj/a8d2b5b15e.png)

![CLI UI](https://puu.sh/HKZbb/a85852adea.png)

## Help
Please post about any issues and problems here: [Asuswrt-Merlin AddOns on SNBForums](https://www.snbforums.com/forums/asuswrt-merlin-addons.60/?prefix_id=23)

### Scarf Gateway
Installs and updates for this addon are redirected via the [Scarf Gateway](https://about.scarf.sh/scarf-gateway) by [Scarf](https://about.scarf.sh/about). This allows me to gather data on the number of new installations of my addons, how often users check for updates and more. This is purely for my use to actually see some usage data from my addons so that I can see the value provided by my continued work. It does not mean I am going to start charging to use my addons. My addons have been, are, and will always be completely free to use.

Please refer to Scarf's [Privacy Policy](https://about.scarf.sh/privacy) for more information about the data that is collected and how it is processed.
