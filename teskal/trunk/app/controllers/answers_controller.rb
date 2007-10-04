class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.xml
  layout 'base'
  before_filter :require_login


  def index
    @answer = Answer.find_by_user_id(session[:user_id])
    # @answers = Answer.find(58)
    puts @answer
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
  def quest2
    @answer = Answer.new(params[:answer])
    @answer.questionnare_id=2
    @answer.user_id=session[:user_id]
    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Answer was successfully created.'
        redirect_to :controller => 'quest2', :action => 'default', :id => @answer

        # format.html { redirect_to answer_url(@answer) }
        # format.xml  { head :created, :location => answer_url(@answer) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors.to_xml }
      end
    end
  end
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
