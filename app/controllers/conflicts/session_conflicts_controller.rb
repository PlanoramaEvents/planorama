class Conflicts::SessionConflictsController < ApplicationController
  respond_to :json

  # TODO: policies
  def index
    per_page = params[:perPage]&.to_i || Conflicts::SessionConflict.default_per_page
    current_page = params[:current_page]&.to_i

    collection = Conflicts::SessionConflict.includes([:session,:person,:session_assignment,:room]).distinct.page(current_page).per(per_page)

    collection_total = collection.total_count
    full_collection_total = Conflicts::SessionConflict.distinct.count

    meta = {}
    meta[:total] = collection_total
    meta[:full_total] = full_collection_total ? full_collection_total : collection_total
    meta[:current_page] = current_page if current_page.present?
    meta[:perPage] = per_page if per_page.present?

    options = {
      meta: meta,
      include: [
        :session,
        :conflict_session,
        :person,
        :session_assignment,
        :room
      ],
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }
    # options[:fields] = fields
    render json: Conflicts::SessionConflictSerializer.new(collection,options).serializable_hash(),
           content_type: 'application/json'
  end

  def conflicts_for
    session_id = params[:session_id]
    collection = Conflicts::SessionConflict.includes([:session,:person,:session_assignment,:room]).where(session_id: session_id).distinct

    meta = {}
    meta[:total] = collection.count

    options = {
      meta: meta,
      include: [
        :session,
        :conflict_session,
        :person,
        :session_assignment,
        :room
      ],
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }
    # options[:fields] = fields
    render json: Conflicts::SessionConflictSerializer.new(collection,options).serializable_hash(),
           content_type: 'application/json'
  end
end
