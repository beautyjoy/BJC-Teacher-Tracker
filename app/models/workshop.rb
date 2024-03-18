# frozen_string_literal: true

# == Schema Information
#
# Table name: workshops
#
#  id             :integer          not null, primary key
#  city           :string
#  country        :string
#  grade_level    :integer
#  lat            :float
#  lng            :float
#  name           :string
#  state          :string
#  tags           :text             default([]), is an Array
#  teachers_count :integer          default(0)
#  website        :string           TODO: Confirm is it necessary field
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  TODO: Define indexes


class Workshop
  include ActiveModel::Model
  include ActiveModel::Attributes # Make sure this is included

  # Define attributes
  attribute :id, :integer
  attribute :name, :string
  attribute :city, :string
  attribute :state, :string
  attribute :country, :string
  attribute :start_date, :date
  attribute :end_date, :date
  attribute :grade_level, :string
  attribute :registration_open, :boolean

  def initialize(attributes = {})
    super(attributes)
    # Now ActiveModel handles attributes, no need to manually set defaults for attributes defined above
  end

  def persisted?
    id.present?
  end

  def location
    "#{city}, #{state}, #{country}"
  end
end
