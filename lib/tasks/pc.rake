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

      id_partition = "%03d" % photo.id
      styles = photo.image.options[:styles].keys << :original

      styles.each do |sytle|

        source_path = "photos/images/000/000/#{id_partition}/#{sytle}/#{photo.image_file_name}"
        print "\rChecking #{source_path}...."
        # puts "Checking #{source_path}...."
        if bucket.objects[source_path].exists?
          # puts "\nCopying #{source_path} to #{photo.image.path}"

          # source_object = bucket.objects[source_path]
          # target_object = bucket.objects[photo.image.path]
          source_object = AWS::S3::S3Object.new(bucket, source_path)
          target_object = AWS::S3::S3Object.new(bucket, photo.image.path[1..-1])
          puts "\n#{photo.image.path}"

          target_object.delete()
          source_object.copy_to(target_object.key)
          # bucket.objects[photo.image.path].copy_from(source_object)
          # puts "\nTransfered #{target_object.key}"
        end

      end


    end

    puts "...done."

  end
end