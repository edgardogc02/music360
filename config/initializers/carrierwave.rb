require 'carrierwave/storage/ftp'

CarrierWave.configure do |config|
  config.ftp_host = "ftp.instrumentchamp.com"
  config.ftp_port = 21
  config.ftp_user = "inst1063"
  config.ftp_passwd = "LarsMagnus1!"
  config.ftp_folder = ""
  config.ftp_url = "ftp://ftp.instrumentchamp.com"
  config.ftp_passive = true # false by default
end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end