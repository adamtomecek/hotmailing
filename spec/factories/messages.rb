FactoryBot.define do
  factory :message do
    subject { "MyString" }
    from { "MyString" }
    to { "MyString" }
    cc { "MyString" }
    bcc { "MyString" }
    content { nil }
  end
end
