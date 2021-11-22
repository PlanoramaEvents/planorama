class MailTemplatesController < ResourceController
  SERIALIZER_CLASS = 'MailTemplateSerializer'.freeze

  # Check if in mailing and mailing is scheduled
  def before_update
    nbr_scheduled = @object.mailings.where(scheduled: true).count
    raise "Template associated with schedule mailing, you can not edit it." if nbr_scheduled > 0
  end
end
