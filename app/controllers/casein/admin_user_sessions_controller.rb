module Casein
  class AdminUserSessionsController < Casein::CaseinController
    
    skip_before_filter :authorise, :only => [:new, :create]
    before_filter :requires_no_session_user, :except => [:destroy]
  
    layout 'casein_auth'
  
    def new
      @admin_user_session = Casein::AdminUserSession.new
    end
  
    def create
      @admin_user_session = Casein::AdminUserSession.new casein_admin_user_params
      if @admin_user_session.save
        redirect_back_or_default :controller => :casein, :action => :index
      else
        render :action => :new
      end
    end
  
    def destroy
      current_admin_user_session.destroy
      redirect_back_or_default new_casein_admin_user_session_url
    end

  private
  
    def requires_no_session_user
      if current_user
        redirect_to :controller => :casein, :action => :index
      end
    end

    def casein_admin_user_params
      params.require(:casein_admin_user_session).permit(:login,:password,:remember_me)
    end

  end
end
