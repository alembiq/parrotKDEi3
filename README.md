## [Parrot OS + KDE + i3 installation &amp; configuration](https://github.com/alembiq/parrotKDEi3)

This isn't anything fancy, just my basic "/etc/skel" to be used on [Parrot Linux](https://parrotlinux.org/) 
with KDE and [i3 tilling manager](https://i3wm.org/). There are also few extra scripts I'm using basically 
everywhere (someone should just write some documentation for them). I should also point out, it's far from 
perfect, it's just good enough for shortening the time I need to install new machine.

### Install

```
curl -sL https://raw.githubusercontent.com/alembiq/parrotKDEi3/master/scripts/install-parrot.sh | sh
```


#### Changelog

- 18.1.2021  .profile > .bash_profile
- 2.11.2020  Plasma i3 as system wide profile, updated for Parrot 4.10 KDE
- 14.6.2020  updated for Parrot 4.9 KDE
- 14.6.2020  installer for spotify, riot.im
- 12.6.2020  configurator for Lenovo Thinkpad X1 Carbon 7th generation (sound, mic, wwan)
- 3.10.2019  updated to Parrot 4.7 KDE
