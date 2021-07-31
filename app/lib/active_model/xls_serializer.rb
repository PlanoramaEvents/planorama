#
# NOTE: this is a variantion of the Active Model serializer, changed so that we
# can support serializetion to Excel
#

# XlsSerializer is modeled on the Active Model Serializer
# and provide a base for serializer object to Excel
module ActiveModel
  class XlsSerializer < ActiveModel::Serializer
    include ActiveModel::XlsSerializerMethods
  end
end
