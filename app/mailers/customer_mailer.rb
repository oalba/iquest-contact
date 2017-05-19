class CustomerMailer < ApplicationMailer
  default from: "company@gmail.com"
  def url_email(customer)
    @customer = customer
    # @url = "/me/" << @customer.id
    mail(to: @customer.email, subject: 'Welcome')
  end

  def changes_email(customer, admin)
    @customer = customer
    @admin = admin
    # @url = "/me/" << @customer.id
    mail(to: @admin.email, subject: 'Customer changes')
  end
end
