class ApplicationController < ActionController::Base
    include ActionController::Cookies

rescue_from StandardError, with: :standard_error


end
