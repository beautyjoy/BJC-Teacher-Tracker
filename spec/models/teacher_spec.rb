# == Schema Information
#
# Table name: teachers
#
#  id                                :bigint           not null, primary key
#  admin                             :boolean          default(FALSE)
#  application_status                :string           default("pending")
#  clever_refresh_token              :string
#  clever_token                      :string
#  education_level                   :integer          default(NULL)
#  email                             :string
#  encrypted_google_refresh_token    :string
#  encrypted_google_refresh_token_iv :string
#  encrypted_google_token            :string
#  encrypted_google_token_iv         :string
#  first_name                        :string
#  last_name                         :string
#  microsoft_refresh_token           :string
#  microsoft_token                   :string
#  more_info                         :string
#  personal_website                  :string
#  snap                              :string
#  status                            :integer
#  created_at                        :datetime
#  updated_at                        :datetime
#  school_id                         :integer
#
# Indexes
#
#  index_teachers_on_email                 (email) UNIQUE
#  index_teachers_on_email_and_first_name  (email,first_name)
#  index_teachers_on_school_id             (school_id)
#  index_teachers_on_snap                  (snap) UNIQUE WHERE ((snap)::text <> ''::text)
#  index_teachers_on_status                (status)
#
require 'rails_helper'

RSpec.describe Teacher, type: :model do
  fixtures :all

  let(:teacher) { teachers(:bob) }

  it 'shows email names correct' do
    expect(teacher.email_name).to eq "Bob Johnson <bob@gmail.com>"
  end

  it 'should be valid' do
    expect(teacher.valid?).to be true
  end

  it 'shows a text status' do
    expect(teacher.text_status).to eq 'I am teaching BJC but not as an AP CS Principles course.'
  end

  it 'shows a short status' do
    expect(teacher.display_status).to eq 'Non CSP Teacher'
  end

  it 'shows an application status' do
    expect(teacher.display_application_status).to eq 'Denied'
  end

  it 'shows Unknown education level' do 
    expect(teacher.display_education_level).to eq 'Unknown'
  end

  describe 'teacher with more info' do
    let(:teacher) { teachers(:ye) }

    it 'shows a short status with more info' do
      expect(teacher.display_status).to eq 'Other | A CS169 Student'
    end

    it 'shows an application status' do
      expect(teacher.display_application_status).to eq 'Validated'
    end
  end

  describe 'teacher with pending application status' do
    let(:teacher) { teachers(:long) }

    it 'shows an application status' do
      expect(teacher.display_application_status).to eq 'Pending'
    end
  end
end
