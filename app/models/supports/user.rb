class Supports::User
  def initialize current_user, user
    @current_user = current_user
    @user = user
  end

  def new_active_relationships
    @current_user.active_relationships.build
  end

  def active_relationships
    @current_user.active_relationships.find_by followed_id: @user.id
  end
end
