# SSH Brute-Force Log Analyzer

**Hello!** I recently finished learning about Bash scripting, and I did this project as an application of what I learnt.

## What does this script do?
This is a simple Bash script that parses SSH authentication logs and identifies potential brute-force attacks. It displays an alert message if an IP exceeds a specified threshold of failed login attempts.

## Features
* **Customize threshold:** You can adjust how many failed attempts it takes to trigger an alert (the default is 5).
* **Text processing:** It uses standard Linux tools like `grep`, `sort`, and `uniq` to process logs quickly.
* **RegEx logic:** It uses Regular Expressions to accurately extract the IPv4 addresses from the logs.
* **Error handling:** It tells you if you forgot a file, don't have read permissions, and exits cleanly if you hit ``Ctrl+C``.

## How to use it

**1. Make the script executable**  
Before running it for the first time, give it permission to run:
```bash
chmod +x log-analyzer.sh
```

**2. Run it**  
The basic way to run it is by giving it a log file to look at:
```bash
./log-analyzer.sh auth.log
```

**3. Change the threshold**   
You can customize the threshold as you wish, but the default is 5.

## Test Data Included
* If you want to test this script, I've included a sample auth.log file in this repo. 
* The sample is taken from [Elastic Examples Github Repo](https://github.com/elastic/examples/blob/master/Machine%20Learning/Security%20Analytics%20Recipes/suspicious_login_activity/data/auth.log) to simulate real-world attacks.

