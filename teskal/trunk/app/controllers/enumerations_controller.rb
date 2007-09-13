# Teskal


#

# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 


# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License



class EnumerationsController < ApplicationController
  layout 'base'
  before_filter :require_admin
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  end

  def new
    @enumeration = Enumeration.new(:opt => params[:opt])
  end

  def create
    @enumeration = Enumeration.new(params[:enumeration])
    if @enumeration.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'list', :opt => @enumeration.opt
    else
      render :action => 'new'
    end
  end

  def edit
    @enumeration = Enumeration.find(params[:id])
  end

  def update
    @enumeration = Enumeration.find(params[:id])
    if @enumeration.update_attributes(params[:enumeration])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'list', :opt => @enumeration.opt
    else
      render :action => 'edit'
    end
  end

  def destroy
    Enumeration.find(params[:id]).destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to :action => 'list'
  rescue
    flash[:notice] = "Unable to delete enumeration"
    redirect_to :action => 'list'
  end
end
