# BJC-Teacher-Tracker

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

* `brew install postgresql chromedriver`
* `rvm use 2.6.5` # Double-check `.ruby-version`
* `bundle`
* Start postgres if necessary. `brew services start postgresql`
* `bin/rails db:setup`

## Few Things to Know:

- Before running our application on localhost (`bundle exec rails server', default port 3000), the encrypted application.yml.asc file in the config folder needs to be unencrypted into the application.yml file. Only Michael, the current customer (ball@berkeley.edu), has the secret key to do this.
- To add administrators to the application you have to add the person's email to the list of emails in the environment variable `ADMIN_EMAILS`, which is separated by comma.
- For RSpec tests run `bundle exec rspec`
- For Cucumber tests run `bundle exec cucumber`

## Deployed Site:

- https://teachers.bjc.berkeley.edu

## Steps to Deploying on Heroku

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

### Maintainability Badge

[![Maintainability](https://api.codeclimate.com/v1/badges/ca4948c3dbe825709c3e/maintainability)](https://codeclimate.com/github/beautyjoy/BJC-Teacher-Tracker/maintainability)

### Test Coverage Badge

[![Test Coverage](https://api.codeclimate.com/v1/badges/ca4948c3dbe825709c3e/test_coverage)](https://codeclimate.com/github/beautyjoy/BJC-Teacher-Tracker/test_coverage)

## Travis CI Badge
[![Build Status](https://travis-ci.com/beautyjoy/BJC-Teacher-Tracker.svg?branch=master)](https://travis-ci.com/beautyjoy/BJC-Teacher-Tracker)
