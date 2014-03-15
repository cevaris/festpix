class User < ActiveRecord::Base
  TYPES = {:photographer =>'Photographer', :attendee=>'Attendee', :coordinator=>'Event Coordinator', :admin =>'Admin' }


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events
end
