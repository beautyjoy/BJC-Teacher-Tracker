class MergeController < ApplicationController
  def preview
    @teacher = Teacher.find(params[:id])
    @merge_teacher = Teacher.find(params[:merge_id])
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
end
