# BJC-Teacher-Tracker

## Description

The Beauty and Joy of Computing (BJC) is an introductory computer science curriculum developed at UC Berkeley meant for high school freshmen up to college freshmen. The program has a teacher guide and a newly generated password that is to be given to any teacher who signs up for the program as a volunteer educator in the Bay Area - there are plans to expand the program to other states in late 2020. This pilot application is designed as a dashboard to track the workflow of teachers who run the program and provide high-level, descriptive statistics on the courses taught and participating schools. The BJC Teacher Tracker is a NEW project started in Fall 2019 by a group of 5 student developers in UC Berkeley's CS 169: Software Engineering. 

## Key Features and Functionality

We have worked on the adding following core features and functionality:

- Feature: A application form for prospective teachers to request access to the platform
- Functionality: Administrators are immediately notified of new applications via email
- Feature: Administrators can validate or deny applicants with a button click 
- Functionality: An email is automatically sent to successful applicants notifyin
- Feature: 
- Email automatically sent to teacher once they are validated by Admin
- Separate Admin view that uses Google Auth as a login
- Admin view contains a statistics main page with the following information: table with newly submitted forms with buttons to delete or validate, tables for statistics about the schools and the courses teachers are teaching, a map with the locations of all the school teachers are a part of, and a separate page with all the validated forms.


## Few Things to Know:

- Before running our application on localhost (default port 3000), the encrypted application.yml.asc file in the config folder needs to be unencrypted into the application.yml file. Only Michael, the current customer (ball@berkeley.edu), has the secret key to do this. 
- To add administrators to the application you have to add the person's email to the list of emails in 'self.validate_by_email'. The administrator can just log in using their email through the Google OAuth workflow we have implemented.
- For RSpec tests run '''ruby bundle exec rspec'''
- For Cucumber tests run 'bundle exec cucumber' 

## Heroku Link

- https://bjc-teacher-tracker.herokuapp.com/

### Maintainability Badge

[![Maintainability](https://api.codeclimate.com/v1/badges/ab0826b627a599c468d5/maintainability)](https://codeclimate.com/github/JananiVijaykumar/BJC-Teacher-Tracker/maintainability)

### Test Coverage Badge

[![Test Coverage](https://api.codeclimate.com/v1/badges/ab0826b627a599c468d5/test_coverage)](https://codeclimate.com/github/JananiVijaykumar/BJC-Teacher-Tracker/test_coverage)

## Travis CI Badge
[![Build Status](https://travis-ci.com/JananiVijaykumar/BJC-Teacher-Tracker.svg?branch=master)](https://travis-ci.com/JananiVijaykumar/BJC-Teacher-Tracker)
