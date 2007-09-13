# Teskal

# Copyright (C) 2007 Teskal
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



class IssueRelationsController < ApplicationController
  layout 'base'
  before_filter :find_project, :authorize
  
  def new
    @relation = IssueRelation.new(params[:relation])
    @relation.issue_from = @issue
    @relation.save if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'issues', :action => 'show', :id => @issue }
      format.js do
        render :update do |page|
          page.replace_html "relations", :partial => 'issues/relations'
          if @relation.errors.empty?
            page << "$('relation_delay').value = ''"
            page << "$('relation_issue_to_id').value = ''"
          end
        end
      end
    end
  end
  
  def destroy
    relation = IssueRelation.find(params[:id])
    if request.post? && @issue.relations.include?(relation)
      relation.destroy
      @issue.reload
    end
    respond_to do |format|
      format.html { redirect_to :controller => 'issues', :action => 'show', :id => @issue }
      format.js { render(:update) {|page| page.replace_html "relations", :partial => 'issues/relations'} }
    end
  end
  
private
  def find_project
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
