class BooksController < ApplicationController
  
  before_action :authenticate_user!
  
  before_action :correct_user, only: [:edit, :update]


  def show
    @book = Book.find(params[:id])
    @new = Book.new
    @user = User.find(current_user.id)

  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end



  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destoy
    @book = Book.find(params[:id])
    @book.destoy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def correct_user
    @book = Book.find(params[:id]) # idをもとにPost（投稿）を特定
    @user = @book.user             # 特定されたPostに紐づくUserを特定し、@userに入れる
    if current_user != @user       # 現在ログインしているユーザー（編集者）と@user（投稿者）が異なったら
      redirect_to books_path       # 一覧ページにリダイレクトさせる
    end
  end

end
