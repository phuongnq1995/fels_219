class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    return processed unless @user
    current_user.follow @user
    @active_rls = current_user.active_relationships.build
    respond
  end

  def destroy
    relationship = Relationship.find_by id: params[:id]
    return processed unless relationship
    @user = relationship.followed
    current_user.unfollow @user
    @active_rls = current_user.active_relationships.find_by followed_id: @user.id
    redirect_to @user
  end

  private
  def processed
    flash[:alert] = t "fails"
    redirect_to @user
  end

  def respond
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
