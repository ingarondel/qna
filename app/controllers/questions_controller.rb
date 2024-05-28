class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :check_author, only: %i(update destroy)

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
  	 @answer = Answer.new
     @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Your question succesfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    redirect_to questions_path, notice: 'Question succesfully deleted.'
  end

  private

  def publish_question
    return if @questiom.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationCoontroller.render(
      partial: 'questions/question',
      locals: {question: @question})
      end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end

  def check_author
    redirect_to @question, notice: 'You are not author' unless current_user.is_author?(@question)
  end
end