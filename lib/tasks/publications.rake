desc "Utils for published data"

namespace :pubs do
  # Utility to reset the published info - use while testing
  task reset: :environment do
    PublishedSession.destroy_all
    PublishSnapshot.delete_all
    PublicationDate.delete_all
    PublicationStatus.delete_all

    Audit::PublishedSessionVersion.delete_all
  end
end
