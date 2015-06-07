[![Build Status](https://travis-ci.org/flower-pot/veterator.svg?branch=master)](https://travis-ci.org/flower-pot/veterator)
[![Test Coverage](https://codeclimate.com/github/flower-pot/veterator/badges/coverage.svg)](https://codeclimate.com/github/flower-pot/veterator/coverage)
[![Code Climate](https://codeclimate.com/github/flower-pot/veterator/badges/gpa.svg)](https://codeclimate.com/github/flower-pot/veterator)

veterator
=========

Veterator is a latin word for smartypants, since this application will be a
smartass to you, telling you how much electricity, water, etc. you are using.

Current status is only recording, aggregating and visualizing data directly
with this rails app, however, the vision is to evolve to a time series forecast
application.

For a production setup refer to [doc/setup.md](./doc/setup.md)

Producers
---------

This webapp does not do much by itself. It requires producers adding data. Once
the data is received by this webapp, it is aggregated and can be viewed by
browsing to it.

You can either look at examples from the
[/doc/producer-examples](doc/producer-examples) folder or take a look at the
`Advanced Settings` subsection of any sensor.

Development
-----------

###postgres

Although sqlite is easier and faster to setup, it is recommended to use
postgres as it is what is used in production. To setup the dev environment with
postgres follow these instructions.

To get started developing you will need to install docker, docker-compose and
clone the repo.

Then create the database container

	docker-compose up -d db

Then setup the database and environment

	docker-compose run web rake db:migrate

And then set the environment variables required. There is an example `.env`
file containing the required variables, you can use it as a boilerplate and set
the variables as you need them to be.

	cp .env.example .env

Then the application can be started with

	docker-compose up

And tests executed with

	docker-compose run web rake

###sqlite

It is only recommended to use sqlite if you want to take a quick look at the
project. Generally [postgres](#postgres) is preferred.

To setup the application for development with sqlite follow these steps.

Install the required gems

	bundle install --without pg

Override the `database.yml` with the sqlite config.

	cp config/database.yml.sqlite config/database.yml

Setup

	rake db:setup RAILS_ENV=test

Run tests

	rake
