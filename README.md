# BJC-Teacher-Tracker

## Description

BJC is an introduction to computer science curriculum developed at UC Berkeley and is meant mainly for high school teachers. They have a teacher guide that is to be given to any teacher that signs up for the program, and it requires a password that is emailed to them. This BJC Teacher Tracker is a NEW project, started in Fall 2019 by a group of students in CS 169. The main features that the app has currently are as follows:

- Signup form for prospective teachers to request access
- Email automatically sent to Admin when teacher signs up
- Email automatically sent to teacher once they are validated by Admin
- Separate Admin view that uses Google Auth as a login
- Admin view contains a statistics main page with the following information: table with newly submitted forms with buttons to delete or validate, tables for statistics about the schools and the courses teachers are teaching, a map with the locations of all the school teachers are a part of, and a separate page with all the validated forms.

## Few Things to Know:

- Before being able to run our app locally, the encrypted application.yml.asc file in the config folder needs to be unencrypted into the application.yml file. Michael (the customer for this product) has the secret key to do this. 
- To add admins to the app: In the admins model, you have to add the admin's email to the list of emails in self.validate_by_email. Then admin can just log in using their email through the google auth flow we have implemented.
- To run rspec tests, run: bundle exec rspec

## Heroku Link

- https://bjc-teacher-tracker.herokuapp.com/

### Maintainability Badge

[![Maintainability](https://api.codeclimate.com/v1/badges/ab0826b627a599c468d5/maintainability)](https://codeclimate.com/github/JananiVijaykumar/BJC-Teacher-Tracker/maintainability)

### Test Coverage Badge

[![Test Coverage](https://api.codeclimate.com/v1/badges/ab0826b627a599c468d5/test_coverage)](https://codeclimate.com/github/JananiVijaykumar/BJC-Teacher-Tracker/test_coverage)

## Travis CI Badge
[![Build Status](https://travis-ci.com/JananiVijaykumar/BJC-Teacher-Tracker.svg?branch=master)](https://travis-ci.com/JananiVijaykumar/BJC-Teacher-Tracker)
