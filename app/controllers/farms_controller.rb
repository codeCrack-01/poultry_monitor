class FarmsController < ApplicationController
  def index
    @farms = Farm.includes(:alerts).order(:name)
  end

  def show
    @farm = Farm.includes(sheds: { zones: :sensors }).find(params[:id])
    @alerts = @farm.alerts.active.by_severity.limit(5)
  end
end
