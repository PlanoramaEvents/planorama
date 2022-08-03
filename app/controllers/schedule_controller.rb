# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  # 1. If prod always use the published schedule
  # 2. If staging or dev use published - if no published then use the live for testing
  # 3. cache mechanism (cache can be popultaed as part of the publish)
  def index
    snapshot = PublicationDate.order('created_at desc').first.publish_snapshots.schedules.first

    if snapshot
      render json: snapshot, content_type: 'application/json'
    else
      sessions = SessionService.scheduled_sessions
      render json: ActiveModel::Serializer::CollectionSerializer.new(
                sessions,
                serializer: Conclar::SessionSerializer
              ),
              content_type: 'application/json'
    end
  end

  def participants
    snapshot = PublicationDate.order('created_at desc').first.publish_snapshots.participants.first

    if snapshot
      render json: snapshot, content_type: 'application/json'
    else
      participants = SessionService.scheduled_people

      render json: ActiveModel::Serializer::CollectionSerializer.new(
                participants,
                serializer: Conclar::ParticipantSerializer
              ),
              content_type: 'application/json'
    end
  end
end
