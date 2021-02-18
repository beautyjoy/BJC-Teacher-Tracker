# == Schema Information
#
# Table name: teachers
#
#  id                      :bigint           not null, primary key
#  admin                   :boolean          default(FALSE)
#  course                  :string
#  email                   :string
#  first_name              :string
#  google_refresh_token    :string
#  google_refresh_token_iv :string
#  google_token            :string
#  google_token_iv         :string
#  last_name               :string
#  more_info               :string
#  other                   :string
#  snap                    :string
#  status                  :integer
#  validated               :boolean
#  created_at              :datetime
#  updated_at              :datetime
#  school_id               :integer
#
# Indexes
#
#  index_teachers_on_email_and_first_name  (email,first_name)
#
require 'rails_helper'

RSpec.describe Teacher, type: :model do
  fixtures :all

  let(:teacher) { teachers(:bob_teacher) }

  it 'shows email names correct' do
    expect(teacher.email_name).to eq "Bob Johnson <bob@gmail.com>"
  end

  it 'should be valid' do
    expect(teacher.valid?).to be true
  end

  it 'shows a text status' do
    expect(teacher.status).to eq 'I am teaching BJC but not as an AP CS Principles course.'
  end

  it 'shows a short status' do
    expect(teacher.display_status).to eq 'Non-CSP Teacher'
  end

  describe 'teacher with more info' do
    let(:teacher) { teachers(:ye) }

    it 'shows a short status with more info' do
      expect(teacher.display_status).to eq 'Other | A CS169 Student'
    end
  end
end
