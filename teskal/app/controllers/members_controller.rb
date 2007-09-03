# Teskal

class MembersController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize

  def edit
    if request.post? and @member.update_attributes(params[:member])
  	 respond_to do |format|
        format.html { redirect_to :controller => 'projects', :action => 'settings', :tab => 'members', :id => @project }
        format.js { render(:update) {|page| page.replace_html "tab-content-members", :partial => 'projects/members'} }
      end
    end
  end

  def destroy
    @member.destroy
	respond_to do |format|
      format.html { redirect_to :controller => 'projects', :action => 'settings', :tab => 'members', :id => @project }
      format.js { render(:update) {|page| page.replace_html "tab-content-members", :partial => 'projects/members'} }
    end
  end

private
  def find_project
    @member = Member.find(params[:id]) 
    @project = @member.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
