#!/usr/bin/env ruby
require 'aws-sdk'
require 'optparse'
require 'json'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: set-aws-redirects.rb [options]"

  opts.on('-bBUCKET', '--bucket=BUCKET', 'S3 bucket') { |v| options[:bucket] = v }
  opts.on('-rPATH', '--redirects=PATH', 'Redirects file path') { |v| options[:redirects_file] = v }
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

begin

  bucket_name = options[:bucket]
  redirects_file = File.read(options[:redirects_file])
  redirects = JSON.parse(redirects_file)

  # Inspired from 
  # Setup S3 client
  COPY_TO_OPTIONS = [:multipart_copy, :content_length, :copy_source_client, :copy_source_region, :acl, :cache_control, :content_disposition, :content_encoding, :content_language, :content_type, :copy_source_if_match, :copy_source_if_modified_since, :copy_source_if_none_match, :copy_source_if_unmodified_since, :expires, :grant_full_control, :grant_read, :grant_read_acp, :grant_write_acp, :metadata, :metadata_directive, :tagging_directive, :server_side_encryption, :storage_class, :website_redirect_location, :sse_customer_algorithm, :sse_customer_key, :sse_customer_key_md5, :ssekms_key_id, :copy_source_sse_customer_algorithm, :copy_source_sse_customer_key, :copy_source_sse_customer_key_md5, :request_payer, :tagging, :use_accelerate_endpoint]

  s3 = Aws::S3::Resource.new
  bucket = s3.bucket(bucket_name)

  redirects.each do |from, to|
    # The object key to set the redirect on must be the index.html file and shouldn't start with `/`
    object_key = "#{from.gsub(%r{^/}, "").chomp('/')}/index.html"
    redirect_location = to

    # Get the object and all its metadata, permissions, etc 
    object_summary = bucket.object(object_key)

    # Get the object and all its metadata, permissions, etc 
    object = object_summary.get

    # Copy to the same location
    location = "#{bucket.name}/#{object_summary.key}"

    # Build a new options object
    options = {}

    # Merge in the object's existing properties, but only keeping valid attributes for the copy_to method
    existing_options = object.to_h.delete_if {|k,v| !COPY_TO_OPTIONS.include?(k) }
    options.merge!(existing_options)

    options.merge!({
      :acl => "public-read",
      :website_redirect_location => redirect_location,
      :metadata_directive => 'REPLACE'
    })

    if object.size >= 5_000_000_000
      options.merge!({multipart_copy: true})
    else
      # Only used if multipart_copy is true
      options.delete(:content_length)
    end

    begin
      object_summary.copy_to(location, options)
      puts "Set: '#{object_key}' -> '#{redirect_location}'"
    rescue => e
      puts "An error occured setting metadata '#{object_key}' -> '#{redirect_location}': #{e}"
    end
  end
rescue => e
  puts "An error occured: #{e}"
end