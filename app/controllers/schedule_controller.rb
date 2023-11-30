# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  # Put in a memory cache and cache header for the conclar data
  before_action :setup_cache_header

  # Cache index and particpant request for 10 minutes and prevent dog pile by allowing 1 minute regen
  caches_action :index, expires_in: 10.minute, race_condition_ttl: 1.minute
  caches_action :participants, expires_in: 10.minute, race_condition_ttl: 1.minute

  # 1. If prod always use the published schedule
  # 2. If staging or dev use published - if no published then use the live for testing
  # 3. cache mechanism (cache can be popultaed as part of the publish)
  # def index_old
  #   cached = PublicationDate.order('created_at desc').first&.publish_snapshots&.schedules&.first

  #   if cached
  #     render json: cached.snapshot, content_type: 'application/json'
  #   else
  #     sessions = SessionService.scheduled_sessions
  #     render json: ActiveModel::Serializer::CollectionSerializer.new(
  #               sessions,
  #               serializer: Conclar::SessionSerializer
  #             ),
  #             content_type: 'application/json'
  #   end
  # end

  def index
    links = params.permit(:links)[:links]

    serializer = links ? Conclar::SessionSerializerWithLinks : Conclar::SessionSerializer
    sessions = SessionService.scheduled_sessions
    render json: ActiveModel::Serializer::CollectionSerializer.new(
              sessions,
              serializer: serializer
            ),
            content_type: 'application/json'
  end


  def participants
    participants = SessionService.scheduled_people

    render json: ActiveModel::Serializer::CollectionSerializer.new(
              participants,
              serializer: Conclar::ParticipantSerializer
            ),
            content_type: 'application/json'
  end

  def setup_cache_header
    response.headers["Cache-Control"] = "public, max-age=#{10.minutes.to_i}"
  end
end
