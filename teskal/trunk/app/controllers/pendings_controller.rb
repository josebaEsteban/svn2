class PendingsController < ApplicationController
  before_filter :require_login, :require_suscription

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }

  def list
    @pending_pages, @pendings = paginate :pendings, :per_page => 10
  end

  def show
    @pending = Pending.find(params[:id])
  end

  def new
    @pending = Pending.new
  end

  def create
    @pending = Pending.new(params[:pending])
    if @pending.save
      flash[:notice] = 'Pending was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pending = Pending.find(params[:id])
  end

  def update
    @pending = Pending.find(params[:id])
    if @pending.update_attributes(params[:pending])
      flash[:notice] = 'Pending was successfully updated.'
      redirect_to :action => 'show', :id => @pending
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pending.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def add
    pending = Pending.new
    accion=params[:id].split('p')
    pending.user_id = accion[1]
    pending.quest_id = accion[0]
    pending.save
    journal( "pendings/add/"+accion[0]+"/"+pending.id.to_s, @logged_in_user.id)
    redirect_to :controller => 'my', :action => 'admin' , :id  => accion[1]
  end 
  
  def delete
    accion=params[:id].split('d')
    journal( "pendings/destroy/"+accion[1], @logged_in_user.id)
    Pending.delete(accion[0])
    redirect_to :controller => 'my', :action => 'admin' , :id  => accion[1]
  end

end
