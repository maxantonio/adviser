class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  def self.connect_to_linkedin2(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      puts user.inspect
      return user
    else

      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        puts 'Informacion que viene en el auth.info'
        puts auth.info.inspect

        user = User.create(provider: auth.provider, uid: auth.uid, email: auth.info.email, password: Devise.friendly_token[0, 20],)
      end
    end
  end

  # Intentando conectar con Linkedin
  def self.connect_to_linkedin(auth, signed_in_resource=nil)

    # Preguntando si el usuario esta registrado ya con linkedin
    profile = Profile.where(:provider => auth.provider, :uid => auth.uid).first
    if profile
      return profile.user
    else

      # Busco si el usuario esta registrado
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else

        # Registrar el usuario
        puts 'Informacion que viene en el auth.info'
        puts auth.info.inspect

        user = User.create(email: auth.info.email, password: Devise.friendly_token[0, 20])
        Profile.create(
            provider: auth.provider, uid: auth.uid, first_name: nil,
            last_name: nil, url_image: nil, url_profile: nil,
            country: nil, description: nil, user_id: user.id
        )
        return user
      end
    end
  end

end
