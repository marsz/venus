
  belongs_to :auth, :polymorphic => true
  validates_presence_of :provider, :uid, :auth_type, :auth_id
  attr_accessible :provider, :uid, :auth_type, :auth_id, :auth_data
  serialize :auth_data, Hash
