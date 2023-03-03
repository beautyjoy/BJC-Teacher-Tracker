# BJC Teacher Tracker
Sp23 Badges:

[![Build & Rspec & Cucumber](https://github.com/cs169/BJC-Teacher-Tracker/actions/workflows/specs.yml/badge.svg)](https://github.com/cs169/BJC-Teacher-Tracker) •
[![Robocop](https://github.com/cs169/BJC-Teacher-Tracker/actions/workflows/rubocop.yml/badge.svg)](https://github.com/cs169/BJC-Teacher-Tracker) •
[![Maintainability](https://api.codeclimate.com/v1/badges/9bedc69e2aa0c0b704cd/maintainability)](https://codeclimate.com/github/cs169/BJC-Teacher-Tracker/maintainability) •
[![Test Coverage](https://api.codeclimate.com/v1/badges/9bedc69e2aa0c0b704cd/test_coverage)](https://codeclimate.com/github/cs169/BJC-Teacher-Tracker/test_coverage)

---

Previous Badges:

![Specs Status](https://github.com/beautyjoy/BJC-Teacher-Tracker/actions/workflows/specs.yml/badge.svg) •
[![codecov](https://codecov.io/gh/beautyjoy/BJC-Teacher-Tracker/branch/master/graph/badge.svg?token=96PyjKKVzi)](https://codecov.io/gh/beautyjoy/BJC-Teacher-Tracker) • ![Rubocop Status](https://github.com/beautyjoy/BJC-Teacher-Tracker/actions/workflows/rubocop.yml/badge.svg)

---

## Description

The Beauty and Joy of Computing (BJC) is an introductory computer science curriculum developed at UC Berkeley meant for high school freshmen up to college freshmen. The program has a teacher guide and a newly generated password that is to be given to any teacher who signs up for the program as a volunteer educator in the Bay Area - there are plans to expand the program to other states in late 2020. This pilot application is designed as a dashboard to track the workflow of teachers who run the program and provide high-level, descriptive statistics on the courses taught and participating schools. The BJC Teacher Tracker is a NEW project started in Fall 2019 by a group of 5 student developers in UC Berkeley's CS 169: Software Engineering.

## Key Features and Functionality

We have worked on the adding following core features and functionality:

- Feature: A application form for prospective teachers to request access to the platform
- Functionality: Administrators are immediately notified of new applications via email
- Feature: Administrators can validate or deny applicants with a button click
- Functionality: An email is automatically sent to successful applicants notifying them of their acceptance to the teaching program
- Feature: A separate administrators' view that uses Google OAuth to allow logins from UC Berkeley-registered users (@berkeley.edu)
- Functionality: Administrators can login to the dashboard to view unvalidated applications, statistics on validated applicants, and a list of current teachers
- Feature: The administrators' view contains a main page with
  - buttons to delete or validate newly submitted forms
  - tables for statistics about the schools and the courses current teachers are teaching
  - a map with the locations of all the schools that teachers are a part of
  - a separate page with all the validated teachers and their information

## Installation:

### Environmental Variable
* We are not using `application.yml` (rails env framework). Instead, we use a `.env` file at directory root to load all env vars. Use `.env.example` as a reference for env format.
* Use tools like [overmind](https://github.com/DarthSim/overmind) or [foreman](https://github.com/ddollar/foreman) to load in the env vars.
* You probably need to configure your own oauth keys and database name/passwords.

### Postgres Installation

#### MacOS:
* `brew install postgresql chromedriver`
* Start postgres if necessary. `brew services start postgresql`

#### Linux/WSL:
* `sudo apt install postgresql`
* Create a postgres user.
  * `sudo su - postgres` (to get into postgres shell)
  * `createuser --interactive --pwprompt` (in postgres shell)
  * Save `DB_USER` and `DB_PASSWORD` fields in the `.env` file.
* Start postgres if necessary. `pg_ctlcluster 12 main start`
  * Note: if you are using WSL2 on windows, the command to start postgres is `sudo service postgresql start`

### Framework/Gem Installation
* `rvm use 2.7.7` # Double-check `.ruby-version`
* `bundle`
* `bin/rails db:setup` (Run this after setting up Postgres)
* `nvm install 14` Node v14 is needed
* `yarn install` Yarn is needed

### Spin Up Server
* Use tools like [overmind](https://github.com/DarthSim/overmind) or [foreman](https://github.com/ddollar/foreman) to boot up server with env vars loaded.
* If you are using `overmind`, you can simply `npm run dev`.

### Available Commands
- For RSpec tests run `bundle exec rspec`
- For Cucumber tests run `bundle exec cucumber`
- For Rubocop check run `bundle exec rubocop` (Autocorrect all with `bundle exec rubocop -A`)
- To make someone an admin use db console access
  - First run `heroku pg:psql` or `psql bjc_teachers_dev`
  - Then
    ```
    UPDATE teachers
    SET admin = true
    WHERE Email LIKE '%@berkeley.edu%'
    ;
    ```

## JavaScript and CSS with Webpack

* `stylesheet_pack_tag` doesn't work. :(
* Use `import '*.scss' in a _JavaScript file, and webpack will compile correctly
* If you need a new CSS-only import, make a new CSS *and* a new JS file.

## Deployed Site:

- https://teachers.bjc.berkeley.edu

## Steps to Deploying on Heroku

- ... create a heroku app
- `heroku buildpacks:set heroku/nodejs` # this must be the first buildpack.
- `heroku buildpacks:add --index 2 heroku/ruby`
- `git remote set-url heroku https://git.heroku.com/bjc-teachers.git`
- Make your local changes and start the commit process
- `git add .`
- `git commit -m "<Message>"`
- `git push heroku master`

If bundler install runs successfully, continue with the following commands to correctly setup the PostgreSQL database on Heroku:
- `heroku addons:create heroku-postgresql`
- `heroku run rake db:drop`
- `heroku run rake db:schema:load`
- `heroku run rake db:migrate`
- `figaro heroku:set -e production`
- `heroku open`
