module Api
  module V1
    class RegistrationsController  < BaseController 
      skip_before_filter :verify_authenticity_token

      respond_to :json
      
      def create
        @user = nil
        if access_token
          begin
            @user = User.from_facebook_token(access_token)
          rescue Koala::Facebook::AuthenticationError => e
            return render_error('Facebook', ['OAuth Token', 'Facebook token invalid. Please close the filmlovr app and try again'], e)
          end
        else
          if params[:user].blank?
            return render_error('User', ['User', 'Username, email and password required'], 'User details are blank')
          end
          @user = User.new(params[:user].slice(:username, :password, :email))
        end

        if @user.valid?
          @user.ensure_authentication_token
          @user.save!
          @current_user = @user         
        else
          Log.error("Unable to register. Params: #{params}, error: #{@user.errors.messages}")
          render status: 422, json: {:message=>@user.errors.messages}        
          return
        end

      rescue => msg
        render_error 'Other', ['Generic', 'Sorry, we are unable to log you in. If the problem persists, you can re-authorise at www.filmlovr.com with same credentials.'], msg
      end

      def render_error(desc, msg, error)
        Log.error("Unable to register. Msg: #{msg}, Params: #{params}, error: #{error}")
        render status: 422, json: {message: {desc=> msg}}
      end

      protected
      def access_token
        @token ||= params[:access_token]
      end
    end  
  end
end
