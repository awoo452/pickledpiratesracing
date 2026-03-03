class Admin::VendorProductsController < Admin::BaseController
  before_action :set_vendor_product, only: [ :edit, :update, :destroy ]

  def index
    data = Admin::VendorProducts::IndexData.call
    @vendor_products = data.vendor_products
  end

  def new
    data = Admin::VendorProducts::FormData.call
    @vendors = data.vendors
    @variants = data.variants
    @vendor_product = VendorProduct.new
  end

  def create
    result = Admin::VendorProducts::CreateVendorProduct.call(params: vendor_product_params)
    @vendor_product = result.vendor_product

    if result.success?
      redirect_to admin_vendor_products_path, notice: "Vendor product added"
    else
      data = Admin::VendorProducts::FormData.call
      @vendors = data.vendors
      @variants = data.variants
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    data = Admin::VendorProducts::FormData.call
    @vendors = data.vendors
    @variants = data.variants
  end

  def update
    result = Admin::VendorProducts::UpdateVendorProduct.call(
      vendor_product: @vendor_product,
      params: vendor_product_params
    )

    if result.success?
      redirect_to admin_vendor_products_path, notice: "Vendor product updated"
    else
      data = Admin::VendorProducts::FormData.call
      @vendors = data.vendors
      @variants = data.variants
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Admin::VendorProducts::DestroyVendorProduct.call(vendor_product: @vendor_product)
    redirect_to admin_vendor_products_path, notice: "Vendor product removed"
  end

  private

  def set_vendor_product
    @vendor_product = VendorProduct.find(params[:id])
  end

  def vendor_product_params
    params.fetch(:vendor_product, {}).permit(
      :vendor_id,
      :product_variant_id,
      :vendor_sku,
      :unit_cost,
      :msrp,
      :min_order_quantity,
      :lead_time_days,
      :notes
    )
  end
end
