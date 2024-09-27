# MetasPl0it Installer

**MetasPl0it Installer** is a bash script designed to automate the installation of the **Metasploit Framework** on both **Linux** and **Termux** environments. This script ensures that all necessary dependencies are installed, PostgreSQL is configured, and the Metasploit console is ready for immediate use. The script also features a colorful ASCII banner themed with the Indian tricolor.

## Features

- **Root/Sudo Privilege Check**: Ensures the script runs with appropriate permissions.
- **Environment Detection**: Automatically detects whether the script is being run on Linux or Termux.
- **Tricolor Banner**: Displays a colorful ASCII banner with the name **MetasPl0it** and author credit.
- **Termux and Linux Support**: Installs Metasploit using appropriate methods based on the environment.
- **PostgreSQL Setup**: Configures PostgreSQL with a user and database for Metasploit.
- **Automatic Launch**: Starts the Metasploit console after successful installation.

## Prerequisites

- **Linux** or **Termux** environment.
- Internet connection for downloading packages and Metasploit.
- Sufficient disk space for the installation.

## Installation Steps

1. **Download the Installer Script**:
   - Clone this repository or download the script file.
   ```bash
   git clone https://github.com/0xgh057r3c0n/MSFInstaller
   cd MSFInstaller
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x install.sh
   ```

3. **Run the Script with Sudo**:
   - Execute the script with root privileges.
   ```bash
   sudo ./install.sh
   ```

## Usage

- After the installation is complete, the script will automatically launch **msfconsole**. 
- You can start using Metasploit directly.

## Example Command

If you need to run Metasploit again after installation, simply type:
```bash
msfconsole
```

## Important Notes

- Ensure that you have a proper internet connection during the installation process.
- If you face any issues, make sure all dependencies are installed and your system is up-to-date.

## License

This project is **unlicensed**. You are free to use, modify, and distribute it as you see fit.

## Author

**G4UR4V007**
