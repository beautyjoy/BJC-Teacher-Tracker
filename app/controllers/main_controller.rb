class MainController < ApplicationController
    def index
        @teacher = Teacher.new
    end
end