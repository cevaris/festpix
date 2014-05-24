namespace :pc do

  task :move => :environment do
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]

    # bucket.objects.each do |obj|
    #   puts obj.key
    # end

    Photo.all.each do |photo|
      # path_arr = photo.image.path.split '/'
      # path_arr[5]
      # puts photo.image.path

      photo.image.options[:styles].each do |sytle, resolution|

        id_partition = "%03d" % photo.id
        source = "photos/images/000/000/#{id_partition}/#{sytle}/#{photo.image_file_name}"
        # print "\rChecking #{source}...."
        puts "Checking #{source}...."
        if bucket.objects[source].exists?
          puts "Found #{source}"
        end

      end
    end

    puts "...done."

  end
end