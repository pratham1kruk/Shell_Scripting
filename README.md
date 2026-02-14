# HRMS Deployment & Backup Automation

A comprehensive shell scripting solution for deploying and managing a Flask-based Human Resource Management System (HRMS) on AWS EC2 instances with PostgreSQL and NoSQL databases, Apache2 web server configuration, and automated backup scheduling.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Backup System](#backup-system)
- [Scripts Documentation](#scripts-documentation)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🎯 Overview

This repository contains shell scripts and configurations for automating the deployment, configuration, and maintenance of an HRMS application on AWS EC2. The project includes:

- Docker containerization for PostgreSQL and NoSQL databases
- Apache2 web server setup and configuration
- Automated backup scheduling using cron jobs
- Email notification system via Brevo API
- Environment configuration management

## ✨ Features

- **Automated Deployment**: One-command setup for complete HRMS infrastructure
- **Database Management**: Dual database support (PostgreSQL + NoSQL)
- **Web Server Configuration**: Apache2 setup with optimized configurations
- **Scheduled Backups**: Automated daily backups with cron jobs
- **Email Notifications**: Brevo integration for password reset and verification
- **Docker Compose**: Containerized application management
- **Modular Scripts**: Separate scripts for different operations

## 📁 Project Structure

```
.
├── Apache2Web.sh           # Apache2 web server setup script
├── backup.sh               # Backup automation script
├── hrms.sh                 # Main HRMS deployment script
├── secret.txt              # Sensitive credentials (Brevo API key & email)
├── instruction.txt         # Setup instructions (deprecated)
├── .gitignore              # Git ignore rules
├── cron.log                # Cron job execution logs
├── data/                   # Data directory
│   ├── file1.txt
│   └── file2.txt
└── backups/                # Automated backups storage
    ├── backup_2026-01-26-16-XX-XX/
    └── [timestamped backups...]
```

## 🔧 Prerequisites

Before running the setup, ensure your system has the following:

### System Requirements
- Ubuntu/Debian-based Linux distribution
- Root or sudo privileges
- Minimum 2GB RAM
- 20GB available disk space

### Required Software
```bash
# Update package lists
sudo apt-get update

# Install Make
sudo apt-get install make -y

# Install Docker Compose
sudo apt-get install docker-compose -y
```

### Brevo Email Service
- Create a Brevo account at [https://www.brevo.com](https://www.brevo.com)
- Generate an API key from your Brevo dashboard
- Have a verified sender email address

## 📥 Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Create Backups Directory
```bash
mkdir -p backups
```

### 3. Configure Secrets
Create and configure the `secret.txt` file with your Brevo credentials:

```bash
nano secret.txt
```

Add the following content:
```
BREVO_API_KEY=your_brevo_api_key_here
BREVO_SENDER_EMAIL=your_verified_sender@example.com
```

### 4. Set Script Permissions
Grant read, write, and execution permissions to all shell scripts:

```bash
chmod 700 *.sh
```

This ensures scripts can be executed without permission errors.

## ⚙️ Configuration

### Environment Variables

Edit the respective shell scripts to configure:

- **Database Credentials**: PostgreSQL and NoSQL connection strings
- **Application Port**: Default Flask application port
- **Backup Retention**: Number of days to keep backups
- **Email Templates**: Customize notification emails

### Docker Compose Setup

Ensure your `docker-compose.yml` is properly configured with:
- Database service definitions
- Network configurations
- Volume mappings
- Environment variables

## 🚀 Usage

### First-Time Setup

For initial deployment, use the `make` command:

```bash
make setup
```

This will:
1. Install all dependencies
2. Configure Docker containers
3. Set up Apache2 web server
4. Initialize databases
5. Deploy the HRMS application

### Starting the Application

After initial setup, use Docker Compose to start services:

```bash
docker-compose up -d
```

To view logs:
```bash
docker-compose logs -f
```

### Stopping the Application

```bash
docker-compose down
```

## 🔄 Backup System

### Manual Backup

Run the backup script manually:

```bash
./backup.sh
```

### Automated Backups with Cron

Set up automated daily backups using cron jobs:

1. Open the crontab editor:
```bash
crontab -e
```

2. Add the following line for daily backups at 2 AM:
```bash
0 2 * * * /path/to/project/backup.sh >> /path/to/project/cron.log 2>&1
```

3. For weekly backups every Sunday at 3 AM:
```bash
0 3 * * 0 /path/to/project/backup.sh >> /path/to/project/cron.log 2>&1
```

4. Save and exit (in vim: press `ESC`, type `:wq`, press `ENTER`)

### Backup Naming Convention

Backups are stored with timestamps:
```
backups/backup_YYYY-MM-DD-HH-MM-SS/
```

## 📚 Scripts Documentation

### Apache2Web.sh
**Purpose**: Configures Apache2 web server for the HRMS application

**Functions**:
- Installs Apache2 and required modules
- Configures virtual hosts
- Sets up SSL certificates (if applicable)
- Enables necessary Apache modules
- Restarts Apache service

**Usage**:
```bash
./Apache2Web.sh
```

### backup.sh
**Purpose**: Creates timestamped backups of data and configurations

**Functions**:
- Archives application data
- Backs up database dumps
- Compresses backup files
- Maintains backup retention policy
- Logs backup operations

**Usage**:
```bash
./backup.sh
```

### hrms.sh
**Purpose**: Main deployment script for the HRMS application

**Functions**:
- Deploys Flask application
- Configures database connections
- Sets up environment variables
- Initializes application services
- Performs health checks

**Usage**:
```bash
./hrms.sh
```

## 🛠️ Troubleshooting

### Common Issues

#### Permission Denied Errors
```bash
# Solution: Ensure scripts have execute permissions
chmod 700 *.sh
```

#### Docker Compose Not Found
```bash
# Solution: Install Docker Compose
sudo apt-get update
sudo apt-get install docker-compose -y
```

#### Backup Directory Missing
```bash
# Solution: Create the backups directory
mkdir -p backups
```

#### Cron Jobs Not Running
```bash
# Check cron service status
sudo service cron status

# View cron logs
cat cron.log

# Ensure cron jobs are uncommented
crontab -e
```

#### Email Notifications Not Working
- Verify Brevo API key in `secret.txt`
- Check sender email is verified in Brevo
- Review application logs for API errors

### Log Files

Check the following logs for debugging:

- **Cron Logs**: `cron.log`
- **Apache Logs**: `/var/log/apache2/error.log`
- **Docker Logs**: `docker-compose logs`
- **Application Logs**: Check your Flask app logs

## 🔒 Security Considerations

1. **Never commit `secret.txt`**: Always keep it in `.gitignore`
2. **Use environment variables**: For production deployments
3. **Regular updates**: Keep Docker images and packages updated
4. **Firewall rules**: Configure AWS Security Groups properly
5. **SSL/TLS**: Use HTTPS for production environments
6. **Backup encryption**: Consider encrypting sensitive backups

## 📝 Best Practices

- Run initial setup with `make` command only once
- Use `docker-compose up` for subsequent starts
- Monitor `cron.log` regularly for backup status
- Test backup restoration periodically
- Keep backups in multiple locations (local + cloud)
- Document any custom modifications

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

Your Name - Initial work

## 🙏 Acknowledgments

- Brevo for email service integration
- Docker community for containerization support
- Apache Software Foundation for the web server
- AWS for cloud infrastructure

---

**Note**: Replace `<repository-url>`, `<repository-directory>`, and other placeholder values with your actual project information.

For additional help or questions, please open an issue on GitHub or contact the maintainer.