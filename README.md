# Macbook Bootstrap

This project is intended to provide people with a quick way of setting up their macOS based device for development in the form of a simple to customize bash script.

* Install some common tooling to cover development of:
    * API
    * Database
* Install Version managers for common SDK:
    * NodeJS
    * Python
    * Java
* Setup shell environment:
    * Generate SSH
    * Force GIT SSH
    * Configure ZSH
    * Set /etc/hosts
    * Prepare project workspace

## Usage

### Install XCode

XCode is the offical Apple Integrated Development Environment. It is not mandatory to install XCode in entirety (because we only want GIT) but the author recommends installing it anyway because, there are mechanisms built in to macOS itself to manage the tool.

```
xcode-select --install
```

You may be prompted by an onscreen pop-up and also for your password in the terminal when you run the above command. The process may take anywhere up to or above twenty minutes.

# Install HomeBrew

A package manager for macOS, [Homebrew](https://brew.sh/) makes managing applications and libraries similar to Linux package managers such as apt (Debian), rpm (Redhat), or pacman (Arch). With Homebrew, you can run `brew upgrade` in order to update many packages on your system in one fell swoop

```
# Setup Homebrew
/bin/bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Test Homebrew installed
brew doctor
```

If you are having problems installing homebrew and running it's diagnostic program, please see the [following installation guide](https://docs.brew.sh/Installation).
## The Bootstrap script

There is only one thing to do, run `./bootstrap.sh` from a terminal.

Be mindful of the output, there may be some moments requiring manual intervention; for example: copying your SSH key up to Github or a password request during software installation. The script can be run directly from the terminal which will also checkout this repository to track future changes.

```
bash <(curl -s https://raw.githubusercontent.com/palo-it-hk/macbook-bootstrap/master/bootstrap.sh)
```