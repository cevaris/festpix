Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
# Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:slug/:style/:filename'

Paperclip.interpolates :slug do |attachment, style|
  attachment.instance.slug
end