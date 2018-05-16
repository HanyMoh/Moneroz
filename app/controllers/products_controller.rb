class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  autocomplete :product, :name
  # GET /products
  # GET /products.json
  def index
    authorize! :read, Product
    @page_title = "بيانات الأصناف"
    @products = Product.sorted
  end

  def show
    authorize! :read, Product
    respond_to do |format|
       format.js
    end
  end

  # GET /products/new
  def new
    authorize! :create, Product
    @page_title = "بيانات الأصناف"
    @product = Product.new
    @product.code = Product.max_code
  end

  # GET /products/1/edit
  def edit
    authorize! :update, Product
    @page_title = "بيانات الأصناف"
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    if @product.code == 0 || @product.code.nil?
      @product.code = Product.max_code
    end
    @product.barcode = Product.generat_barcode(@product)

    respond_to do |format|
      if @product.save
        format.html { redirect_to products_url, notice: 'تم الحفظ بنجاح' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.code == 0 || @product.code.nil?
        @product.code = Product.max_code
      end
      if params[:product][:barcode].blank?
        params[:product][:barcode] = Product.generat_barcode(@product)
      end

      if @product.update(product_params)
        format.html { redirect_to products_url, notice: 'تم التعديل بنجاح' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    authorize! :destroy, Product
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'تم الحذف بنجاح' }
      format.json { head :no_content }
    end
  end

  def inventory
    @products = Product.all.includes(:section).includes(:unit).includes(:unit_refill)
    if params[:filter].present?
      @inventory_date = params[:filter].delete :inventory_date
      ## delete empty filter params
      filter = params[:filter].to_unsafe_h.clone.delete_if { |k, v| v.blank? }
      @products = @products.where(filter)
    end
    @product_stock = Hash.new
    @products.each do |product|
      inventory_date_stock = 0
      # inventory_date_transactions = product.sys_transactions.includes(:document)
      #                               .where("documents.doc_date <= ?", @inventory_date)
      #                               .references(:document)
      inventory_date_transactions = product.sys_transactions
                                    .joins("INNER JOIN documents ON documents.id = sys_transactions.documentable_id AND sys_transactions.documentable_type = 'Document'")
                                    .where("documents.doc_date <= ?", @inventory_date)
      if inventory_date_transactions.any?
        inventory_date_stock = inventory_date_transactions.last.quantity_after
      end
      @product_stock[product.id] = inventory_date_stock
    end
  end

  def about_to_empty_inventory
    @products = Product.all.includes(:section).includes(:unit).includes(:unit_refill)
    if params[:filter].present?
      @inventory_date = params[:filter].delete :inventory_date
      ## delete empty filter params
      filter = params[:filter].to_unsafe_h.clone.delete_if { |k, v| v.blank? }
      @products = @products.where(filter)
    end
    @product_stock = Hash.new
    @products.each do |product|
      inventory_date_stock = 0
      inventory_date_transactions = product.sys_transactions
                                    .joins("INNER JOIN documents ON documents.id = sys_transactions.documentable_id AND sys_transactions.documentable_type = 'Document'")
                                    .where("documents.doc_date <= ?", @inventory_date)
      if inventory_date_transactions.any?
        inventory_date_stock = inventory_date_transactions.last.quantity_after
      end
      @product_stock[product.id] = inventory_date_stock
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:code, :name, :barcode, :price_in, :price_out, :section_id, :unit_id, :refill, :unit_refill_id, :service, :discount_value, :tax, :note)
    end
end
