class QuestionController < ApplicationController
  before_filter :require_verified_account
  
  def index
    @question = Question.new
  end
  
  def ask
    # Create a new question
    new_params = question_params
    new_params[:tags] = Tag.process_all(new_params[:tags])
    if new_params[:group]
      new_params[:group] = Group.find(new_params[:group])
    end
    @question = Question.new(new_params)
    @question.account = current_account
    
    authorize! :create, @question
    
    # Save the question
    if @question.save
      
      # Check if there's a group for this question
      if @question.group
        
        # Go through each member and send emails to each
        # with correct account settings
        @question.group.accounts.each do |account|
          # Don't send to the current account
          if account != current_account
            
            # Create a mail item
            mailer = TransactionMailer.group_post(@question, account)
            
            # Only send it if it's valid
            if mailer
              mailer.deliver
            end
          end
        end
      end
      
      # Redirect to the question
      redirect_to question_show_path(@question)
    else
      flash[:errors] = @question.errors.full_messages.join(", ")
      redirect_to :back
    end
  end
  
  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    @vote = Vote.new
    
    if @question.group
      unless current_account.group_member? @question.group
        flash[:error] = "You need to login to see this question"
        session[:routes] = { "login" => question_show_path(@question) }
        redirect_to :session_login and return
      end
    end
    
    # Get all the answers and sort them
    @answers = @question.answers.sort_by do |answer| 
      answer.votes.count
    end.reverse
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We couldn't find that question"
      redirect_to trending_path
  end
  
  def delete
    @question = Question.find(params[:id])
    authorize! :destroy, @question
    if @question.destroy
      flash[:notice] = "Good bye, dear question."
    else
      flash[:error] = "Well shoot, we couldn't delete that question."
    end
    redirect_to :trending
  end
  private
  def question_params
    params.require(:question).permit(:entry, :tags, :group)
  end
end
