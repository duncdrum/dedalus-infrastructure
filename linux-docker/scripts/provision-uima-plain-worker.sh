#
# UIMA collection worker container
#

docker kill uima-plain
docker rm uima-plain

docker build -t 0xffea/uima-plain - <<EOL
FROM ubuntu:13.10
MAINTAINER David Höppner <0xffea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i -e "s/archive/old-releases/" /etc/apt/sources.list
RUN apt-get update && apt-get -qy install		\
	git			\
	python-pika		\
	python-lxml		\
	python-pip		\
	libpython-dev		\
	openjdk-7-jre-headless

RUN useradd -m -p "uima" uima

RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale


ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/uima-plain-worker.py /home/uima/uima-plain-worker.py
RUN chmod 0755 /home/uima/uima-plain-worker.py

CMD ["/home/uima/uima-plain-worker.py"]
EOL

docker run -d --name uima-plain -e LANG="en_US.UTF-8" --link celery:rabbitmq -v /docker:/docker:rw -v /root:/root:rw -t 0xffea/uima-plain
