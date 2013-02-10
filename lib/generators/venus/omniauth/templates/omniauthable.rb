module Omniauthable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, :dependent => :destroy, :as => :auth
  end

  module ClassMethods

    def find_or_create_by_omniauth(authhash)
      authorization = Authorization.find_by_provider_and_uid(authhash['provider'], authhash['uid'])
      return authorization.auth if authorization
      user = send "initialize_from_omniauth_#{authhash['provider']}", authhash
      if User.find_by_email(user.email)
        user = _
      else
        user.save
        user.bind_service(authhash)
      end
      user
    end

    private

    def initialize_from_omniauth_facebook(authhash)
      User.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
    end

    def initialize_from_omniauth_twitter(authhash)
      User.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
    end

    def initialize_from_omniauth_github(authhash)
      User.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
    end

  end

  def bind_service(authhash)
    authorization = Authorization.find_by_provider_and_uid(authhash['provider'], authhash['uid'])
    unless authorization
      authorization = authorizations.create! :uid => authhash['uid'], :provider => authhash['provider'], :auth_data => authhash
    end
    authorization
  end

  def can_bind_to
    Setting.providers - (authorizations.map {|auth| auth.provider})
  end

  def password_required?
    false
  end


end