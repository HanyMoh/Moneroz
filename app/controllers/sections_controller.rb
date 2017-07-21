class SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_section, only: [:edit, :update, :destroy]

  # GET /sections
  # GET /sections.json
  def index
    authorize! :read, Section
    @page_title = "بيانات الأقسام"
    @sections = Section.sorted
  end

  # GET /sections/new
  def new
    authorize! :create, Section
    @page_title = "بيانات الأقسام"
    @section = Section.new
    @section.code = Section.max_code
  end

  # GET /sections/1/edit
  def edit
    authorize! :update, Section
    @page_title = "بيانات الأقسام"
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    if @section.code == 0 or @section.code == nil
      @section.code = Section.max_code
    end

    respond_to do |format|
      if @section.save
        format.html { redirect_to sections_url, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.code == 0 or @section.code == nil
        @section.code = Section.max_code
      end

      if @section.update(section_params)
        format.html { redirect_to sections_url, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    authorize! :destroy, Section
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:code, :name)
    end
end
