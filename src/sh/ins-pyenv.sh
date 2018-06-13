#!/bin/sh

set -evu

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"'               >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"'    >> ~/.bashrc
. ~/.bashrc

pyenv -v
