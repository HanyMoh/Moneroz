class DocumentsController < ApplicationController
  # ---[ Effect References ]----------------------------------------------------
  # [1] --> Add to qty.        [+]
  # [2] --> Mines to qty.      [-]
  # [3] --> Add and mines qty. [+][-]
  # [4] --> No effect to qty.  [ ]
  # ----------------------------------------------------------------------------
  before_action :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy]


  autocomplete :product, :name

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
    @product = Product.get_product_by_barcode(params[:barcode])
    render json: @product.present? ? @product.first : {}
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

  # GET /documents/per_product
  def per_product
    @page_title = "حركة الصنف"
    @documents = []
    if params[:filter].present?
      ## delete empty filter params
      filter = params[:filter].to_unsafe_h.clone.delete_if { |k, v| v.blank? }
      ## getting searched product
      if filter["products.id"]
        @product = Product.find(filter["products.id"])
      elsif filter["products.barcode"]
        @product = Product.find_by_barcode(filter["products.barcode"])
      end
      if @product.present?
        ## documents will display only when a valid product being choosen (per product dispaly)
        @documents = Document.period_filter(filter)
        if @documents.any?
          ## getting previous quantity through product transactions
          ## first document quantity before changes will indicate the prev quantity
          @prev_quantity = @documents.first.sys_transactions
                          .where(loggable_id: @product.id, loggable_type: "Product")
                          .first.quantity_before
          ## create hash[document id] => quantity of product filtered into the document
          @doc_items = Hash.new
          @documents.each do |document|
            @doc_items[document.id] = Hash.new
            @doc_items[document.id][:quantity_change] = document.doc_items
                                                        .where(product_id: @product.id)
                                                        .first.quantity
            @doc_items[document.id][:quantity_after_change] = document.sys_transactions
                                                              .where(loggable_id: @product.id, loggable_type: "Product")
                                                              .first.quantity_after
          end
        end
      end
    end
  end

  # GET /documents/per_customer
  def per_customer
    @page_title = "حركة حساب عميل"
    @person_type = 1
    per_person(@person_type, params)
  end

  # GET /documents/per_supplier
  def per_supplier
    @page_title = "حركة حساب مورد"
    @person_type = 2
    per_person(@person_type, params)
  end

  # GET /documents/autocomplete_person_name
  def autocomplete_person_name
    ## retrieve people according to type
    people = Person.where(person_type: params[:person_type].to_i)
    render :json => people.map { |person| {:id => person.id, :label => person.name, :value => person.name} }
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
      params.require(:document).permit(:doc_date, :code, :store_id, :storage_id, :person_id, :user_id, :payment, :doc_type, :effect, :discount_value, :discount_ratio, :tax, :hold, :note, :total_price, doc_items_attributes: [:id, :product_id, :quantity, :price, :effect, :discount_value, :returned, :_destroy])
    end

    def per_person(person_type, params)
      documents = []
      if params[:filter].present?
        ## delete empty filter params
        filter = params[:filter].to_unsafe_h.clone.delete_if { |k, v| v.blank? }
        if filter["people.id"]
          @person = Person.find(filter["people.id"])
          ## documents will display only when a valid person being choosen
          documents = Document.period_filter(filter)
          payments = Payment.period_filter(filter)
          ## getting balance before filter period
          ## creating a hash of documents and payment too then sorting them
          sorted_docs = (documents + payments).sort_by{|document| document.class == Document ? document.doc_date : document.pay_date }
          first_transaction = sorted_docs.first.sys_transactions.where(loggable: @person).first
          @prev_balance = first_transaction.present? ? first_transaction.quantity_before : 0
          @finance_hash = create_finance_report(sorted_docs, @person)
        end
      end
    end

    def create_finance_report(documents, person)
      finance = Hash.new
      ## documents are both documents and payments
      documents.each do |document|
        finance_hash = Hash.new
        finance_hash[:object_type] = document.class.to_s
        finance_hash[:object_id] = document.id
        finance_hash[:date] = document.try(:doc_date) || document.pay_date
        finance_hash[:label] = document.label
        finance_hash[:total_price] = document.try(:total_price).try(:to_i) || document.money.to_i
        finance_hash[:user_name] = document.user.user_name
        ## depending on doc_type
        if document.class == Document
          amount = (document.total_price - document.payment).to_i
        else
          amount = document.money.to_i
        end
        case person.person_type
        when 1
          ## customer
          if document.class == Document
            finance_hash[:m] = amount
          else
            finance_hash[:d] = amount
          end
        when 2
          ## supplier 
          if document.class == Document
            finance_hash[:d] = amount
          else
            finance_hash[:m] = amount
          end
        end
        balance_transaction = SysTransaction.where(documentable: document, loggable: person).first
        finance_hash[:balance_after] = balance_transaction.present? ? balance_transaction.quantity_after : nil
        finance["#{document.class.to_s}_#{document.id}"] = finance_hash
      end
      return finance
    end
end
