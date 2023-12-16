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
class PageContentSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :html, :name
end
