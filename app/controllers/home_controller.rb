class HomeController < ApplicationController
  def index
    if user_signed_in?
      unless current_user.active
        redirect_to home_new_url, notice: 'معذرة .. حسابك غير نشط, تابع مع الإدارة'
      else
          authorize! :read, Document
          @documents = Document.invoices_dashboard(current_user).limit 5
      end
    else
      redirect_to new_user_session_path
    end
  end

  def new
  end
end
