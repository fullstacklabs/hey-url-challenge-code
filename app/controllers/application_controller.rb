# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_not_found
    render '_shared/404', status: 404
  end
end
