class RegistrationsController < Devise::RegistrationsController


  layout false

  def new
  end

  def create
    @user = User.new(params[:user].slice(:username, :password, :email))

    if @user.valid?
      @user.save!
      sign_in @user
      check_invite_code @user
      render nothing: true, status: 200
    else
      render :new, status: 422
    end
    
  end

  def edit 
  end

  def update
    @user = User.find(current_user.id)


    # u.avatar = params[:file]
    # u.avatar = File.open('somewhere')
    # u.save!
    # u.avatar.url # => '/url/to/file.png'
    # u.avatar.current_path # => 'path/to/file.png'
    # u.avatar.identifier # => 'file.png'

    # throw params[:user][:profile_a]
    successfully_updated = if needs_password?(@user, params) 
      @user.update_with_password(params[:user])
      @user.errors.delete :current_password
      @user.errors.count > 0 ? false : @user.save
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
      @user.save
    end

    if successfully_updated
      # throw ActionMailer::Base.smtp_settings
      #UserMailer.welcome_email(@user).deliver

      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      render nothing: true, status: 200
    else
      render :edit, status: 422
    end
  end

  private

  def check_invite_code(user)
    return unless code = params[:invite_code]
    return unless inviter = User.find_by_uuid(code)
    Friendship.auto_friend user, inviter
    rescue => msg
      Log.error "Unable to auto friend #{user} with inviter #{inviter}, code: #{code}: #{msg}"
  end

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].present?
    # false
  end
end