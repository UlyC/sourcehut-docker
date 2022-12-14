#!/bin/bash
#======================================
#   Author: ulyc
#======================================
set -eo pipefail

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

local_domain="localtest.me"
domain_name="${local_domain}"
modules=""
#meta_module="meta.sr.ht"
git_module="git.sr.ht"
hg_module="hg.sr.ht"
build_module="builds.sr.ht"
list_module="lists.sr.ht"
man_module="man.sr.ht"
paste_module="paste.sr.ht"
todo_module="todo.sr.ht"

function add_module() {
  read -r input
  echo
  if [[ "$input" -le 1 ]]; then
    modules=$modules" "$1
    echo -e "$yellow $1 is selected${none}"
  fi
}

function progress() {
  echo "$2 IS RUNNING..."
  printf "[▓"
  while kill -0 "$1" 2>/dev/null; do
    printf "▓"
    sleep 0.05
  done
  wait "$1"
  printf "▓] done!"
}

function generate_config() {
  service_key=$(grep <genkeys "Service" | awk -F: '{gsub(/[[:blank:]]*/,"");print $2}')
  network_key=$(grep <genkeys "Network" | awk -F: '{gsub(/[[:blank:]]*/,"");print $2}')
  webhook_key=$(grep <genkeys "Webhook Private" | awk -F: '{gsub(/[[:blank:]]*/,"");print $2}')
  sed -i "s/{{SERVICE_KEY}}/$service_key/" config.ini
  sed -i "s/{{NETWORK_KEY}}/$network_key/" config.ini
  sed -i "s@{{WEBHOOK_KEY}}@$webhook_key@" config.ini
  sed -i "s@{{DOMAIN}}@$domain_name@" config.ini
}

function generate_keys() {
  docker run sr.ht-base:dev sh -c 'srht-keygen service && srht-keygen network && srht-keygen webhook' | awk '{n[1]="Service";n[2]="Network";n[3]=n[4]="Webhook";print n[NR]" "$0 > "genkeys"}'
}

function build_base_image() {
  docker build -t sr.ht-base:dev ./base/ && echo
}


function set_domain() {
  sed "s@$local_domain@$domain_name@g" template/config.ini.template >config.ini
  sed -i "s/$local_domain/srht/g" "grep -rl $local_domain nginx_conf"
}

function select_version_control() {
  # Git or Mercurial or Both
  echo -e "Select your distributed version control system ${cyan}1.Git${none} or ${cyan}2.Mercurial${none} or ${cyan}3.Both${none}?"
  read -r version_control_system_input
  echo

  if [[ "$version_control_system_input" -le 1 ]]; then
    modules=$modules" "$git_module
    echo -e "$yellow $modules is selected${none}"
  elif [[ "$version_control_system_input" -le 2 ]]; then
    modules=$modules" "$hg_module
    echo -e "$yellow  $modules is selected${none}"
  else
    modules=$modules' '$git_module' '$hg_module
    echo -e "$yellow $modules are selected${none}"
  fi
}

function advance_config() {
  # CI
  # builds.sr.ht

  echo -e "Do you want to use ${cyan} Sourcehut CI ${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
  add_module "$build_module"

  echo -e "Do you want to use ${cyan}Mailing list service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
  add_module "$list_module"

  # wiki service
  #  man.sr.ht
  echo -e "Do you want to use ${cyan}Wiki service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
  add_module "$man_module"

  # issue and bug tracker service
  # todo.sr.ht
  echo -e "Do you want to use ${cyan}issue and bug tracker service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
  add_module "$todo_module"

  # Syntax highlighting
  # paste.sr.ht
  echo -e "Do you want to use ${cyan} ad-hoc text file service${none}? ${cyan}1.Yes${none} or ${cyan}2.No${none}?"
  add_module "$paste_module"
}

function select_mode() {
  min_mode="Minimal Installation(Install only required modules)"
  max_mod="Maximize Installation(Install all modules)"
  adv_mod="Advanced Mode(Choose your own personalized modules)"
  quit="Quit"
  mode=("$min_mode" "$max_mod" "$adv_mod" "$quit")
  PS3="Select the installation mode: "
  select item in "${mode[@]}"; do
    case $item in
    "$min_mode")
      echo "$item"
      select_version_control
      break
      ;;
    "$max_mod")
      echo "$item"
      modules=$modules"$git_module $hg_module $build_module $list_module $man_module $paste_module $todo_module"
      break
      ;;
    "$adv_mod")
      echo "$item"
      advance_config
      break
      ;;
    "$quit")
      exit
      ;;
    quit)
      break
      ;;
    *)
      echo "Invalid option $REPLY"
      ;;
    esac
  done
}

## Start
select_mode

# Set Domain
echo -e "Set your ${cyan} Domain name (no http(s) prefix )${none} or ${cyan}s (skip) to use localhost${none}?"
read -r domain_input
echo
echo "domain_input :$domain_input"
if [[ "$domain_input" == 's' || -z "$domain_input" ]]; then
  echo -e "$yellow skip${none}"
  cp template/config.ini.template  config.ini
else
  domain_name=$domain_input
  set_domain
fi

echo "domain:  $domain_name"
echo
echo
#generate_launch_shell "$modules" &
#progress $! "🤖 Generate Launch Shell"


echo
echo
sed "s/{{MODULES}}/$modules/" ./template/Dockerfile.template >Dockerfile &
progress $! "🐋 Generate Dockerfile"

echo
echo
db_names=$(echo "$modules" | tr -d '.' | tr " " "," )
sed "s/{{database_name}}/$db_names/" ./template/docker-compose.yml.template >docker-compose.yml &
progress $! "🐋 Generate DockerCompose file"

echo
echo
build_base_image &
progress $! "🐋 Build Base Image"

echo
echo
generate_keys &
progress $! "🔒 Generate Keys"
echo
echo
echo -e "$(<genkeys)"
echo -e "${yellow}Distribute the webhook public key to anyone who would want to verify ${none}"
echo -e "${yellow}webhook payloads from your service.${none}"
echo -e "${yellow}you can see generated keys in the  'genkeys' file ${none}"

echo
echo
generate_config
progress $! "🔧 Generate Config"
echo
echo


