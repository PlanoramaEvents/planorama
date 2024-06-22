# == Schema Information
#
# Table name: published_sessions
#
#  audience_size        :integer
#  description          :text
#  duration             :integer
#  environment          :enum             default("unknown")
#  integrations         :jsonb            not null
#  is_break             :boolean          default(FALSE)
#  lock_version         :integer          default(0)
#  minors_participation :jsonb
#  participant_notes    :text
#  pub_reference_number :integer
#  recorded             :boolean          default(FALSE), not null
#  require_signup       :boolean          default(FALSE)
#  short_title          :string(30)
#  start_time           :datetime
#  streamed             :boolean          default(FALSE), not null
#  title                :string
#  visibility           :enum             default("is_public")
#  waiting_list_size    :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  format_id            :uuid
#  room_id              :uuid
#  session_id           :uuid             not null, primary key
#
# Indexes
#
#  index_published_sessions_on_format_id  (format_id)
#
class PublishedSessionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at, :integrations
end
