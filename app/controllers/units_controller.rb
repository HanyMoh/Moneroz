class UnitsController < ApplicationController
  before_action :set_unit, only: [:edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @page_title = "بيانات الوحدات"
    @units = Unit.sorted
  end

  # GET /units/new
  def new
    @page_title = "بيانات الوحدات"
    @unit = Unit.new
    @unit.code = Unit.max_code
  end

  # GET /units/1/edit
  def edit
    @page_title = "بيانات الوحدات"
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    if @unit.code == 0 or @unit.code == nil
      @unit.code = Unit.max_code
    end

    respond_to do |format|
      if @unit.save
        format.html { redirect_to units_url, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.code == 0 or @unit.code == nil
        @unit.code = Unit.max_code
      end

      if @unit.update(unit_params)
        format.html { redirect_to units_url, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:code, :name)
    end
end
