class User < ActiveRecord::Base
  TYPES = {:photographer =>'Photographer', :customer=>'Customer', :event=>'Event Coordinator', :admin =>'Admin' }


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events
end
