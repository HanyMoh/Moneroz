class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :update, :destroy]

  # GET /payments/1
  def show
    authorize! :read, Payment
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params)
    set_field

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /payments/1
  def update
    set_field
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  # DELETE /payments/cash_in
  def cash_in
    authorize! :cash_in, Payment
    set_pay_type(1, 1, "إيصال استلام نقدية", "استلام")
  end

  # DELETE /payments/cash_out
  def cash_out
    authorize! :cash_out, Payment
    set_pay_type(2, 2, "إيصال صرف نقدية", "صرف")
  end

  # DELETE /payments/1
  def destroy
    authorize! :destroy, Payment
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Use this to add default fields value
    def set_field
      if @payment.code == 0 || @payment.code.nil?
        @payment.code = Payment.max_code(@payment.pay_type)
      end
      @payment.user = current_user
    end

    def set_pay_type(effect, pay_type, title, single_word)
      @page_title = title
      @single_word = single_word
      @payment = Payment.new
      @payment.code = Payment.max_code(pay_type)
      @payment.pay_type = pay_type
      @payment.effect = effect
      @payments = Payment.payments_by_type(pay_type, current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:code, :pay_date, :pay_type, :effect, :storage_id, :person_id, :money, :description, :user_id, :note)
    end
end
