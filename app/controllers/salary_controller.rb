class SalaryController < ApplicationController
    def new
    end
    
    def index
        @salary = Salary.all
        PriceModel.build
        
    end
end
