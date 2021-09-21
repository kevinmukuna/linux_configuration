#!/bin/bash

read -e -p "Enter a name for your workspace : " WORKSPACE_NAME
mkdir $WORKSPACE_NAME && cd $WORKSPACE_NAME
echo "------------Directory $WORKSPACE_NAME has been created---------------"
echo "present working directrory is :" pwd

read -e -p "Enter a name for the virtual env : " VIRTUAL_ENV_NAME
#echo $VIRTUAL_ENV_NAME

pyenv install --list

read -e -p "Enter the python version of your choice from the list above(you may need to scroll up) : " VERSION

NAME=$VIRTUAL_ENV_NAME"_"$NAME$VERSION

pyenv virtualenv $VERSION $NAME

if executed_succesfful $? -eq 0;
  then
     :
else
    pyenv install $VERSION
    pyenv virtualenv $VERSION $NAME
fi

echo "your virtualenv is created using the following name : " $NAME

pyenv local $NAME
