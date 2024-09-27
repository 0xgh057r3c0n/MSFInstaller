#!/bin/bash

# Ensure the script is run with sudo or as root
if [[ "$EUID" -ne 0 ]]; then
   echo -e "\e[31mThis script must be run as root or using sudo!\e[0m"
   exit 1
fi

# Function to display the banner with the tricolor theme (Saffron, White, Green)
display_banner() {
  echo -e "\e[38;5;208m   _____    ____________________.___ _______    _________________________  .____    .____     _____________________ \e[0m"
  echo -e "\e[38;5;208m  /     \  /   _____/\_   _____/|   |\      \  /   _____/\__    ___/  _  \ |    |   |    |    \_   _____/\______   \ \e[0m"
  echo -e "\e[97m /  \ /  \ \_____  \  |    __)  |   |/   |   \ \_____  \   |    | /  /_\  \|    |   |    |     |    __)_  |       _/ \e[0m"
  echo -e "\e[97m/    Y    \/        \ |     \   |   /    |    \/        \  |    |/    |    \    |___|    |___  |        \ |    |   \ \e[0m"
  echo -e "\e[32m\____|__  /_______  / \___  /   |___\____|__  /_______  /  |____|\____|__  /_______ \_______ \/_______  / |____|_  / \e[0m"
  echo -e "\e[32m        \/        \/      \/                \/        \/                 \/        \/       \/        \/         \/  \e[0m"
  echo -e "\e[32m##############################################################################################################\e[0m"
  echo -e "\e[32m#                                                                                                            #\e[0m"
  echo -e "\e[32m#                                        MetasPl0it by G4UR4V007                                              #\e[0m"
  echo -e "\e[32m##############################################################################################################\e[0m"
}

# Function to detect if the user is running Termux or Linux
detect_environment() {
  if [ -d "$PREFIX" ] && [ "$(uname -o)" == "Android" ]; then
    echo "Termux detected."
    return 1
  else
    echo "Linux detected."
    return 0
  fi
}

# Function to install dependencies in Termux
install_termux_dependencies() {
  echo "Installing dependencies for Termux..."
  pkg update -y
  pkg install -y unstable-repo
  pkg install -y metasploit
}

# Function to install dependencies and required gems in Linux
install_linux_dependencies() {
  echo "Installing dependencies for Linux..."

  # Install dependencies
  sudo apt update
  sudo apt install -y curl git wget gnupg2 build-essential libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev ruby-full postgresql postgresql-contrib

  # Start PostgreSQL service
  sudo service postgresql start

  # Clone Metasploit repository
  if [ ! -d "metasploit-framework" ]; then
    echo "Cloning Metasploit framework..."
    git clone https://github.com/rapid7/metasploit-framework.git
  else
    echo "Metasploit framework already cloned."
  fi

  cd metasploit-framework || { echo "Failed to enter Metasploit directory."; exit 1; }

  # Install RVM (Ruby Version Manager)
  if ! command -v rvm &> /dev/null; then
    echo "Installing RVM (Ruby Version Manager)..."
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
  fi

  # Use the correct Ruby version (if needed)
  rvm install ruby-3.1.2
  rvm use ruby-3.1.2 --default

  # Install bundler
  gem install bundler

  # Install all required gems using Bundler
  echo "Installing required Ruby gems..."
  bundle install

  # Initialize PostgreSQL database for Metasploit
  echo "Initializing PostgreSQL database for Metasploit..."
  sudo -u postgres createuser msf -P -s -e
  sudo -u postgres createdb -O msf msf_database
  echo "export MSF_DATABASE_CONFIG=$(pwd)/config/database.yml" >> ~/.bashrc

  # Copy database configuration template
  cp config/database.yml.example config/database.yml

  # Set up database configuration in Metasploit
  echo "Setting up database in Metasploit..."
  msfdb init || echo "Database initialization failed. Please check PostgreSQL settings."

  cd ..
}

# Function to start PostgreSQL and launch msfconsole
start_postgresql_and_msfconsole() {
  echo "Starting PostgreSQL..."
  
  if detect_environment; then
    # Start PostgreSQL on Linux
    sudo service postgresql start
  else
    # Start PostgreSQL on Termux
    pg_ctl -D $PREFIX/var/lib/postgresql start
  fi

  echo "Launching Metasploit..."
  msfconsole
}

# Main installation logic
install_metasploit() {
  # Display banner
  display_banner

  if detect_environment; then
    # Linux installation
    install_linux_dependencies
  else
    # Termux installation
    install_termux_dependencies
  fi

  # Start PostgreSQL and launch Metasploit console
  start_postgresql_and_msfconsole
}

# Run the installation function
install_metasploit
