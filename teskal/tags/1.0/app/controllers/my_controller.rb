# Teskal


class MyController < ApplicationController
  layout 'base'
  before_filter :require_login

  # BLOCKS = { 'news' => :label_news_laquest,
  #   'documents' => :label_document_plural
  # }.freeze
  #
  # DEFAULT_LAYOUT = {  'left' => ['issuesassignedtome'],
  #   'right' => ['issuesreportedbyme']
  # }.freeze
  #
  # verify :xhr => true,
  # :session => :page_layout,
  # :only => [:add_block, :remove_block, :order_blocks]
  #

  def index
    page
    render :action => 'page'
  end

  # Show user's page
  def page
    store_location
    @titulo = get_label_quest
    @user = self.logged_in_user
    @answers = Answer.find_by_sql("select * from answers where answers.user_id=#{session[:user_id]}  order by answers.created_on DESC")
    # and answers.browse=1

    # @blocks = @user.pref[:my_page_layout] || DEFAULT_LAYOUT
    # @pendings = Pending.find_by_sql("select * from pendings where pendings.user_id=#{session[:user_id]} order by pendings.created_on DESC")
    @books = Book.find_by_sql("select * from books where books.user_id=#{session[:user_id]} order by books.order ASC")
    @quests = Quest.find_by_sql("select * from quests where quests.user_id=#{session[:user_id]} order by quests.order ASC")
  end

  def quest
    store_location
    @titulo = get_label_quest
    @user = self.logged_in_user
    @answers = Answer.find_by_sql("select * from answers where answers.user_id=#{session[:user_id]} and answers.browse=1 order by answers.created_on DESC")
    # @pendings = Pending.find_by_sql("select * from pendings where pendings.user_id=#{session[:user_id]} order by pendings.created_on DESC")
    @books = Book.find_by_sql("select * from books where books.user_id=#{session[:user_id]} order by books.order ASC")
    @quests = Quest.find_by_sql("select * from quests where quests.user_id=#{session[:user_id]} order by quests.order ASC")
  end

  def athletes
    store_location
    @user = self.logged_in_user
    if @logged_in_user.admin? and !params[:id].nil?
      id=params[:id].split('p')
      busca = id[0]
      @users = User.find_by_sql("select * from users where users.managed_by=#{busca} and  (users.status =1 or users.status=3) order by users.created_on DESC")
    else
      if @user.show?
        @users = User.find_by_sql("select * from users where users.managed_by=#{session[:user_id]} and  (users.status =1 or users.status=3) order by users.created_on DESC")
      else
        redirect_to :controller => 'my', :action => 'page'
      end
    end
  end

  def admin
    @titulo = get_label_quest
    @libro = get_label_book
    id=params[:id].split('p')
    if id[1].nil?
      @libreria = false
    else
      @libreria = true
    end
    busca = id[0]
    store_location
    @athlete = User.find(busca)
    @answers = Answer.find_by_sql("select * from answers where answers.user_id=#{busca} order by answers.created_on DESC")
    # @pendings = Pending.find_by_sql("select * from pendings where pendings.user_id=#{busca} order by pendings.created_on DESC")
    @books = Book.find_by_sql("select * from books where books.user_id=#{busca} order by books.order ASC")
    @quests = Quest.find_by_sql("select * from quests where quests.user_id=#{busca} order by quests.order ASC")
  end

  # Edit user's account
  def account
    @user = self.logged_in_user
    @pref = @user.pref
    @user.attributes = params[:user]
    @user.pref.attributes = params[:pref]
    if request.post? and @user.save and @user.pref.save
      journal("update account",@user.id)
      set_localization
      flash.now[:notice] = l(:notice_account_updated)
      self.logged_in_user.reload
    end
  end

  # Change user's password
  def change_password
    @user = self.logged_in_user
    # flash[:notice] = l(:notice_can_t_change_password) and redirect_to :action => 'account'
    if @user.check_password?(params[:password])
      @user.password, @user.password_confirmation = params[:new_password], params[:new_password_confirmation]
      @user.updated_on = Time.now
      if @user.save
        journal("update password",@user.id)
        flash[:notice] = l(:notice_account_password_updated)
      else
        render :action => 'account'
        return
      end
    else
      flash[:notice] = l(:notice_account_wrong_password)
    end
    redirect_to :action => 'account'
  end

  # User's page layout configuration
  def page_layout
    @user = self.logged_in_user
    @blocks = @user.pref[:my_page_layout] || DEFAULT_LAYOUT.dup
    session[:page_layout] = @blocks
    %w(top left right).each {|f| session[:page_layout][f] ||= [] }
    @block_options = []
    BLOCKS.each {|k, v| @block_options << [l(v), k]}
  end

  # Add a block to user's page
  # The block is added on top of the page
  # params[:block] : id of the block to add
  def add_block
    block = params[:block]
    render(:nothing => true) and return unless block && (BLOCKS.keys.include? block)
    @user = self.logged_in_user
    # remove if already present in a group
    %w(top left right).each {|f| (session[:page_layout][f] ||= []).delete block }
    # add it on top
    session[:page_layout]['top'].unshift block
    render :partial => "block", :locals => {:user => @user, :block_name => block}
  end

  # Remove a block to user's page
  # params[:block] : id of the block to remove
  def remove_block
    block = params[:block]
    # remove block in all groups
    %w(top left right).each {|f| (session[:page_layout][f] ||= []).delete block }
    render :nothing => true
  end

  # Change blocks order on user's page
  # params[:group] : group to order (top, left or right)
  # params[:list-(top|left|right)] : array of block ids of the group
  def order_blocks
    group = params[:group]
    group_items = params["list-#{group}"]
    if group_items and group_items.is_a? Array
      # remove group blocks if they are presents in other groups
      %w(top left right).each {|f|
        session[:page_layout][f] = (session[:page_layout][f] || []) - group_items
      }
      session[:page_layout][group] = group_items
    end
    render :nothing => true
  end

  # Save user's page layout
  def page_layout_save
    @user = self.logged_in_user
    @user.pref[:my_page_layout] = session[:page_layout] if session[:page_layout]
    @user.pref.save
    session[:page_layout] = nil
    redirect_to :action => 'page'
  end

end
