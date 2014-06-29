class Mailer < ActionMailer::Base
  def deliver(options = {})
    body = options.delete(:text)
    mail(options) do |format|
      format.text { render text: body }
    end.deliver
  end
end
