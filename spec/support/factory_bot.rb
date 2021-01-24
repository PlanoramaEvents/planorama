require 'factory_bot'

RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
    config.before(:suite) { FactoryBot.reload }
end
