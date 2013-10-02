module Api
  module V1
    class RegistrationsController  < BaseController 
      skip_before_filter :verify_authenticity_token

      respond_to :json
      
      def create
        if token = params[:access_token]
          @user = User.from_facebook_token params[:access_token]
        else
          @user = User.new(params[:user].slice(:username, :password, :email))
        end

        if @user.valid?
          @user.ensure_authentication_token
          @user.save!
          @current_user = @user         
        else
          render :status=>422, :json=>{:message=>@user.errors.messages}        
        end
      end

    end  
  end
end
