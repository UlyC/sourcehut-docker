#!/bin/bash
set -e
red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e "${red}$*${none}"; }
_green() { echo -e "${green}$*${none}"; }
_yellow() { echo -e "${yellow}$*${none}"; }
_magenta() { echo -e "${magenta}$*${none}"; }
_cyan() { echo -e "${cyan}$*${none}"; }

modules="metasrht"
domain_name="http://localhost"

function add_module() {
  read -r input
  echo
  if [[ "$input" -le 1 ]]; then
    modules=$modules" "$1
    echo -e "$yellow $1 is selected${none}"
  fi
}


# Git or Mercurial or Both
echo -e "Select your distributed version control system ${cyan}1.Git${none} or ${cyan}2.Mercurial${none} or ${cyan}3.Both${none}?"
read -r version_control_system_input
echo

if [[ "$version_control_system_input" -le 1 ]]; then
  module="git.sr.ht"
  modules=$modules" "$module
  echo -e "$yellow $module is selected${none}"
elif [[ "$version_control_system_input" -le 2 ]]; then
  module="hg.sr.ht"
  modules=$modules" "$module
  echo -e "$yellow  $module is selected${none}"
else
  module="git.sr.ht hg.sr.ht"
  modules=$modules" "$module
  echo -e "$yellow $module are selected${none}"
fi

# Domain
echo -e "Set your ${cyan} Domain name ${none} or ${cyan}s (skip)${none}?"
read -r domain_input
echo
if [[ "$domain_input" == 's' ]] || [[ -z "$null" ]]; then
  echo -e "$yellow skip${none}"
else
  domain_name=$domain_input
fi

# CI
# builds.sr.ht

echo -e "Do you want to use ${cyan} Sourcehut CI ${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
add_module "builds.sr.ht"

echo -e "Do you want to use ${cyan}Mailing list service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
add_module "lists.sr.ht"

#  a wiki service
#  man.sr.ht
echo -e "Do you want to use ${cyan}Wiki service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
add_module "man.sr.h"

# Syntax highlighting
# paste.sr.ht
echo -e "Do you want to use ${cyan}Syntax highlighting${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
add_module "paste.sr.ht"

# issue and bug tracker service
#  todo.sr.ht
echo -e "Do you want to use ${cyan}issue and bug tracker service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
add_module "todo.sr.ht"
echo
echo

echo -e "---------------------------${green}Start generate Dockerfile ${none}--------------------------------------"
echo
echo
sed "s/{{MODULES}}/$modules/" ./template/Dockerfile.template >Dockerfile
# TODO start.sh
echo
echo
echo -e "---------------------------${green}Generate Dockerfile success${none}--------------------------------------"

## build base image
#
#echo -e "---------------------------${green}Start build base image ${none}--------------------------------------"
#docker build -t sr.ht-base:dev ./base/
#echo
#echo -e "---------------------------${green}Build base image success${none}--------------------------------------"

## generate keys

echo -e "---------------------------${green}Start  generate  keys${none}-----------------------------------------"
echo
echo
docker run sr.ht-base:dev sh -c 'srht-keygen service && srht-keygen network && srht-keygen webhook' | awk '{n[1]="Service";n[2]="Network";n[3]=n[4]="Webhook";print n[NR]" "$0 > "genkeys"}'
echo
echo
echo -e "$(<genkeys)"
echo -e "${yellow}Distribute the webhook public key to anyone who would want to verify ${none}"
echo -e "${yellow}webhook payloads from your service.${none}"
echo -e "${yellow}you can see generated keys in the  'genkeys' file ${none}"
echo
echo
echo -e "---------------------------${green}Generate keys success${none}-----------------------------------------"
echo
echo

## generate config
echo -e "---------------------------${green}Start  generate  config${none}---------------------------------------"
echo
echo
service_key=$(<genkeys  grep Service | awk -F: '{print $2}')
network_key=$(<genkeys  grep Network | awk -F: '{print $2}')
webhook_key=$(<genkeys  grep Webhook | awk -F: 'BEGIN{print $2}')
sed "s/{{SERVICE_KEY}}/$service_key/" ./template/config.ini.template > config.ini
sed -i "s/{{NETWORK_KEY}}/$network_key/" config.ini
sed -i "s/{{WEBHOOK_KEY}}/$webhook_key/" config.ini
echo "$domain_name"
sed -i "s@{{DOMAIN}}@$domain_name@" config.ini
echo
echo
echo -e "---------------------------${green}Generate keys success${none}-----------------------------------------"

# TODO modules config
