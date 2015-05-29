class UserNotifier < ActionMailer::Base
  default from: "nthit90@gmail.com"

  def send_mail_toshare(to,subject,content,_email)
    @content=content
    if _email.present?

      mail(to:to,from: _email,subject: subject)
      render json: {:status=>true}
    else
      mail(to:to,from: "nthit90@gmail.com",subject: subject)
      render json: {:status=>true}
    end

  end

end
