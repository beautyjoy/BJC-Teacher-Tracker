# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
teachers = [{:encrypted_first_name => "Janani", :encrypted_last_name => "Vijaykumar", :encrypted_email => "janani_vijaykumar@berkeley.edu", :encrypted_school_name => "Monta Vista High School", 
:encrypted_city => "Cupertino", :encrypted_state => "California", :encrypted_website => "https://mvhs.fuhsd.org", :encrypted_course => "I am teaching BJC as an AP CS Principles course.", 
:encrypted_snap => "N/A", :encrypted_other => "N/A"},
{:encrypted_first_name => "Kimberly", :encrypted_last_name => "Zhu", :encrypted_email => "kpzhu@berkeley.edu", :encrypted_school_name => "Cupertino High School",
:encrypted_city => "Cupertino", :encrypted_state => "California", :encrypted_website => "https://chs.fuhsd.org", :encrypted_course => "I am teaching BJC but not as an AP CS Principles course.",
:encrypted_snap => "N/A", :encrypted_other => "N/A"},
{:encrypted_first_name => "Dalton", :encrypted_last_name => "Surprenant", :encrypted_email => "daltons@berkeley.edu", :encrypted_school_name => "San Diego High School",
:encrypted_city => "San Diego", :encrypted_state => "California", :encrypted_website => "https://sdhs.org", :encrypted_course => "I am using BJC as a resource, but not teaching with it.",
:encrypted_snap => "N/A", :encrypted_other => "N/A"},
{:encrypted_first_name => "Ye", :encrypted_last_name => "Wang", :encrypted_email => "wangye@berkeley.edu", :encrypted_school_name => "New York High School",
:encrypted_city => "New York", :encrypted_state => "New York", :encrypted_website => "https://nyhs.fuhsd.org", :encrypted_course => "I am a TEALS volunteer, and am teaching the BJC curriculum.",
:encrypted_snap => "N/A", :encrypted_other => "N/A"},
{:encrypted_first_name => "Zachary", :encrypted_last_name => "Chao", :email => "zachchao@berkeley.edu", :encrypted_school_name => "Santa Barbara High School",
:cencrypted_cityity => "Santa Barbara", :encrypted_state => "California", :encrypted_website => "https://sbhs.org", :encrypted_course => "Other",
:encrypted_snap => "N/A", :encrypted_other => "For a club"},
{:encrypted_first_name => "Varun", :encrypted_last_name => "Murthy", :encrypted_email => "murthy@berkeley.edu", :encrypted_school_name => "Houston High School",
:encrypted_city => "Houston", :encrypted_state => "Texas", :encrypted_website => "https://houstonTexas.org", :encrypted_course => "I am teaching BJC as an AP CS Principles course.",
:encrypted_snap => "N/A", :encrypted_other => "N/A"}]

teachers.each do |teacher|
    Teacher.create!(teacher)
end