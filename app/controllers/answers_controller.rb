class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer has been successfully created.'
    else
     render :new
    end
  end

  def new
	    @answer = @question.answers.new
	end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end