class DepositPolicy < ApplicationPolicy

  attr_reader :user, :deposit

  def initialize (user, deposit)
    @user = user
    @deposit = deposit
  end
  

  def index?
    user.deposit? || user.admin?
  end

end