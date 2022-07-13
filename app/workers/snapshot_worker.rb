class SnapshotWorker
  include Sidekiq::Worker
  # sidekiq_options retry: true

  def perform(label, author)
    SnapshotService.startSnapshot(label: label, author: author)
  end
end
