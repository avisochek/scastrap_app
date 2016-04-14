class Feedback < ApplicationMailer
  def send_feedback(feedback_params)
    @params=feedback_params
    mail(to: ENV["my_email"],subject: 'feedback')
  end
end
