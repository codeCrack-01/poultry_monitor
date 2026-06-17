class AlertsController < ApplicationController
  def index
    @critical = Alert.where(severity: :critical).by_severity
    @warnings = Alert.where(severity: :warning).by_severity
    @resolved = Alert.where(status: :resolved).by_severity.limit(10)
  end
end
