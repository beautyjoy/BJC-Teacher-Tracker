# frozen_string_literal: true

class MergeController < ApplicationController
  def preview
    puts params.inspect
    @from_teacher = Teacher.find(params[:from])
    @into_teacher = Teacher.find(params[:into])
    puts "Here we go"
    puts @from_teacher
    @result_teacher = merge_teachers(@from_teacher, @into_teacher) 
  end

  def execute
    puts params.inspect
    @from_teacher = Teacher.find(params[:from])
    @into_teacher = Teacher.find(params[:into])
    @merged_teacher = merge_teachers(@from_teacher, @into_teacher) 

    merged_attributes = @merged_teacher.attributes.except("id")
    @into_teacher.update!(merged_attributes)
    @from_teacher.destroy
    redirect_to teachers_path, notice: "Teachers merged successfully."
  end

  private
  #Returns a merged teacher without saving it to the database. 
  #Rendered in the preview, and only saved to the DB in a call to merge.
  def merge_teachers(from_teacher, into_teacher)
    merged_attributes = {}
    into_teacher.attributes.each do |attr_name, attr_value|
      from_teacher_attr_value = from_teacher.attributes[attr_name]
      if attr_value.blank?
        merged_attributes[attr_name] = from_teacher_attr_value
      elsif from_teacher_attr_value.blank?
        merged_attributes[attr_name] = attr_value
      else
        case attr_name
        when "session_count"
          merged_attributes[attr_name] = attr_value + from_teacher_attr_value
        when "ip_history"
          merged_attributes[attr_name] = (attr_value + from_teacher_attr_value).uniq
        when "last_session_at"
          # The resulting last session time is the most recent one
          merged_attributes[attr_name] = attr_value > from_teacher_attr_value ? attr_value : from_teacher_attr_value
        when "created_at"
          # The resulting record creation time is the least recent one
          merged_attributes[attr_name] = attr_value < from_teacher_attr_value ? attr_value : from_teacher_attr_value
        else 
          merged_attributes[attr_name] = attr_value
        end
      end
      
    end

    merged_teacher = Teacher.new(merged_attributes)
    merged_teacher
  end
end
