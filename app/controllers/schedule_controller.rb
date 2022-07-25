# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  # 1. If prod always use the published schedule
  # 2. If staging or dev use published - if no published then use the live for testing
  # 3. Put in a cache mechanism (cache can be popultaed as part of the publish)
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
