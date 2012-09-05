class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by_email(auth_hash.uid)
    sign_in(@user) unless self.current_user == @user
    redirect_back_or '/'
  end


  def destroy
    sign_out
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
