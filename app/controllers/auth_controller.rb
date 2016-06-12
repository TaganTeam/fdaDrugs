class AuthController < ApplicationController


  def login
    @user = User.new
  end

  def registration
    @user = User.new
  end

end
