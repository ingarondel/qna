class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: %i( edit update destroy)
  before_action :check_author, only: %i(update destroy)

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
    respond_to do |format|
      format.html  { render @answer }
    end
    else
     format.html { render partial: 'shared/errors', locals: {resource: @answer}, status: :unproccessable_entity}
    end
  end

  def new
	    @answer = @question.answers.new
  end

  def edit
  end
  
  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render 'questions/show', notice: 'Your answer succesfully updated.'
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Answer succesfully deleted.'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def check_author
    redirect_to @answer.question, notice: 'You are not author' unless current_user.is_author?(@answer)
  end
end