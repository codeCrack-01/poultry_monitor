class ZonesController < ApplicationController
  def show
    @zone = Zone.includes(sensors: :readings, alerts: {}).find(params[:id])
    @alerts = @zone.alerts.by_severity.limit(10)
  end
end
