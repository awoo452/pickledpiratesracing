class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [ :edit, :update, :destroy ]

  def index
    data = Admin::Events::IndexData.call
    @events = data.events
  end

  def new
    @event = Event.new
  end

  def create
    result = Admin::Events::CreateEvent.call(
      params: event_params,
      request_host: request.host,
      production: Rails.env.production?,
      image: params.dig(:event, :image),
      alt_image: params.dig(:event, :alt_image)
    )
    @event = result.event

    if result.success?
      if result.redirect_url.present?
        redirect_to result.redirect_url, notice: result.notice
      else
        redirect_to admin_events_path, notice: result.notice
      end
    else
      flash.now[:alert] = result.alert
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Admin::Events::UpdateEvent.call(
      event: @event,
      params: event_params,
      request_host: request.host,
      production: Rails.env.production?,
      image: params.dig(:event, :image),
      alt_image: params.dig(:event, :alt_image)
    )

    if result.success?
      if result.redirect_url.present?
        redirect_to result.redirect_url, notice: result.notice
      else
        redirect_to admin_events_path, notice: result.notice
      end
    else
      flash.now[:alert] = result.alert
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Admin::Events::DestroyEvent.call(event: @event)
    redirect_to admin_events_path, notice: "Event deleted"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.fetch(:event, {}).permit(:title, :event_date, :location, :description, :link, :image_key, :image_alt_key)
  end

end
