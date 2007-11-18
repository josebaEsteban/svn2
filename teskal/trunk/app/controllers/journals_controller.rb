class JournalsController < ApplicationController
  # GET /journals
  # GET /journals.xml
  def index
    @journals = Journal.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @journals.to_xml }
    end
  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    @journal = Journal.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @journal.to_xml }
    end
  end

  # GET /journals/new
  def new
    @journal = Journal.new
  end

  # GET /journals/1;edit
  def edit
    @journal = Journal.find(params[:id])
  end

  # POST /journals
  # POST /journals.xml
  def create
    @journal = Journal.new(params[:journal])

    respond_to do |format|
      if @journal.save
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to journal_url(@journal) }
        format.xml  { head :created, :location => journal_url(@journal) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal.errors.to_xml }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    @journal = Journal.find(params[:id])

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to journal_url(@journal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal.errors.to_xml }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to journals_url }
      format.xml  { head :ok }
    end
  end
end
