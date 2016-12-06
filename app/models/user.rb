class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w(manager employee).freeze

  before_create :set_default_role

  def roles=(roles)
    self.roles_mask = (Array(roles) & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      roles.include? role
    end
  end

  private

  def set_default_role
    return if manager? || employee?
    self.roles = 'employee'
  end
end
