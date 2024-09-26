#!/bin/bash
#deploy-check

CURRENT_BRANCH="deploy-main-frontend"
WS_PORT=9002
PREFIX=""
SUFIX=""
APP_URL=https://api.lionclub.mx
REDIS_QUEUE=default
WS_REDIS_DB=6

# Check if a name parameter is provided
if [ ! -z "$1" ] && [ "$1" != "deploy-main-frontend" ]; then
  WS_PORT=9003
  PREFIX="test-"
  SUFIX="-test"
  CURRENT_BRANCH=$1
  APP_URL=https://apitest.lionclub.mx
  REDIS_QUEUE=test
  WS_REDIS_DB=7
fi

echo "==============="
echo "BRANCH:$CURRENT_BRANCH"
echo "==============="

PROJECT_NAME=divulgatium-backend${SUFIX}
WWW_FOLDER=/var/www
REPO_FOLDER_BASE=/opt/sync
REPO_FOLDER=$REPO_FOLDER_BASE/$PROJECT_NAME
SERVER_FOLDER=$WWW_FOLDER/$PROJECT_NAME
APP_FOLDER=$SERVER_FOLDER/public/app
LOGS_FOLDER=$SERVER_FOLDER/storage/logs
REPO_CREDS=$(cat /root/.creds/repo)
REPO_USER=l1br3th1nk3r
DB_PASSWORD=db-p@55w0rd/*
FPM_SERVICE=$(systemctl list-unit-files --type=service | grep 'php.*fpm' | awk '{ print $1 }' | cut -d. -f1-2)
WS_SECRET=$(pwgen -scn 40 1)
SUPERVISOR_SERVICE_QUEUE=${PREFIX}divulgatium-queue
SUPERVISOR_SERVICE_WSS=${PREFIX}divulgatium-wss

export COMPOSER_ALLOW_SUPERUSER=1

#install required packages
apt install pwgen supervisor liblockfile-bin

dotlockfile -l -r 0 -p $SERVER_FOLDER/file.lock || exit

mkdir -p $SERVER_FOLDER/app/
mkdir -p $LOGS_FOLDER

git config --global user.name "Software Architect"
git config --global user.email "l1br3th1nk3r@gmail.com"

mkdir -p $REPO_FOLDER_BASE
cd $REPO_FOLDER_BASE

if [ -d "$REPO_FOLDER/.git" ]
then
    chown root.root -R $REPO_FOLDER
    cd $REPO_FOLDER
    echo "== Sync Repo =="
    echo "$REPO_FOLDER"
    git pull
else
    echo "== Create Repo =="
    echo "$REPO_FOLDER"
    git clone https://$REPO_CREDS@github.com/pedrokeilerbatistarojo/divulgatium.git $REPO_FOLDER
    cd $REPO_FOLDER
fi


#wget -c https://getcomposer.org/download/latest-stable/composer.phar
#chmod +x composer.phar
#mv composer.phar /usr/local/bin/composer

composer self-update

if [ $? -ne 0 ]; then
    echo "Error with repo sync"
    exit 1
fi

git checkout $CURRENT_BRANCH
if [ $? -ne 0 ]; then
    echo "Error changing branch"
    exit 1
fi

#sync confs
#todo nginx config test
#cp $REPO_FOLDER/docs/deploy/nginx/sites-available/${PREFIX}divulgatium-backend.conf /etc/nginx/sites-available/${PREFIX}divulgatium-backend
rsync -avr --delete --exclude 'file.lock' --exclude '.git' --exclude 'vendor' --exclude 'var/' --exclude 'storage'  $REPO_FOLDER/app-backend/ $SERVER_FOLDER/

cd $SERVER_FOLDER
mkdir -p storage/app/{public,transactions}
mkdir -p storage/logs/
mkdir -p storage/framework/{cache,sessions,testing,views}

#if [ ! -d "$SERVER_FOLDER/vendor" ]
#then
#  composer i
#fi

echo "
APP_NAME=$PROJECT_NAME
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=$APP_URL

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=divulgatium-app$SUFIX
DB_USERNAME=divulgatium-app
DB_PASSWORD=$DB_PASSWORD

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_LIFETIME=120
SESSION_CONNECTION=${PREFIX}session

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
REDIS_QUEUE=$REDIS_QUEUE
REDIS_CACHE_CONNECTION=${PREFIX}cache

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=hello@example.com
MAIL_FROM_NAME=\"\${APP_NAME}\"

WS_URL=ws://localhost:$WS_PORT
WS_SECRET=$WS_SECRET
WS_REDIS_DB=$WS_REDIS_DB

" > .env

composer install --optimize-autoloader #--no-dev

# Storage
php artisan storage:link

# JWT
php artisan key:generate
php artisan jwt:secret
php artisan config:clear

#Sync with view
php artisan config:clear
php artisan cache:clear
php artisan view:clear

#Swagger generator
#php artisan l5-swagger:generate

#supervisorctl restart all

chown -R www-data.www-data $WWW_FOLDER
chown -R www-data.www-data $SERVER_FOLDER/

chmod -R 775 storage
chmod -R 775 bootstrap/cache

echo "
[program:$SUPERVISOR_SERVICE_QUEUE]
directory=$SERVER_FOLDER
process_name=%(program_name)s_%(process_num)02d
command=php artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=8
redirect_stderr=true
stdout_logfile=$LOGS_FOLDER/queue-worker.log
stopwaitsecs=3600

" > /etc/supervisor/conf.d/$PROJECT_NAME.conf

supervisorctl update
supervisorctl restart $SUPERVISOR_SERVICE_QUEUE:*
#supervisorctl restart $SUPERVISOR_SERVICE_WSS:*

# Queues
php artisan queue:restart

# Database sync
if [ "$1" == "deploy-dev-backend" ]; then
  php artisan migrate:fresh --seed
else
  php artisan migrate
fi


mkdir -p $SERVER_FOLDER
dotlockfile -u $SERVER_FOLDER/file.lock
cd ~

# Restart web service
service $FPM_SERVICE restart
service nginx restart

#See status with
systemctl status mariadb
systemctl status $FPM_SERVICE
systemctl status nginx
