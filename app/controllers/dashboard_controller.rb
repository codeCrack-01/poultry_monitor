class DashboardController < ApplicationController
  def index
    redirect_to farms_path
  end
end
