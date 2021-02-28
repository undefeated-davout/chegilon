class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:success] = "お問い合わせありがとうございます。"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:email, :contact_category_id, :title, :content)
  end
end
