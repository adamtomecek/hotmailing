class ApplicationMailbox < ActionMailbox::Base
  routing all: :inbox
end
