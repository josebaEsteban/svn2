class JournalsController < ApplicationController
  before_filter :require_admin
  # layout 'base' 

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }

  def list
    @journal_pages, @journals = paginate :journals, :order => 'created_on DESC', :per_page => 100
  end

  def show
    @journal = Journal.find(params[:id])
  end

  def new
    @journal = Journal.new
  end

  def create
    @journal = Journal.new(params[:journal])
    if @journal.save
      flash[:notice] = 'Journal was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journal = Journal.find(params[:id])
  end

  def update
    @journal = Journal.find(params[:id])
    if @journal.update_attributes(params[:journal])
      flash[:notice] = 'Journal was successfully updated.'
      redirect_to :action => 'show', :id => @journal
    else
      render :action => 'edit'
    end
  end

  def destroy
    Journal.find(params[:id]).destroy
    redirect_to :action => 'list'
  end


  def stats
    @users = User.count_by_sql "select count(*) from users"
    @quests = Answer.count_by_sql "select count(*) from answers"
    @emails= Journal.count_by_sql("select count(*) FROM journals WHERE event like 'mailer%'")
    @journals = Journal.paginate(:page => params[:page], :per_page => 50, :order => 'created_on DESC', :limit  => 500) 
    # puts params[:page]
    # @journals = Journal.paginate_by_sql(['select * from journals order by created_on DESC'],:page => params[:page], :per_page => 300)
  end

end
