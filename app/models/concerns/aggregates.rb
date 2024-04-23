module Aggregates
  extend ActiveSupport::Concern

  class_methods do
    # Generic mechanism to get the derived table for areas for Session and PublisheSession
    def area_list
      sessions = self.arel_table
      session_areas = Arel::Table.new(SessionArea.table_name)
      areas = Arel::Table.new(Area.table_name)

      id = (self == Session) ? :id : :session_id
      sessions.project(sessions[id].as('session_id'), array_aggregate_fn( areas[:name] ).as('area_list'))
        .join(session_areas, Arel::Nodes::OuterJoin).on(sessions[id].eq(session_areas[:session_id]))
        .join(areas, Arel::Nodes::OuterJoin).on(session_areas[:area_id].eq(areas[:id]))
        .group(sessions[id])
    end

    # Generic mechanism to get the derived table for tags for Session and PublisheSession
    def tags_list_table
      sessions = self.arel_table
      taggings = Arel::Table.new(ActsAsTaggableOn::Tagging.table_name)
      tags = Arel::Table.new(ActsAsTaggableOn::Tag.table_name)

      id = (self == Session) ? :id : :session_id
      taggable_type = (self == PublishedSession) ? 'PublishedSession' : 'Session'
      sessions.project(sessions[id].as('session_id'), array_aggregate_fn( tags[:name] ).as('tags_array'))
        .join(
          taggings,
          Arel::Nodes::OuterJoin
        ).on(sessions[id].eq(taggings[:taggable_id]).and(taggings[:taggable_type].eq(taggable_type)))
        .join(tags, Arel::Nodes::OuterJoin).on(taggings[:tag_id].eq(tags[:id]))
        .where(taggings[:context].eq('tags'))
        .group(sessions[id])
    end

    # Generic mechanism to get the derived table for labels for Session and PublisheSession
    def labels_list_table
      sessions = self.arel_table
      taggings = Arel::Table.new(ActsAsTaggableOn::Tagging.table_name)
      tags = Arel::Table.new(ActsAsTaggableOn::Tag.table_name)

      id = (self == Session) ? :id : :session_id
      taggable_type = (self == PublishedSession) ? 'PublishedSession' : 'Session'
      sessions.project(sessions[id].as('session_id'), array_aggregate_fn( tags[:name] ).as('labels_array'))
        .join(taggings, Arel::Nodes::OuterJoin).on(sessions[id].eq(taggings[:taggable_id]).and(taggings[:taggable_type].eq(taggable_type)))
        .join(tags, Arel::Nodes::OuterJoin).on(taggings[:tag_id].eq(tags[:id]))
        .where(taggings[:context].eq('labels'))
        .group(sessions[id])
    end
    
    def array_aggregate_fn(col)
      Arel::Nodes::NamedFunction.new('array_remove',[Arel::Nodes::NamedFunction.new('array_agg',[col]), Arel::Nodes::SqlLiteral.new("NULL")])
    end
  end
end