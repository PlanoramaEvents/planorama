class Conflicts::SessionConflictsController < ApplicationController
  respond_to :json

  def index
    per_page = params[:perPage]&.to_i || Session.default_per_page
    current_page = params[:current_page]&.to_i

    collection = Session.joins(:availability_conflicts).distinct.page(current_page).per(per_page)

    collection_total = collection.total_count
    full_collection_total = Session.joins(:availability_conflicts).distinct.count

    meta = {}
    meta[:total] = collection_total
    meta[:full_total] = full_collection_total ? full_collection_total : collection_total
    meta[:current_page] = current_page if current_page.present?
    meta[:perPage] = per_page if per_page.present?

    options = {
      meta: meta,
      include: [
        :availability_conflicts,
        :'availability_conflicts.person',
        :'availability_conflicts.session_assignment',
        :room
      ],
      # include: filtered_serializer_includes(fields: fields), # need to adjust based omn field
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
