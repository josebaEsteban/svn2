class QuestsController < ApplicationController
  before_filter :require_login

  def index
    @users = User.find(:all)
    for user in @users
      1.upto(Quest::CATALOG) {|number| quest = Quest.new
        quest.user_id = user.id
        quest.order = number
        if user.show?
          quest.browse = true
        else
          if Quest::FREE.include?(number)
            quest.browse = true
          else
            quest.browse = false
          end
        end
      quest.save}
    end
  end

  def switch
    quest = Quest.find(params[:id])
    user = User.find(quest.user_id)
    if @logged_in_user.admin? or @logged_in_user.id == user.managed_by
      quest.toggle!(:browse)
      journal( "quest/"+quest.browse.to_s+"/"+quest.order.to_s+"/"+user.id.to_s, @logged_in_user.id)
      redirect_to :controller => 'my', :action => 'admin' , :id  => quest.user_id.to_s
    else
      redirect_to :controller => 'my', :action => 'page'
    end
  end

end
