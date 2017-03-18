# Rubick

The Ruby on Rails local development environment. Thanks to [Laravel Homestead](https://github.com/laravel/homestead).

- [Introduction](#introduction)
- [Installation & Setup](#installation-and-setup)
    - [First Steps](#first-steps)
    - [Configuring Rubick](#configuring-rubick)
    - [Launching The Vagrant Box](#launching-the-vagrant-box)
    - [Installing MariaDB](#installing-mariadb)
- [Daily Usage](#daily-usage)
    - [Quickstart Your Rails Applications](#quickstart-your-rails-applications)
    - [Accessing Rubick Globally](#accessing-rubick-globally)
    - [Connecting Via SSH](#connecting-via-ssh)
    - [Connecting To Databases](#connecting-to-databases)
    - [Adding Additional Sites](#adding-additional-sites)
    - [Ports](#ports)
    - [Sharing Your Environment](#sharing-your-environment)
- [Network Interfaces](#network-interfaces)
- [Updating Rubick](#updating-rubick)
- [Provider Specific Settings](#provider-specific-settings)
    - [VirtualBox](#provider-specific-virtualbox)

<a name="introduction"></a>
## Introduction

[Vagrant](https://www.vagrantup.com) provides a simple, elegant way to manage and provision Virtual Machines.

Rubick is a pre-packaged Vagrant box that provides you a wonderful development environment without requiring you to install Ruby, a web server, and any other server software on your local machine. No more worrying about messing up your operating system! Vagrant boxes are completely disposable. If something goes wrong, you can destroy and re-create the box in minutes!

Rubick runs on any Windows, Mac, or Linux system, and includes the Nginx web server, Ruby 2.4.0, MySQL, Postgres, Redis, Memcached, Node, and all of the other goodies you need to develop amazing Ruby applications.

> If you are using Windows, you may need to enable hardware virtualization (VT-x). It can usually be enabled via your BIOS. If you are using Hyper-V on a UEFI system you may additionally need to disable Hyper-V in order to access VT-x.

<a name="included-software"></a>
### Included Software

- Ubuntu 16.04
- Git
- Ruby 2.4.0
- Rails 5.0.1
- Nginx
- [Phusion Passenger](https://github.com/phusion/passenger)
- MySQL
- MariaDB
- Sqlite3
- Postgres
- Node (With Yarn and Gulp)
- Redis
- Memcached
- Mailhog
- ngrok

<a name="installation-and-setup"></a>
## Installation & Setup

<a name="first-steps"></a>
### First Steps

Before launching your Rubick environment, you must install [VirtualBox 5.1](https://www.virtualbox.org/wiki/Downloads) as well as [Vagrant](https://www.vagrantup.com/downloads.html). All of these software packages provide easy-to-use visual installers for all popular operating systems.

#### Installing The Rubick Vagrant Box

Once VirtualBox and Vagrant have been installed, you should add the `cuonggt/rubick` box to your Vagrant installation using the following command in your terminal. It will take a few minutes to download the box, depending on your Internet connection speed:

    vagrant box add cuonggt/rubick

If this command fails, make sure your Vagrant installation is up to date.

#### Installing Rubick

You may install Rubick by simply cloning the repository. Consider cloning the repository into a `Rubick` folder within your "home" directory, as the Rubick box will serve as the host to all of your Ruby projects:

    cd ~

    git clone https://github.com/cuonggt/rubick.git Rubick

Once you have cloned the Rubick repository, run the `bash init.sh` command from the Rubick directory to create the `Rubick.yaml` configuration file. The `Rubick.yaml` file will be placed in the Rubick directory:

    // Mac / Linux...
    bash init.sh

    // Windows...
    init.bat

<a name="configuring-rubick"></a>
### Configuring Rubick

#### Setting Your Provider

The `provider` key in your `Rubick.yaml` file indicates which Vagrant provider should be used: `virtualbox`. You may set this to the provider you prefer:

    provider: virtualbox

#### Configuring Shared Folders

The `folders` property of the `Rubick.yaml` file lists all of the folders you wish to share with your Rubick environment. As files within these folders are changed, they will be kept in sync between your local machine and the Rubick environment. You may configure as many shared folders as necessary:

    folders:
        - map: ~/Code
          to: /home/vagrant/Code

To enable [NFS](https://www.vagrantup.com/docs/synced-folders/nfs.html), just add a simple flag to your synced folder configuration:

    folders:
        - map: ~/Code
          to: /home/vagrant/Code
          type: "nfs"

You may also pass any options supported by Vagrant's [Synced Folders](https://www.vagrantup.com/docs/synced-folders/basic_usage.html) by listing them under the `options` key:

    folders:
        - map: ~/Code
          to: /home/vagrant/Code
          type: "rsync"
          options:
              rsync__args: ["--verbose", "--archive", "--delete", "-zz"]
              rsync__exclude: ["node_modules"]


#### Configuring Nginx Sites

Not familiar with Nginx? No problem. The `sites` property allows you to easily map a "domain" to a folder on your Rubick environment. A sample site configuration is included in the `Rubick.yaml` file. Again, you may add as many sites to your Rubick environment as necessary. Rubick can serve as a convenient, virtualized environment for every Ruby or Rails project you are working on:

    sites:
        - map: rubick.app
          to: /home/vagrant/Code/Rails

If you change the `sites` property after provisioning the Rubick box, you should re-run `vagrant reload --provision`  to update the Nginx configuration on the virtual machine.

#### The Hosts File

You must add the "domains" for your Nginx sites to the `hosts` file on your machine. The `hosts` file will redirect requests for your Rubick sites into your Rubick machine. On Mac and Linux, this file is located at `/etc/hosts`. On Windows, it is located at `C:\Windows\System32\drivers\etc\hosts`. The lines you add to this file will look like the following:

    192.168.79.86  rubick.app

Make sure the IP address listed is the one set in your `Rubick.yaml` file. Once you have added the domain to your `hosts` file and launched the Vagrant box you will be able to access the site via your web browser:

    http://rubick.app

<a name="launching-the-vagrant-box"></a>
### Launching The Vagrant Box

Once you have edited the `Rubick.yaml` to your liking, run the `vagrant up` command from your Rubick directory. Vagrant will boot the virtual machine and automatically configure your shared folders and Nginx sites.

To destroy the machine, you may use the `vagrant destroy --force` command.

<a name="installing-mariadb"></a>
### Installing MariaDB

If you prefer to use MariaDB instead of MySQL, you may add the `mariadb` option to your `Rubick.yaml` file. This option will remove MySQL and install MariaDB. MariaDB serves as a drop-in replacement for MySQL so you should still use the `mysql` database driver in your application's database configuration:

    box: cuonggt/rubick
    ip: "192.168.20.20"
    memory: 2048
    cpus: 4
    provider: virtualbox
    mariadb: true

<a name="daily-usage"></a>
## Daily Usage

<a name="quickstart-your-rails-applications"></a>
### Quickstart Your Rails Applications

To start Rails built-in web sever [Puma](https://github.com/puma/puma), you may use the `bin/rails server -b 0.0.0.0` command. Once you have started the Rails built-in web server, you can access the site via your web browser:

    http://localhost:3000

<a name="accessing-rubick-globally"></a>
### Accessing Rubick Globally

Sometimes you may want to `vagrant up` your Rubick machine from anywhere on your filesystem. You can do this on Mac / Linux systems by adding a Bash function to your Bash profile. On Windows, you may accomplish this by adding a "batch" file to your `PATH`. These scripts will allow you to run any Vagrant command from anywhere on your system and will automatically point that command to your Rubick installation:

#### Mac / Linux

    function rubick() {
        ( cd ~/Rubick && vagrant $* )
    }

Make sure to tweak the `~/Rubick` path in the function to the location of your actual Rubick installation. Once the function is installed, you may run commands like `rubick up` or `rubick ssh` from anywhere on your system.

#### Windows

Create a `rubick.bat` batch file anywhere on your machine with the following contents:

    @echo off

    set cwd=%cd%
    set rubickVagrant=C:\Rubick

    cd /d %rubickVagrant% && vagrant %*
    cd /d %cwd%

    set cwd=
    set rubickVagrant=

Make sure to tweak the example `C:\Rubick` path in the script to the actual location of your Rubick installation. After creating the file, add the file location to your `PATH`. You may then run commands like `rubick up` or `rubick ssh` from anywhere on your system.

<a name="connecting-via-ssh"></a>
### Connecting Via SSH

You can SSH into your virtual machine by issuing the `vagrant ssh` terminal command from your Rubick directory.

But, since you will probably need to SSH into your Rubick machine frequently, consider adding the "function" described above to your host machine to quickly SSH into the Rubick box.

<a name="connecting-to-databases"></a>
### Connecting To Databases

A `rubick` database is configured for both MySQL and Postgres out of the box.

To connect to your MySQL or Postgres database from your host machine's database client, you should connect to `127.0.0.1` and port `33060` (MySQL) or `54320` (Postgres). The username and password for both databases is `rubick` / `secret`.

> You should only use these non-standard ports when connecting to the databases from your host machine. You will use the default 3306 and 5432 ports in your Rails database configuration file since Rails is running _within_ the virtual machine.

<a name="adding-additional-sites"></a>
### Adding Additional Sites

Once your Rubick environment is provisioned and running, you may want to add additional Nginx sites for your Rails applications. You can run as many Rails installations as you wish on a single Rubick environment. To add an additional site, simply add the site to your `Rubick.yaml` file:

    sites:
        - map: rubick.app
          to: /home/vagrant/Code/Rails/public
        - map: another.app
          to: /home/vagrant/Code/another/public

If Vagrant is not automatically managing your "hosts" file, you may need to add the new site to that file as well:

    192.168.79.86  rubick.app
    192.168.79.86  another.app

Once the site has been added, run the `vagrant reload --provision` command from your Rubick directory.

<a name="ports"></a>
### Ports

By default, the following ports are forwarded to your Rubick environment:

- **SSH:** 2222 &rarr; Forwards To 22
- **HTTP:** 8000 &rarr; Forwards To 80
- **HTTPS:** 44300 &rarr; Forwards To 443
- **MySQL:** 33060 &rarr; Forwards To 3306
- **Postgres:** 54320 &rarr; Forwards To 5432
- **Mailhog:** 8025 &rarr; Forwards To 8025
- **Rails:** 3000 &rarr; Forwards To 3000

#### Forwarding Additional Ports

If you wish, you may forward additional ports to the Vagrant box, as well as specify their protocol:

    ports:
        - send: 93000
          to: 9300
        - send: 7777
          to: 777
          protocol: udp

<a name="sharing-your-environment"></a>
### Sharing Your Environment

Sometimes you may wish to share what you're currently working on with coworkers or a  client. Vagrant has a built-in way to support this via `vagrant share`; however, this will not work if you have multiple sites configured in your `Rubick.yaml` file.

To solve this problem, Rubick includes its own `share` command. To get started, SSH into your Rubick machine via `vagrant ssh` and run `share rubick.app`. This will share the `rubick.app` site from your `Rubick.yaml` configuration file. Of course, you may substitute any of your other configured sites for `rubick.app`:

    share rubick.app

After running the command, you will see an Ngrok screen appear which contains the activity log and the publicly accessible URLs for the shared site. If you would like to specify a custom region, subdomain, or other Ngrok runtime option, you may add them to your `share` command:

    share rubick.app -region=eu -subdomain=laravel

> Remember, Vagrant is inherently insecure and you are exposing your virtual machine to the Internet when running the `share` command.

<a name="network-interfaces"></a>
## Network Interfaces

The `networks` property of the `Rubick.yaml` configures network interfaces for your Rubick environment. You may configure as many interfaces as necessary:

    networks:
        - type: "private_network"
          ip: "192.168.10.20"

To enable a [bridged](https://www.vagrantup.com/docs/networking/public_network.html) interface, configure a `bridge` setting and change the network type to `public_network`:

    networks:
        - type: "public_network"
          ip: "192.168.10.20"
          bridge: "en1: Wi-Fi (AirPort)"

To enable [DHCP](https://www.vagrantup.com/docs/networking/public_network.html), just remove the `ip` option from your configuration:

    networks:
        - type: "public_network"
          bridge: "en1: Wi-Fi (AirPort)"

<a name="updating-rubick"></a>
## Updating Rubick

You can update Rubick in two simple steps. First, you should update the Vagrant box using the `vagrant box update` command:

    vagrant box update

Next, you need to update the Rubick source code. If you cloned the repository you can simply `git pull origin master` at the location you originally cloned the repository.

<a name="provider-specific-settings"></a>
## Provider Specific Settings

<a name="provider-specific-virtualbox"></a>
### VirtualBox

By default, Rubick configures the `natdnshostresolver` setting to `on`. This allows Rubick to use your host operating system's DNS settings. If you would like to override this behavior, add the following lines to your `Rubick.yaml` file:

    provider: virtualbox
    natdnshostresolver: off
