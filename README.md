# BJC Teacher Tracker
![Specs Status](https://github.com/beautyjoy/BJC-Teacher-Tracker/actions/workflows/specs.yml/badge.svg) •
[![codecov](https://codecov.io/gh/beautyjoy/BJC-Teacher-Tracker/branch/master/graph/badge.svg?token=96PyjKKVzi)](https://codecov.io/gh/beautyjoy/BJC-Teacher-Tracker) • ![Rubocop Status](https://github.com/beautyjoy/BJC-Teacher-Tracker/actions/workflows/rubocop.yml/badge.svg)
---

## CS169L Badges (Delete These When Merged into Golden Repo):
![Specs Status](https://github.com/mitchell2001wong/BJC-Teacher-Tracker/actions/workflows/ci.yml/badge.svg)
<a href="https://codeclimate.com/github/mitchell2001wong/BJC-Teacher-Tracker/maintainability"><img src="https://api.codeclimate.com/v1/badges/7fb9c619d24e6996887a/maintainability" /></a>
<a href="https://codeclimate.com/github/mitchell2001wong/BJC-Teacher-Tracker/test_coverage"><img src="https://api.codeclimate.com/v1/badges/7fb9c619d24e6996887a/test_coverage" /></a>
[![Pivotal Tracker](https://github.com/mitchell2001wong/BJC-Teacher-Tracker/blob/master/app/assets/images/pivotal_tracker_logo.png)](https://www.pivotaltracker.com/n/projects/2406982)
[![Bluejay Dashboard](https://img.shields.io/badge/Bluejay-Dashboard_BJC%20Teacher%20Tracker-blue.svg)](http://dashboard.bluejay.governify.io/dashboard/script/dashboardLoader.js?dashboardURL=https://reporter.bluejay.governify.io/api/v4/dashboards/tpa-CS169L-22-GH-mitchell2001wong_BJC-Teacher-Tracker/main)
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

#### Postgres Installation (MacOS):
* `brew install postgresql chromedriver`
* Start postgres if necessary. `brew services start postgresql`
#### Postgres Installation (Linux):
* `sudo apt install postgresql`
* Create a postgres user.
  * `sudo su - postgres` (to get into postgres shell)
  * `createuser --interactive --pwprompt` (in postgres shell)
  * Save these information in `database.yml` under `default`. (`username: [username]` `password: [password]`)
* Start postgres if necessary. `pg_ctlcluster 12 main start`

#### General Installation
* `rvm use 2.7.5` # Double-check `.ruby-version`
* `bundle`
* `bin/rails db:setup` (Run this after setting up Postgres)

## Few Things to Know:

- Before running our application on localhost (`bundle exec rails server', default port 3000), the encrypted application.yml.asc file in the config folder needs to be unencrypted into the application.yml file. Only Michael, the current customer (ball@berkeley.edu), has the secret key to do this.
- For RSpec tests run `bundle exec rspec`
- For Cucumber tests run `bundle exec cucumber`
- To make someone an admin use db console access

## Deployed Site:

- https://teachers.bjc.berkeley.edu

## Steps to Deploying on Heroku

- ... create a heroku app
- `heroku buildpacks:set heroku/nodejs` # this must be the first buildpack.
- `heroku buildpacks:set heroku/ruby`
- `git remote set-url heroku https://git.heroku.com/bjc-teachers.git`
- Make your local changes and start the commit process
- `git add .`
- `git commit -m "<Message>"`
- `git push heroku master`

If bundler install runs successfully, continue with the following commands to correctly setup the PostgreSQL database on Heroku:
- `heroku run rake db:drop`
- `heroku run rake db:schema:load`
- `heroku run rake db:migrate`
- `figaro heroku:set -e production`
- `heroku open`
