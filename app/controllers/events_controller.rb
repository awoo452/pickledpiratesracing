class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    data = Events::IndexData.call
    @events = data.events
  end
end
