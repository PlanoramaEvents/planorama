# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  def index
    sessions = ReportsService.scheduled_sessions

    render json: ActiveModel::Serializer::CollectionSerializer.new(
              sessions,
              serializer: Conclar::SessionSerializer
            ),
            content_type: 'application/json'
  end

  def participants
    participants = ReportsService.scheduled_people

    render json: ActiveModel::Serializer::CollectionSerializer.new(
              participants,
              serializer: Conclar::ParticipantSerializer
            ),
            content_type: 'application/json'
  end
end
