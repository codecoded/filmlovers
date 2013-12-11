module Api
  module V1
    class TokensController  < BaseController 
      skip_before_filter :verify_authenticity_token
      respond_to :json
      
      def create
        password = params[:password]
        username = params[:username]

        # if request.format != :json
        #     render :status=>406, :json=>{:message=>"The request must be json"}
        #     return
        # end
        
        if  password.nil?  or username.nil?
          render :status=>400, :json=>{:message=>"The request must contain the user username and password."}
          return
        end
        
        @user = User.find_by_username username.downcase
        
        if @user.nil?
          Log.info("User #{username} failed signin, user cannot be found.")
          render :status=>401, :json=>{:message=>"Invalid username or password."}
          return
        end
        
        if not @user.valid_password?(password) 
          Log.info("User #{username} failed signin, password \"#{password}\" is invalid")
          render :status=>401, :json=>{:message=>"Invalid email or password."} 
          return
        end

        @user.save   
        @current_user = @user
      end
      
      def destroy
        @user=User.find_by_authentication_token(params[:id])
        if @user.nil?
          logger.info("Token not found.")
          render :status=>404, :json=>{:message=>"Invalid token."}
        else
          @user.reset_authentication_token!
          render :status=>200, :json=>{:token=>params[:id]}
        end
      end  

    end  

  end
end
