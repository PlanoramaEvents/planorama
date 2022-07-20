# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  def index
    # TODO: we really need to use published sessions, this is fine for testing for now
    sessions = ReportsService.scheduled_sessions

    render plain: "var program = " + ActiveModel::Serializer::CollectionSerializer.new(
              sessions,
              serializer: Conclar::SessionSerializer
            ).to_json
  end

  def participants
    participants = ReportsService.scheduled_people

    render plain: "var people = " + ActiveModel::Serializer::CollectionSerializer.new(
              participants,
              serializer: Conclar::ParticipantSerializer
            ).to_json
  end
end
