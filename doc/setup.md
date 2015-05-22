Setup
-----

For a production setup follow these steps:

- Install [Docker](https://www.docker.com/)
- Install [Docker-Compose](https://docs.docker.com/compose/)

Then download the [docker-compose.yml](./docker-compose.yml)

	wget https://raw.githubusercontent.com/flower-pot/veterator/master/doc/docker-compose.yml

Set the environment variables under the environment section in the
`docker-compose.yml`. Setup the containers as they need to be with:

	docker-compose up -d db
	docker-compose run web rake db:setup
	docker-compose run web rake assets:precompile
	docker-compose up -d web

Then it can be started and stopped with

	docker-compose start
	docker-compose stop

