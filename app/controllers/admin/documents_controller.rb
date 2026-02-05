class Admin::DocumentsController < Admin::BaseController
  before_action :set_document, only: [ :show, :edit, :update, :destroy ]

  def index
    data = Admin::Documents::IndexData.call
    @documents = data.documents
  end

  def new
    @document = Document.new
  end

  def create
    result = Admin::Documents::CreateDocument.call(params: document_params)
    @document = result.document

    if result.success?
      redirect_to admin_documents_path, notice: "Document created"
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  def update
    result = Admin::Documents::UpdateDocument.call(document: @document, params: document_params)
    if result.success?
      redirect_to admin_documents_path, notice: "Document updated"
    else
      flash.now[:alert] = result.error
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Admin::Documents::DestroyDocument.call(document: @document)
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
