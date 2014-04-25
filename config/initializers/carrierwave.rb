require 'carrierwave/storage/ftp'

CarrierWave.configure do |config|
  config.ftp_host = "uploads.instrumentchamp.com"
  config.ftp_port = 21
  config.ftp_user = "inst1063"
  config.ftp_passwd = "LarsMagnus1!"
  config.ftp_folder = "uploads"
  config.ftp_url = "http://uploads.instrumentchamp.com"
  config.ftp_passive = true # false by default
end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :ftp
  end
end
