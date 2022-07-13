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
                  .includes([:session, :room])
                  .where("conflict_session_id = ?", session_id)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("session_conflicts.conflict_id not in (select conflict_id from ignored_conflicts)")
                  .where("(session_conflicts.conflict_type = 'room_conflict' AND session_conflicts.session_start_time != session_conflicts.conflict_session_start_time)")
                  .distinct
                # .where("session_conflicts.conflict_type != 'person_schedule_conflict' and session_conflicts.conflict_type != 'person_back_to_back'")

    meta = {}
    meta[:total] = collection.count

    options = {
      meta: meta,
      include: [
        :session
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
                  .includes([:conflict_session, :room])
                  .where("session_id = ?", session_id)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("conflict_session_assignment_name is null or conflict_session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .where("session_conflicts.conflict_id not in (select conflict_id from ignored_conflicts)")
                  .distinct

    meta = {}
    meta[:total] = collection.count

    options = {
      meta: meta,
      include: [
        :conflict_session
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
