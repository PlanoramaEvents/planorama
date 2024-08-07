# == Schema Information
#
# Table name: people
#
#  id                              :uuid             not null, primary key
#  accommodations                  :string(10000)
#  age_at_convention               :string
#  attendance_type                 :string(200)
#  availability_notes              :string
#  bio                             :text
#  black_diaspora                  :string(10000)
#  bsky                            :string
#  can_photo                       :enum             default("no")
#  can_photo_exceptions            :string(10000)
#  can_record                      :enum             default("no")
#  can_record_exceptions           :string(10000)
#  can_share                       :boolean          default(FALSE), not null
#  can_stream                      :enum             default("no")
#  can_stream_exceptions           :string(10000)
#  comments                        :text
#  con_state                       :enum             default("not_set")
#  confirmation_sent_at            :datetime
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  current_sign_in_at              :datetime
#  current_sign_in_ip              :inet
#  date_reg_synced                 :datetime
#  demographic_categories          :string
#  do_not_assign_with              :string(10000)
#  encrypted_password              :string           default(""), not null
#  ethnicity                       :string(400)
#  excluded_demographic_categories :string
#  facebook                        :string
#  failed_attempts                 :integer          default(0), not null
#  fediverse                       :string
#  flickr                          :string
#  gender                          :string(400)
#  global_diaspora                 :string
#  indigenous                      :string(10000)
#  instagram                       :string
#  integrations                    :jsonb            not null
#  is_local                        :boolean          default(FALSE)
#  job_title                       :string
#  language                        :string(5)        default("")
#  languages_fluent_in             :string(10000)
#  last_sign_in_at                 :datetime
#  last_sign_in_ip                 :inet
#  linkedin                        :string
#  lock_version                    :integer          default(0)
#  locked_at                       :datetime
#  moderation_experience           :string(10000)
#  name                            :string           default("")
#  name_sort_by                    :string
#  name_sort_by_confirmed          :boolean          default(FALSE)
#  needs_accommodations            :boolean          default(FALSE)
#  non_anglophone                  :string
#  non_us_centric_perspectives     :string(10000)
#  opted_in                        :boolean          default(FALSE), not null
#  organization                    :string
#  othered                         :string(10000)
#  othersocialmedia                :string
#  pronouns                        :string(400)
#  pseudonym                       :string
#  pseudonym_sort_by               :string
#  pseudonym_sort_by_confirmed     :boolean          default(FALSE)
#  published_name                  :string
#  published_name_sort_by          :string
#  reddit                          :string
#  reg_attending_status            :string
#  reg_match                       :enum             default("none")
#  registered                      :boolean          default(FALSE), not null
#  registration_number             :string
#  registration_type               :string
#  remember_created_at             :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  romantic_sexual_orientation     :string
#  sign_in_count                   :integer          default(0), not null
#  tiktok                          :string
#  timezone                        :string(500)
#  twelve_hour                     :boolean          default(TRUE)
#  twitch                          :string
#  twitter                         :string
#  unconfirmed_email               :string
#  unlock_token                    :string
#  website                         :string
#  willing_to_moderate             :boolean          default(FALSE)
#  year_of_birth                   :integer
#  youtube                         :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  reg_id                          :string
#
# Indexes
#
#  idx_people_reg_id                     (reg_id) UNIQUE
#  index_people_on_bio                   (bio) USING gin
#  index_people_on_confirmation_token    (confirmation_token) UNIQUE
#  index_people_on_name                  (name) USING gin
#  index_people_on_pseudonym             (pseudonym) USING gin
#  index_people_on_published_name        (published_name) USING gin
#  index_people_on_reset_password_token  (reset_password_token) UNIQUE
#  index_people_on_unlock_token          (unlock_token) UNIQUE
#
class PersonSyncDatumSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :name_sort_by, :name_sort_by_confirmed,
             :pseudonym, :pseudonym_sort_by, :pseudonym_sort_by_confirmed,
             :published_name, :published_name_sort_by,
             :job_title, :organization, :reg_id,
             :primary_email, :contact_email,
             :reg_match, :date_reg_synced

  # has_many  :email_addresses, 
  #             lazy_load_data: true, serializer: EmailAddressSerializer
  #             links: {
  #               self: -> (object, params) {
  #                 "#{params[:domain]}/person/#{object.id}"
  #               },
  #               related: -> (object, params) {
  #                 "#{params[:domain]}/person/#{object.id}/email_addresses"
  #               }
  #             }
  
  # The reg data that this person could be matched to
  has_many :registration_sync_data, serializer: RegistrationSyncDatumSerializer
              # links: {
              #   self: -> (object, params) {
              #     "#{params[:domain]}/person_sync_data/#{object.id}"
              #   },
              #   related: -> (object, params) {
              #     "#{params[:domain]}/registration_sync_datum/#{object.id}/registration_sync_data"
              #   }
              # }
end
