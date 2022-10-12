class ApplicationController < ActionController::API
  before_action :json_only

  private
  def json_only
    return head :not_acceptable unless request.format == :json
  end
end
