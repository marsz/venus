module Omniauthable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, :dependent => :destroy, :as => :auth
  end

  module ClassMethods

    def find_or_create_by_omniauth(authhash)
      authorization = Authorization.find_by_provider_and_uid(authhash['provider'], authhash['uid'])
      return authorization.auth if authorization
      instance = send "initialize_from_omniauth_#{authhash['provider']}", authhash
      if u = self.find_by_email(instance.email)
        instance = u
      else
        instance.save
      end
      instance.bind_service(authhash)
      instance
    end

    private

    def initialize_from_omniauth_facebook(authhash)
      self.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
    end

    def initialize_from_omniauth_twitter(authhash)
      self.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
    end

    def initialize_from_omniauth_github(authhash)
      self.new(:email => authhash['info']['email'], :name => authhash['info']['name'])
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
    Setting.providers - has_binds
  end

  def has_binds
    authorizations.map(&:provider)
  end


  def password_required?
    false
  end


end