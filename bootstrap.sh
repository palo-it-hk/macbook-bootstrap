#!/usr/bin/env bash

GIT_REPO_PREFIX=git@github.com:palo-it-hk/
# Use simplified names. "tech-excellence-flutter" "hubspot-palo-it-web"
PROJECTS_TO_CHECKOUT=("learning-web-1-basic-html-css" "macbook-bootstrap")
WORKSPACE_PATH="$HOME/palo-it"
# See sdk list java for options
JAVA_MANAGED=FALSE
JAVA_VERSION=17.0.3-tem
# lowercase LTS name only 
NODE_LTS_NAME=fermium
# Exact version string
PYTHON_VERSION=3.9.12
RUBY_VERSION=3.1.2
RUBY_MANAGED=FALSE

# Check whether an application is available
exists()
{
  if command -v $1 &>/dev/null
  then
    return 0
  else
    return 1
    fi
}

# Check that a command exists
app_exists_or_exit() {
  if command -v $1 &>/dev/null
  then
    echo "$1 found"
  else
    echo "$1 not found, exiting"
    exit
    fi
}

# Checkout project from set org 
checkout_project() {
    echo "Trying to checkout $1"
    cd $WORKSPACE_PATH
    [ -d ./$1 ] ||  git clone $GIT_REPO_PREFIX$1.git
    cd -
}

# Wait untilis reachable using netcat
wait_for_port() {
    echo "Waiting for Port ($1) $2"
    while ! nc -z localhost $1
    do
        echo -ne .
        sleep 3
    done
}

echo 'Palo IT Macbook bootstrap'
echo 'This script will prepare your device for web development according to Palo IT common agreed standards'

[ -d ~/.ssh ] || mkdir -p ~/.ssh
[ -d ~/.nvm ] || mkdir ~/.nvm
[ -d $WORKSPACE_PATH ] || mkdir $WORKSPACE_PATH

echo ''
echo 'Setting up SSH key'
if [ -f ~/.ssh/paloit_github ]; then
    echo 'SSH key already exists'
else
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/paloit_github -N ""
    if grep -Fxq "paloit_github" ~/.ssh/config
    then
        echo 'Githb SSH rule already set'
    else
        cat >>~/.ssh/config << END
Host github.com
	IdentityFile ~/.ssh/paloit_github
END
    fi
fi
echo 'Public key contents to be used on Github'
echo ''
cat ~/.ssh/paloit_github.pub
echo ''
echo 'Make sure the above SSH key is present on your Github profile'
read -p "Press enter to continue"

echo ''
echo 'Setting terminal profile'
if grep -Fxq "# START PALOIT" ~/.zshrc
    then
        echo 'Rules already set'
    else
        echo 'Rules not yet set'
        cat >>~/.zshrc << END
#
# START PALOIT
#
# Set an acceptable locale for some of the CLI programs
export LC_ALL="en_US.UTF-8"
#
# Homebrew symlinked binaries
export PATH="/usr/local/sbin:$PATH"
# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
#
# END PALOIT
#
END
fi
source ~/.zshrc

echo ''
echo 'Setting up Homebrew'
if exists brew
then
    echo 'Already installed'
    brew upgrade
else
    echo 'Installing homebrew'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew doctor

echo ''
echo 'Setting up services from brew'
brew install \
    jq \
    nginx \
    nvm \
    postgresql

echo ''
echo 'Setting up graphical applications from brew'
brew install --cask \
  dbeaver-community \
  docker \
  insomnia \
  keepassxc \
  miro \
  openvpn-connect \
  shottr \
  stoplight-studio \
  visual-studio-code

if [ JAVA_MANAGED == TRUE ]
then
  echo ''
  echo 'Java setup ($JAVA_VERSION) through sdkman'
  curl -s "https://get.sdkman.io" | bash
  sed -i '' \
    's/sdkman_auto_env=false/sdkman_auto_env=true/g' \
    ~/.sdkman/etc/config && \
  sed -i '' \
    's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' \
    ~/.sdkman/etc/config

  sdk install java $JAVA_VERSION && \
  sdk install gradle && \
  java -version

fi

if exists npm
then
    echo 'Node already setup'
else
    echo "Installing Node $NODE_LTS_NAME"
    nvm install --lts=$NODE_LTS_NAME
    nvm alias default lts/$NODE_LTS_NAME
fi

if [ PYTHON_MANAGED == TRUE ]
then
  echo ''
  echo "Python setup (${PYTHON_VERSION}) through pyenv."
  brew install pyenv
  if grep -Fxq "# START PYTHON" ~/.zshrc
    then
        echo 'Rules already set'
    else
        echo 'Rules not yet set'
        cat >>~/.zshrc << END
# START PYTHON
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi
# END PYTHON
END
  fi
  source ~/.zshrc
  pyenv install $PYTHON_VERSION
  pyenv global $PYTHON_VERSION
fi

if [ RUBY_MANAGED == TRUE ]
then
  echo ''
  echo "Ruby setup (${RUBY_VERSION}) through rbenv."
  brew install rbenv
  if grep -Fxq "# START RUBY" ~/.zshrc
    then
        echo 'Rules already set'
    else
        echo 'Rules not yet set'
        cat >>~/.zshrc << END
# START RUBY
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi
END
  fi
  source ~/.zshrc
  rbenv install $RUBY_VERSION
  rbenv global $RUBY_VERSION
fi

echo ''
echo 'Checking out all projects'
git config --global url."git@github.com:".insteadOf "https://github.com/"
for str in ${PROJECTS_TO_CHECKOUT[@]}; do
  checkout_project $str
done