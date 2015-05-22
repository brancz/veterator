[![Build Status](https://travis-ci.org/flower-pot/veterator.svg?branch=master)](https://travis-ci.org/flower-pot/veterator)
[![Coverage Status](https://coveralls.io/repos/flower-pot/veterator/badge.svg?branch=master)](https://coveralls.io/r/flower-pot/veterator?branch=master)
[![Code Climate](https://codeclimate.com/github/flower-pot/veterator/badges/gpa.svg)](https://codeclimate.com/github/flower-pot/veterator)

veterator
=========

Veterator is a latin word for smartypants, since this application will be a
smartass to you, telling you how much electricity, water, etc. you are using.

Current status is only recording and analysing data directly with this rails
app, however, the vision is to evolve to a data warehouse like application
aggregating data in multiple dimensions.

For a production setup refer to [doc/setup.md](./doc/setup.md)

Development
-----------

To get started developing you will need to install docker, docker-compose and
clone the repo.

Then create the database container

	docker-compose up -d db

Then setup the database and environment

	docker-compose run web rake db:create
	docker-compose run web rake db:migrate

And then set the environment variables required. There is an example `.env`
file containing the required variables, you can use it as a boilerplate and set
the variables as you need them to be.

	cp .env.example .env

Then the application can be started with

	sudo docker-compose up
