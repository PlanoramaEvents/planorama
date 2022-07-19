class SnapshotWorker
  include Sidekiq::Worker
  # sidekiq_options retry: true

  def perform(id)
    SnapshotService.startSnapshot(id: id)
  end
end
