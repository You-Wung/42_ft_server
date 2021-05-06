FROM	debian:buster

LABEL	maintainer="tyou@student.42seoul.kr"

RUN	apt-get update && apt-get install -y \
	nginx \
	mariadb-server \
	php-mysql \
	php-mbstring \
	openssl \
	vim \
	wget \
	php7.3-fpm

COPY	./srcs/init.sh ./
COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp

EXPOSE	80 443

CMD 	bash init.sh
