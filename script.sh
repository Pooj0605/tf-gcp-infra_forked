echo "
[Unit] 
Description=My Node.js Web Application
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/webapp/webapp
User=csye6225
Group=csye6225
Environment=DB_USER=${DB_USER}
Environment=DB_PASSWORD=${DB_PASSWORD}
Environment=DB_NAME=${DB_NAME}
Environment=DB_HOST=${DB_HOST}
ExecStart=/usr/bin/node /home/webapp/webapp/app.js

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/application.service

sudo chown csye6225:csye6225 /etc/systemd/system/application.service
sudo chmod 750 /etc/systemd/system/application.service

sudo systemctl daemon-reload
sudo systemctl enable application.service
sudo systemctl start application.service
sudo systemctl status application.service