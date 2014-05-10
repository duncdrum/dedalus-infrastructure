#
# Postgres container
#

docker kill django
docker kill fuseki
docker kill existdb
docker kill postgres

docker ps -a | grep Exit | awk '{print $1}' | sudo xargs docker rm

docker rmi -f 0xffea/saucy-server-django
docker rmi -f 0xffea/saucy-server-postgres
docker rmi -f 0xffea/saucy-server-fuseki
docker rmi -f 0xffea/saucy-server-existdb

docker build -t 0xffea/saucy-server-postgres - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -qy install		\
	postgresql

EXPOSE 5432

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-postgres.sh /root/start-postgres.sh
RUN chmod 0755 /root/start-postgres.sh

CMD ["/root/start-postgres.sh"]
EOL

docker run -d --name postgres -p 5432:5432 -v /docker:/docker:rw -t 0xffea/saucy-server-postgres
