class DomainsController < ApplicationController
  def index
    @domains = Domain.active.order(:closing_on).page params[:page]
  end
end
