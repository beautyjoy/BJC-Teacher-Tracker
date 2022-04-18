class UploadsController < ApplicationController
  def index
  end

  def import_csv
    rowarray = Array.new
    myfile = params[:file]

    CSV.foreach(myfile.path) do |row|
      rowarray << row
      @rowarraydisp = rowarray
    end
  end
end
