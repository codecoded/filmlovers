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
            @user.channels[:facebook].exchange_token
          rescue Koala::Facebook::AuthenticationError => e
            return render_error('Facebook', ['AuthenticationError', 'Facebook token invalid. Please close the filmlovr app and try again'], "User: #{@user}, Msg: #{e}")
          end
        else
          return if invalid_details? 
          @user = User.new(user_details)
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

      def user_details
        params[:user].slice(:username, :password, :email) if params[:user]
      end

      def username
        user_details[:username]
      end

      def email
        user_details[:email]
      end

      def password
        user_details[:password]
      end

      def invalid_details?
        if user_details.blank? 
          return render_error('User', ['Username, email and password required'], 'User details are blank')
        elsif email.blank?
          return render_error('User', ['Email required'], 'Email missing')
        elsif username.blank?
          return render_error('User', ['Username required, minimum 3 characters'], 'Username missing')
        elsif password.blank? or !Devise.password_length.include?(password.length)
          return render_error('User', ['Password required, minimum 6 characters'], 'Password missing')
        elsif !(email =~  Devise.email_regexp)
          return render_error('User', ["Sorry, this doesn't seem to be a valid email" ], 'Invalid email')
        end
      end

    end  
  end
end
