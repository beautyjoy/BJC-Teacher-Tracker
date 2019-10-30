class TeachersController < ApplicationController
    def create
        @lead = Lead.new lead_params
        redirect_to root_path
    end

    private

        def teacher_params
            params.require(:teacher).permit(:first_name, :last_name, :school_name, :email, :city, :state, :website, :course, :snap)
end