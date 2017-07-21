class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, only: [:show, :update, :destroy]

  def show
    authorize! :read, Person
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    set_field

    respond_to do |format|
      if @person.save
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @person = Person.new(person_params)
    set_field
    respond_to do |format|
      if @person.save
        format.html { redirect_to people_url, notice: 'This item was successfully created.' }
        format.js
      else
        format.html { redirect_to people_url, alert: 'This item was unsuccessfully updated.' }
        format.js
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    set_field
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to people_url, notice: 'This item was successfully updated.' }
        format.js
      else
        format.html { redirect_to people_url, alert: 'This item was unsuccessfully updated.' }
        format.js
      end
    end
  end

  def customers
    authorize! :customer, Person
    set_person_type(1,"بيانات العملاء","Customer")
  end
  def suppliers
    authorize! :supplier, Person
    set_person_type(2, "بيانات الموردين" ,"Supplier")
  end
  def stores
    authorize! :store, Person
    set_person_type(3, "بيانات المخازن", "Store")
  end
  def storages
    authorize! :storage, Person
    set_person_type(4, "بيانات الخزائن", "Storage")
  end
  def fees
    authorize! :fee, Person
    set_person_type(5, "بيانات المصروفات" ,"Expense")
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'This item was successfully destroyed.' }
      format.js
    end
  end

  private
    def set_person_type(person_type, title, single_word)
      @page_title = title
      @single_word = single_word
      @person = Person.new
        @person.code = Person.max_code(person_type)
        @person.person_type = person_type
      @people = Person.people_by_type(person_type)
    end

    def set_field
      if @person.code == 0 || @person.code.nil?
        @person.code = Person.max_code(@person.person_type)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:code, :name, :person_type, :phone, :address, :note)
    end
end
