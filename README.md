# FreeBSD with erlang for Vagrant

![FreeBSD](https://raw.githubusercontent.com/ivan-iver/freebsd-vagrant-erlang/master/img/freebsd-logo-red.png)

## Description

This project is a [Vagrant] configuration for [Erlang] using [FreeBSD] as base OS.

**Table of Contents**

- [Quickstart](#quickstart)
- [Jails](#jails)
	- [Credits](#credits)
	- [License](#license)

## Quickstart

First clone the repository:

```
$ cd ~/workspace/
$ mkdir erlang-vm
$ git clone https://github.com/ivan-iver/freebsd-vagrant-erlang.git erlang-vm
```

After that you can run your vagrant machine:

```
$ cd erlang-vm/
$ vagrant up --provision
$ vagrant ssh
```

Then the box will be downloaded for you.

If you wish, you can learn more about it alter a [vagrant file](Vagrantfile) and its [configuration options](ConfigOptions).

## Jails

The box comes with a *cloned_interface* with IP address which can be used for [jails]. The range 172.23.0.1/16 is already configured for you with a proxy by
pf to have internet connectivity in a jail. To start a new jail, all you have
to do is:

    ezjail-admin install
    ezjail-admin create example.com 'lo1|172.23.0.1'
    ezjail-admin start example.com

    # Jump inside the jail
    ezjail-admin console example.com

If you want your jails started at boot, make sure to add `ezjail_enable="YES"`
to `/etc/rc.conf`.

## Software Details

* **FreeBSD version**: FreeBSD packer-freebsd-10.1-amd64 10.1-RELEASE FreeBSD 10.1-RELEASE #0 r274401: Tue Nov 11 21:02:49 UTC 2014     root@releng1.nyi.freebsd.org:/usr/obj/usr/src/sys/GENERIC  amd64

* **Erlang version**: Erlang/OTP 17 [erts-6.4] [source] [64-bit] [smp:2:2] [async-threads:10] [kernel-poll:false]
Eshell V6.4

## Credits

I got lots of useful configuration from [wunki].

## Copyright and license

***

Copyright (c) 2015 Iván Jaimes. See [LICENSE](LICENSE) for details.

[Erlang]: http://www.erlang.org/
[FreeBSD]: http://www.freebsd.org/
[Vagrant]: http://www.vagrantup.com/
[jails]: http://www.freebsd.org/doc/handbook/jails.html
[ZFS]: http://en.wikipedia.org/wiki/ZFS
[Vagrantfile]: https://github.com/ivan-iver/freebsd-vagrant-erlang/blob/master/Vagrantfile
[ConfigOptions]: http://docs.vagrantup.com/v2/vagrantfile/
[TODO.org]: https://github.com/wunki/freebsd-vagrant-erlang/blob/master/TODO.org
[wunki]: https://github.com/wunki/vagrant-freebsd

