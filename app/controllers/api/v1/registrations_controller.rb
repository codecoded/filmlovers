module Api
  module V1
    class RegistrationsController  < BaseController 
      skip_before_filter :verify_authenticity_token

      respond_to :json
      
      def create
        @user = User.new(params[:user].slice(:username, :password, :email))

        if @user.valid?
          @user.ensure_authentication_token!
          @user.save!
          @current_user = @user         
        else
          render :status=>422, :json=>{:message=>@user.errors.messages}        
        end
      end
    end  
  end
end
