class MergeController < ApplicationController
  def preview
    @teacher = Teacher.find(params[:id])
    @merge_teacher = Teacher.find(params[:merge_id])
    @result_teacher = merge_teachers(@teacher, @merge_teacher) 
    # Add any logic needed for previewing the merge
  end

  def merge
    @teacher = Teacher.find(params[:id])
    @merge_teacher = Teacher.find(params[:merge_id])
    # Add logic to merge teachers
    if @teacher.merge!(@merge_teacher)
      redirect_to teachers_path, notice: 'Teachers merged successfully.'
    else
      render :preview, alert: 'Failed to merge teachers.'
    end
  end

  private
  #Returns a merged teacher without saving it to the database. 
  #Rendered in the preview, and only saved to the DB in a call to merge.
  def merge_teachers(original, to_merge)
    merged_attributes = {}
  
    original.attributes.each do |attr_name, attr_value|
      merged_attributes[attr_name] = attr_value.nil? ? to_merge.attributes[attr_name] : attr_value
    end

    merged_teacher = Teacher.new(merged_attributes)
    merged_teacher
  end

end
