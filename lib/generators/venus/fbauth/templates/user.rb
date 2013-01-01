
  def self.create_by_omniauth(hash, current_user)
    hash = ActiveSupport::HashWithIndifferentAccess.new hash
    user = User.send("find_by_#{hash[:provider]}_id", hash[:uid])
    unless user
      user = current_user || User.find_by_email(hash[:info][:email]) || User.new( :email => hash[:info][:email], :name => hash[:info][:name] )
      user.send("#{hash[:provider]}_id=", hash[:uid])
      user.save!
    end
    user
  end

  def password_required?
    facebook_id.present? ? false : true
  end
