class ApplicationMailer < ActionMailer::Base
  default from: 'hello@jamesgallagher.io'

  def reset_password
   @user = params[:user]
   @code  = params[:code]
   mail(to: @user.email, subject: 'Welcome to JamesGallagher.io')
 end
end
