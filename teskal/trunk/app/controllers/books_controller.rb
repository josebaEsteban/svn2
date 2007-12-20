class BooksController < ApplicationController
  before_filter :require_login

  # GET /books
  # GET /books.xml
  def index
    @users = User.find(:all)
    for user in @users
      1.upto(Book::CATALOG) {|number| book = Book.new
        book.user_id = user.id
        book.order = number
        if user.show?
          book.browse = true
        else
          if number == Book::FREE
            book.browse = true
          else
            book.browse = false
          end
        end
      book.save}

    end

    @books = Book.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(params[:book])

    respond_to do |format|
      if @book.save
        flash[:notice] = 'Book was successfully created.'
        format.html { redirect_to(@book) }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        flash[:notice] = 'Book was successfully updated.'
        format.html { redirect_to(@book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(books_url) }
      format.xml  { head :ok }
    end
  end

  def switch
    book = Book.find(params[:id])
    user = User.find(book.user_id)
    if @logged_in_user.admin? or @logged_in_user.id == user.managed_by
      book.toggle!(:browse)
      # if book.browse == 0
      #   book.browse = 1
      # else
      #   book.browse = 0
      # end
      # book.save 
      redirect_to :controller => 'my', :action => 'quest' , :id  => book.user_id.to_s+"/L"
    else
      redirect_to :controller => 'my', :action => 'page'
    end
  end

  def populate
    @users = User.find(:all)
    for user in @users
      create_library(user.id)
    end
  end
end
