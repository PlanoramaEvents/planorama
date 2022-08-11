class PublicationWorker
  include Sidekiq::Worker

  def perform
    # 0. we need to set the timezone?
    # 2. Publish
    # 3. Popultaed any caches that we need
    pub_date = nil
    PublishedSession.transaction do
      last_pub = PublicationDate.order('timestamp desc').first
      last_time = last_pub&.timestamp

      # DO WORK
      result = PublicationService.publish(since: last_time)

      pub_date = PublicationDate.new
      pub_date.timestamp = DateTime.current
      pub_date.update(result)
      pub_date.save!

      # do we want the counts in this
      # if so we need a completed_at time ?????
      pstatus = PublicationStatus.order('created_at desc').first
      pstatus = PublicationStatus.new if pstatus == nil
      pstatus.status = 'completed'
      pstatus.save!
    end

    # populate basic caches
    if pub_date
      PublishedSession.transaction do
        SessionService.cache_published_sessions(publication_date: pub_date)
        SessionService.cache_published_participants(publication_date: pub_date)
      end
    end
  end
end
