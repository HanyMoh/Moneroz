class DocumentsController < ApplicationController
  # ---[ Effect References ]----------------------------------------------------
  # [1] --> Add to qty.        [+]
  # [2] --> Mines to qty.      [-]
  # [3] --> Add and mines qty. [+][-]
  # [4] --> No effect to qty.  [ ]
  # ----------------------------------------------------------------------------
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents/1
  # GET /documents/1.json
  def show
    authorize! :read, Document
  end

  # GET /documents/1/edit
  def edit
    authorize! :update, Document
    @document.doc_items.build
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    set_field
    @document.user = current_user

    respond_to do |format|
      if @document.save
        format.html { redirect_back(fallback_location: root_url, notice: 'Document was successfully created.') }
      else
        format.html { redirect_back(fallback_location: root_url, alert: 'Document was not successfully created.') }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      set_field

      if @document.update(document_params)
        format.html { redirect_back fallback_location: root_url, notice: 'Document was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # GET /documents/first_term
  def first_term
    authorize! :first_term, Document
    get_list_documents(1, "بضاعة أول المدة")
  end

  # GET /documents/purchase
  def purchase
    authorize! :purchase, Document
    get_list_documents(2, "فاتورة شراء بضاعة")
  end

  # GET /documents/sale_cash
  def sale_cash
    authorize! :sale_cash, Document
    get_list_documents(3, "فاتورة بيع نقدى")
  end

  # GET /documents/selling_futures
  def selling_futures
    authorize! :selling_futures, Document
    get_list_documents(4, "فاتورة بيع آجل")
  end

  # GET /documents/returned_sale
  def returned_sale
    authorize! :returned_sale, Document
    get_list_documents(5, "مرتجع مبيعات")
  end

  # GET /documents/returned_buy
  def returned_buy
    authorize! :returned_buy, Document
    get_list_documents(6, "مرتجع مشتريات")
  end

  # GET /documents/barcode
  def barcode
    authorize! :barcode, Document
    get_list_documents(7, "طباعة باركود")
  end

  # GET /documents/add_first_term
  def add_first_term
    authorize! :add_first_term, Document
    set_document_type(1, 1, "بضاعة أول المدة")
  end

  # GET /documents/add_purchase
  def add_purchase
    authorize! :add_purchase, Document
    set_document_type(1, 2, "فاتورة شراء بضاعة")
  end

  # GET /documents/add_sale_cash
  def add_sale_cash
    authorize! :add_sale_cash, Document
    set_document_type(2, 3, "فاتورة بيع نقدى")
  end

  # GET /documents/add_selling_futures
  def add_selling_futures
    authorize! :add_selling_futures, Document
    set_document_type(2, 4, "فاتورة بيع آجل")
  end

  # GET /documents/add_returned_sale
  def add_returned_sale
    authorize! :add_returned_sale, Document
    set_document_type(1, 5, "مرتجع مبيعات")
  end

  # GET /documents/add_returned_buy
  def add_returned_buy
    authorize! :add_returned_buy, Document
    set_document_type(2, 6, "مرتجع مشتريات")
  end

  # GET /documents/add_barcode
  def add_barcode
    authorize! :add_barcode, Document
    set_document_type(4, 7, "طباعة باركود")
  end

  def give_me_barcode
    @product = Product.find(params[:product])
    render json: @product
  end

  def give_me_product
    # @product = Product.get_product_by_barcode(params[:barcode])
    # byebug
    @product = Product.find 1 #(params[:barcode])
    render json: @product
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    authorize! :destroy, Document
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Use this to add default fields value
    def set_field
      if @document.code == 0 || @document.code.nil?
        @document.code = Document.max_code(@document.doc_type)
      end
    end

    def get_list_documents(doc_type, title)
      @page_title = title
      @documents = Document.invoices(doc_type, current_user)
    end

    def set_document_type(effect, doc_type, title)
      @page_title = title
      @document = Document.new
      @document.doc_type = doc_type
      @document.effect = effect
      @document.user = current_user
      @document.store = Person.find(2)
      set_field
      @document.doc_items.build
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:doc_date, :code, :store_id, :storage_id, :person_id, :user_id, :payment, :doc_type, :effect, :discount_value, :discount_ratio, :tax, :hold, :note, doc_items_attributes: [:id, :product_id, :quantity, :price, :effect, :discount_value, :returned, :_destroy])
    end
end
