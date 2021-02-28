class OpinionsController < ApplicationController

  def new
    @opinion = Opinion.new
  end

  def create
    @opinion = Opinion.new(opinion_params)
    if @opinion.save
      flash[:success] = "ご意見を頂戴いたしました。ありがとうございます。"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  def opinion_params
    params.require(:opinion).permit(:content)
  end
end
