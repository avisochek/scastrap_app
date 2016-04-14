class FeedbackController < ApplicationController
  require "http"
  skip_before_action :verify_authenticity_token
  before_action :verify_captcha
  def send_mail
    Feedback.send_feedback.deliver_now
    render :response => 200, :json=>{:message=>"yo"}
  end
  private
    def verify_captcha
      uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')
      parammms = {:secret=>'6LfAPR0TAAAAALl9M67yfVJ4wUZ9h4UpBeV5WRk2',
          :response=>params['g-recaptcha-response']}
      response=HTTP.post(uri,:form=>parammms).parse
      if !response["success"]
        render status: 403, json: {message: "captcha failed"}
      end
      nil
    end
end
