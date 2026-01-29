class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [ :edit, :update, :destroy ]

  def index
    @events = Event.order(event_date: :asc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      if require_heroku_upload?
        redirect_to heroku_event_edit_url(@event), notice: "Event created. Uploads must happen on the Heroku admin."
      else
        handle_image_uploads(@event)
        redirect_to admin_events_path, notice: "Event created"
      end
    else
      flash.now[:alert] = @event.errors.full_messages.to_sentence.presence || "Event creation failed"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      if require_heroku_upload?
        redirect_to heroku_event_edit_url(@event), notice: "Event updated. Uploads must happen on the Heroku admin."
      else
        handle_image_uploads(@event)
        redirect_to admin_events_path, notice: "Event updated"
      end
    else
      flash.now[:alert] = @event.errors.full_messages.to_sentence.presence || "Event update failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_events_path, notice: "Event deleted"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.fetch(:event, {}).permit(:title, :event_date, :location, :description, :link, :image_key, :image_alt_key)
  end

  def require_heroku_upload?
    Rails.env.production? && !on_heroku? && upload_attempted?
  end

  def upload_attempted?
    params.dig(:event, :image).present? || params.dig(:event, :alt_image).present?
  end

  def heroku_host
    "pickledpiratesracing-prod-e5b7e4ec2418.herokuapp.com"
  end

  def on_heroku?
    request.host == heroku_host
  end

  def heroku_event_edit_url(event)
    "https://#{heroku_host}/admin/events/#{event.id}/edit"
  end

  def handle_image_uploads(event)
    upload_event_image(event, params.dig(:event, :image), "main")
    upload_event_image(event, params.dig(:event, :alt_image), "alt")
  end

  def upload_event_image(event, uploaded, image_type)
    return if uploaded.blank?

    ext = File.extname(uploaded.original_filename)
    key = "events/#{event.id}/#{image_type}#{ext}"

    begin
      S3Service.new.upload(uploaded, key)
    rescue StandardError => e
      Rails.logger.error("S3 upload failed for event #{event.id}: #{e.message}")
      return
    end

    if image_type == "main"
      event.update!(image_key: key)
    else
      event.update!(image_alt_key: key)
    end
  end
end
