class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.order(event_date: :asc)
  end
end
