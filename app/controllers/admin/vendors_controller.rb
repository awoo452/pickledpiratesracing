class Admin::VendorsController < Admin::BaseController
  before_action :set_vendor, only: [ :edit, :update, :destroy ]

  def index
    data = Admin::Vendors::IndexData.call
    @vendors = data.vendors
  end

  def new
    @vendor = Vendor.new
  end

  def create
    result = Admin::Vendors::CreateVendor.call(params: vendor_params)
    @vendor = result.vendor

    if result.success?
      redirect_to edit_admin_vendor_path(@vendor), notice: "Vendor created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    result = Admin::Vendors::UpdateVendor.call(vendor: @vendor, params: vendor_params)

    if result.success?
      redirect_to edit_admin_vendor_path(@vendor), notice: "Vendor updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Admin::Vendors::DestroyVendor.call(vendor: @vendor)
    redirect_to admin_vendors_path, notice: "Vendor deleted"
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.fetch(:vendor, {}).permit(
      :name,
      :contact_name,
      :email,
      :phone,
      :website,
      :notes,
      :active
    )
  end
end
