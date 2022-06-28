class Conflicts::SessionConflictsController < ApplicationController
  respond_to :json

  # Add the requested conflict id to the ignored conflicts
  def ignore
    authorize Conflicts::SessionConflict, policy_class: Conflicts::SessionConflictPolicy

    IgnoredConflict.transaction do
      permitted = params.permit(:conflict_id, :conflict_type)

      ignored = IgnoredConflict.create(permitted)
    end

    render status: :ok, json: {}.to_json, content_type: 'application/json'
  end

  def conflicts_with
    authorize Conflicts::SessionConflict, policy_class: Conflicts::SessionConflictPolicy

    session_id = params[:session_id]
    collection = Conflicts::SessionConflict
                  .includes([:session])
                  .where("conflict_session_id = ?", session_id)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .distinct

    meta = {}
    meta[:total] = collection.count

    options = {
      meta: meta,
      include: [
        # :session
      ],
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }
    render json: Conflicts::SessionConflictSerializer.new(collection,options).serializable_hash(),
           content_type: 'application/json'
  end

  def conflicts_for
    authorize Conflicts::SessionConflict, policy_class: Conflicts::SessionConflictPolicy

    session_id = params[:session_id]
    collection = Conflicts::SessionConflict
                  .includes([:conflict_session])
                  .where("session_id = ?", session_id)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .distinct

    meta = {}
    meta[:total] = collection.count

    options = {
      meta: meta,
      include: [
        # :conflict_session
      ],
      params: {
        domain: "#{request.base_url}",
        current_person: current_person
      }
    }
    render json: Conflicts::SessionConflictSerializer.new(collection,options).serializable_hash(),
           content_type: 'application/json'
  end
end
