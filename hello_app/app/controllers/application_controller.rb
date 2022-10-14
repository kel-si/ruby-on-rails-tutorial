class ApplicationController < ActionController::Base
    # adding an action called hello to application controller
    def hello
        render html: "Hello, world!"
    end
end
