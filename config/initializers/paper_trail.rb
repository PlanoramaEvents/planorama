PaperTrail.config.enabled = true
PaperTrail.config.has_paper_trail_defaults = {
  on: %i[create update destroy]
}
PaperTrail.config.version_limit = 5

# PaperTrail.request.whodunnit = proc do
#   caller.find { |c| c.starts_with? Rails.root.to_s }
# end
