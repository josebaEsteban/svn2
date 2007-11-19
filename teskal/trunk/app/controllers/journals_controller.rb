class JournalsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @journals_pages, @journals = paginate :journals, :per_page => 100
  end

  def show
    @journals = Journals.find(params[:id])
  end

  def new
    @journals = Journals.new
  end

  def create
    @journals = Journals.new(params[:journals])
    if @journals.save
      flash[:notice] = 'Journals was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @journals = Journals.find(params[:id])
  end

  def update
    @journals = Journals.find(params[:id])
    if @journals.update_attributes(params[:journals])
      flash[:notice] = 'Journals was successfully updated.'
      redirect_to :action => 'show', :id => @journals
    else
      render :action => 'edit'
    end
  end

  def destroy
    Journals.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
