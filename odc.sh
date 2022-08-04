#!/bin/bash
cd /root/
wget "https://raw.githubusercontent.com/AjayRaj971015/devsecops/master/dc.sh"
chmod +x dc.sh
./dc.sh
echo "Reports of OWASP-Dependancy-check"
ls -l odc-reports/
echo "Displaying Reports on Apache webpage "
cp odc-reports/dependency-check-report.html /var/www/html/
systemctl restart apache2
