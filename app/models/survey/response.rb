class Survey::Response < ApplicationRecord
  belongs_to :question,
             class_name: 'Survey::Question',
             foreign_key: 'question_id'

  belongs_to :submission,
             class_name: 'Survey::Submission',
             foreign_key: 'submission_id',
             inverse_of: :responses

  before_save :set_response_text

  #
  # Deal with linked_field from question
  #
  def update_linked
    if question.linked_field && submission.person
      # TODO
      # we can set the linked field on the person
    end
  end

  def get_linked
    if question.linked_field && submission.person
      # TODO
      # we can get the linked field on the person and set the value accordingly
    end
  end

  def self.create_response(question:, submission:, value:)
    json_val = empty_json
    case question.question_type
         when :textfield
           json_val[:text] = value
         when :textbox
           json_val[:text] = value
         when :singlechoice
           json_val[:answers] = value
         when :multiplechoice
           json_val[:answers] = value
         when :dropdown
           json_val[:answers] = value
         # when :address
         #   empty_json[:address] = value
         when :socialmedia
           json_val[:socialmedia] = value
         # when :textonly, :hr are not actual questions
         # when :email
         #   {
         #     text: nil,
         #     answers: [nil],
         #     address: value,
         #     socialmedia: {
         #       twitter: nil, facebook: nil, linkedin: nil, twitch: nil, youtube: nil, instagram: nil, tiktok: nil, other: nil, website: nil
         #     }
         #   }
         else
           json_val = nil
         end

    if json_val
      Survey::Response.create!(
        question: question,
        submission: submission,
        response: json_val
      )
    end
  end

  #
  # Extract the values from all the entries and save a plain text
  # version that can be used for searchin the responses in a "report"
  #
  def set_response_text
    flattened_response = flatten_response(response)

    strip_uuid = [:singlechoice, :multiplechoice].include?(question.question_type)
    if strip_uuid
      self.response_as_text = flattened_response.values.flatten.collect{|v| v[37..-1]}.reject { |e| e.to_s.empty? }.join('; ').strip
    else
      self.response_as_text = flattened_response.values.join(' ').strip
    end
  end

  #
  def flatten_response(hash)
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_response(v).map do |h_k, h_v|
          if k == 'socialmedia'
            h["#{k}.#{h_k}".to_sym] = "#{h_k}:#{h_v}" unless h_v.blank?
          else
            h["#{k}.#{h_k}".to_sym] = h_v unless h_v.blank?
          end
        end
      else
        h[k] = v
      end
    end
  end

  private

  def self.empty_json
    {
      text: "",
      answers: [],
      address: {
        street: nil, street2: nil, city: nil, state: nil, zip: nil, country:nil
      },
      socialmedia: {
        twitter: nil, facebook: nil, linkedin: nil, twitch: nil, youtube: nil, instagram: nil, tiktok: nil, other: nil, website: nil
      }
    }
  end
end
