FROM registry.ipaymu.com/arakattack/laravel-deployer:latest

ADD . /var/www/html
COPY . /var/www/html
WORKDIR /var/www/html


RUN touch storage/logs/laravel.log
RUN composer global require hirak/prestissimo
RUN composer install
RUN php artisan cache:clear
RUN php artisan view:clear
# RUN php artisan route:cache
COPY .env.example .env
RUN php artisan key:generate
RUN php artisan config:cache
# RUN npm install
# RUN npm run prod

RUN php artisan vendor:publish --all
RUN php artisan storage:link
RUN composer  dump-autoload

RUN chmod -R 777 /var/www/html/storage



