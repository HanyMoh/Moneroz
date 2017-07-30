class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    authorize! :read, Product
    @page_title = "بيانات الأصناف"
    @products = Product.sorted
  end

  def show
    authorize! :read, Product
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
        format.html { redirect_to products_url, notice: 'Product was successfully created.' }
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
        params[:product][:barcode] = Product.set_barcode(@product)
      end

      if @product.update(product_params)
        format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
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
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
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
