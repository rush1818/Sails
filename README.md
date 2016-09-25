# Sails

## Overview

Sails is a MVC framework inspired by Ruby on Rails. Sails utilizes `Rack` for the HTTP request-response cycle, and `SQLite3` for database storage.

## Setup

Clone or download this repo and run `bundle install` to setup dependencies.

### Demo App

A demo app is provided which uses the Sails framework. To start the demo app:
* Run `bundle install`
* `rake db:reset`
* `ruby server`
* Navigate to `localhost:3000` in your browser

The code written for the demo app can be used as guidance to create your own app.

### Model and Controller Generator

A generator similar to the one provided by Rails is provided to handle creation of Model and Controller files. Run `ruby generate` in the terminal to generate models and controllers as follows:
* `ruby generate model cats` will generate a Cat model. Following the conventions used in Rails, all model names are singularized using `ActiveSupport`
* `ruby generate controller cats` will generate a CatsController. Following the convention used in Rails, all controller names are pluralized.

Furthermore, Sails uses a folder structure similar to Rails. Models are created under `app/models/`, controllers under `app/controllers/`, and views under `app/views/(controller_name)/`

### Database

The database, along with required tables and columns, is created by writing SQL commands in the `db/app.sql` file. The commands can be executed by running `rake db:reset` in the terminal.

### Routes
Sails uses RESTful architecture. Add routes in the `config/routes.rb` file following the convention used by the sample routes.

### Server
Start your app by running `ruby server` in the terminal and navigating to `localhost:3000` in the browser. Use `ctrl+c` in the terminal to stop the server anytime.
