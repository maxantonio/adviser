# When the user clicks on Sign in with Linkedin link, they will redirects to the Linked login page, after entering their credentials it will again redirect the user back to the applications Callback method .
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    auth = env['omniauth.auth']
    @user = User.connect_to_linkedin(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Linkedin'
      sign_in_and_redirect @user, :event => :authentication
    else
      session['devise.linkedin_uid'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
