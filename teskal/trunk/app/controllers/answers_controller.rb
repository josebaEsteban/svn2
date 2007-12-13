class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.xml
  layout 'base'
  before_filter :require_login


  def index
    @answer = Answer.find_by_user_id(session[:user_id])
    # @answers = Answer.find(58)
  end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = Answer.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @answer.to_xml }
    end
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1;edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Answer.new(params[:answer])
    @answer.user_id=session[:user_id]
    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Answer was successfully created.'
        format.html { redirect_to answer_url(@answer) }
        format.xml  { head :created, :location => answer_url(@answer) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors.to_xml }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        flash[:notice] = 'Answer was successfully updated.'
        format.html { redirect_to answer_url(@answer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors.to_xml }
      end
    end
  end

  def switch
    answer = Answer.find(params[:id])
    user=User.find(answer.user_id )
    if  @logged_in_user.admin? or @logged_in_user.id == user.managed_by
      answer.toggle!(:browse)
      # if answer.browse == 0
      #   answer.browse = 1
      # else
      #   answer.browse = 0
      # end
      # answer.save 
      redirect_to :controller => 'my', :action => 'quest' , :id  => answer.user_id
    else  
      redirect_to :controller => 'my', :action => 'page'
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
      format.xml  { head :ok }
    end
  end
end
