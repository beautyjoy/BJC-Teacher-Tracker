# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
teachers = [{:first_name => "Janani", :last_name => "Vijaykumar", :email => "janani_vijaykumar@berkeley.edu", :school_name => "Monta Vista High School",
:city => "Cupertino", :state => "CA", :website => "https://mvhs.fuhsd.org", :course => "I am teaching BJC as an AP CS Principles course.",
:snap => "N/A", :other => "N/A"},

{:first_name => "Kimberly", :last_name => "Zhu", :email => "kpzhu@berkeley.edu", :school_name => "Cupertino High School",
:city => "Cupertino", :state => "CA", :website => "https://chs.fuhsd.org", :course => "I am teaching BJC but not as an AP CS Principles course.",
:snap => "N/A", :other => "N/A"},

{:first_name => "Dalton", :last_name => "Surprenant", :email => "daltons@berkeley.edu", :school_name => "San Diego High School",
:city => "San Diego", :state => "CA", :website => "https://sdhs.org", :course => "I am using BJC as a resource, but not teaching with it.",
:snap => "N/A", :other => "N/A"},

{:first_name => "Ye", :last_name => "Wang", :email => "wangye@berkeley.edu", :school_name => "New York High School",
:city => "New York", :state => "NY", :website => "https://nyhs.fuhsd.org", :course => "I am a TEALS volunteer, and am teaching the BJC curriculum.",
:snap => "N/A", :other => "N/A"},


{:first_name => "Zachary", :last_name => "Chao", :email => "zachchao@berkeley.edu", :school_name => "Santa Barbara High School",
:city => "Santa Barbara", :state => "CA", :website => "https://sbhs.org", :course => "Other",
:snap => "N/A", :other => "For a club"},

{:first_name => "Varun", :last_name => "Murthy", :email => "murthy@berkeley.edu", :school_name => "Houston High School",
:city => "Houston", :state => "TX", :website => "https://houstonTexas.org", :course => "I am teaching BJC as an AP CS Principles course.",
:snap => "N/A", :other => "N/A"}

]

teachers.each do |teacher|
    Teacher.create!(teacher)
end