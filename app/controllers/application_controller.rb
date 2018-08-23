require "application_responder"

class ApplicationController < ActionController::Base
  # TODO expose CSRF tokens to client
  skip_before_action :verify_authenticity_token

  self.responder = ApplicationResponder
  respond_to :html
end
