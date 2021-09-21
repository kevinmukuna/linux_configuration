#!/bin/bash

# get current operating systems
OS=`uname`

read -e -p "Do you have pyenv installed ? (Y/n) :  " ANSWER
if [[ -z0 $ANSWER]] || [[ $ANSWER="Y" ]] || [[ $ANSWER='y' ]];
    then
        :
else
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src

    if [[ $OS="Linux" ]];then
        # the 4 line below has been taken from pyenv offical github account: see --> https://github.com/pyenv/pyenv
	sed -Ei -e '/^([^#]|$)/ {a \
	export PYENV_ROOT="$HOME/.pyenv"
	a \
	export PATH="$PYENV_ROOT/bin:$PATH"
	a \
	' -e ':a' -e '$!{n;ba};}' ~/.profile
	echo 'eval "$(pyenv init --path)"' >>~/.profile
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    
   if [[ $OS="Darwin" ]]; then
      # the 5 line below has been taken from pyenv offical github account: see --> https://github.com/pyenv/pyenv
      echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
      echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
      echo 'eval "$(pyenv init --path)"' >> ~/.profile
      echo 'if [ -n "$PS1" -a -n "$BASH_VERSION" ]; then source ~/.bashrc; fi' >> ~/.profile
      echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  
   if [[ $OS="Fedora" ]] || [[ $OS="CentOS" ]] || [[ $OS="Red Hat" ]]; then
       # the 5 line below has been taken from pyenv offical github account: see --> https://github.com/pyenv/pyenv
	sed -Ei -e '/^([^#]|$)/ {a \
	export PYENV_ROOT="$HOME/.pyenv"
	a \
	export PATH="$PYENV_ROOT/bin:$PATH"
	a \
	' -e ':a' -e '$!{n;ba};}' ~/.bash_profile
	echo 'eval "$(pyenv init --path)"' >> ~/.bash_profile
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
	echo 'eval "$(pyenv init --path)"' >> ~/.profile
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc
   else
       :
   fi
fi

# prompt for a name to use for this workspace
read -e -p "Enter a name for your workspace : " WORKSPACE_NAME
mkdir $WORKSPACE_NAME && cd $WORKSPACE_NAME

echo "------------Directory $WORKSPACE_NAME has been created---------------"
echo "present working directrory is :" pwd

# prompt for name to use for the virttual enviroment creation
read -e -p "Enter a name for the virtual env : " VIRTUAL_ENV_NAME

# diplay the list of python available to install with pyenv
pyenv install --list

# prompt for python version to use
read -e -p "Enter the python version of your choice from the list above(you may need to scroll up) : " VERSION

NAME=$VIRTUAL_ENV_NAME"_"$NAME$VERSION

pyenv virtualenv $VERSION $NAME

# the statement below checks if the last command was executed succesfully, else it install the python version and re-run the last command
if executed_succesfful $? -eq 0;
  then
     :
else
    pyenv install $VERSION
    pyenv virtualenv $VERSION $NAME
fi

echo "your virtualenv is created using the following name : " $NAME

# set the newly created virtual enviroment to the workspace(this should not consist of any dependecies)
# you can locate your newly worspace by cd <name_of_workspace> then run pip freeze
pyenv local $NAME

