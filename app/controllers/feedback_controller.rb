class FeedbackController < ApplicationController
  require "http"
  skip_before_action :verify_authenticity_token
  before_action :verify_message_existence
  before_action :verify_captcha
  def send_mail
    if Feedback.send_feedback(feedback_params).deliver_now
      render :response => 200, :json=>{:message=>"Feedback Sent!"}
    else
      render :response => 200, :json=>{:message=>"Something went wrong! Please try again later."}
    end
  end
  private
    def feedback_params
      params.permit(:name,:email,:message,:contact)
    end
    def verify_message_existence
      if params[:message].length<5
        render status => 200, :json=> {:message=> "Please include a message with at least 5 characters."}
      end
    end
    def verify_captcha
      uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')
      parammms = {:secret=>'6LfAPR0TAAAAALl9M67yfVJ4wUZ9h4UpBeV5WRk2',
          :response=>params['g-recaptcha-response']}
      response=HTTP.post(uri,:form=>parammms).parse
      if !response["success"]
        render status: 200, :json=> {:message=> "Something went wrong! Did you complete the captcha at the bottom before submitting?"}
      end
      nil
    end
end
