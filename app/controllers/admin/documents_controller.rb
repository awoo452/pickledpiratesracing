class Admin::DocumentsController < Admin::BaseController
  before_action :set_document, only: [ :show, :edit, :update, :destroy ]

  def index
    @documents = Document.order(created_at: :desc)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)

    if @document.save
      redirect_to admin_documents_path, notice: "Document created"
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence.presence || "Document creation failed"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  def update
    if @document.update(document_params)
      redirect_to admin_documents_path, notice: "Document updated"
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence.presence || "Document update failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to admin_documents_path, notice: "Document deleted"
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.fetch(:document, {}).permit(:title, :body)
  end
end
