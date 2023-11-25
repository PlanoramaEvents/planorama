# == Schema Information
#
# Table name: page_contents
#
#  id           :uuid             not null, primary key
#  html         :text             not null
#  lock_version :integer
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  unique_page_content  (name) UNIQUE
#
FactoryBot.define do
  factory :page_content do
    sequence(:name) { |n| "page #{n}" }
    html { "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>" }
  end
end
