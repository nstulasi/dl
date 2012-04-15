require 'digest'
class User < ActiveRecord::Base
  has_many :delegations
  has_many :projects, :through => :delegations
  
  accepts_nested_attributes_for :delegations
  
  attr_accessor :password
  attr_accessor :project_user
  
  attr_accessible :id,:name, :email, :password, :password_confirmation, :delegations_attributes 
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
                  :length => {:maximum => 50}
 validates :email, :presence =>true,
                  :format => {:with => email_regex},
                 :uniqueness => {:case_sensitive => false},
                :if => :should_validate_user
                    
 validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 },
                      :if => :should_validate_user
                       
  before_save :encrypt_password

def should_validate_user
  project_user
end

def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
end
  
  def self.authenticate(email, submitted_password)
    user=find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt==cookie_salt) ? user : nil 
  end
  
private
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password=encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
   
   def secure_hash(string)
     Digest::SHA2.hexdigest(string)
   end
  
end
