namespace :pc do

  task :move => :environment do
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]

    # bucket.objects.each do |obj|
    #   puts obj.key
    # end

    Photo.all.order('created_at DESC').each do |photo|
      id_partition = "%03d" % photo.id
      styles = photo.image.options[:styles].keys << :original

      styles.each do |sytle|

        source_path = "photos/images/000/000/#{id_partition}/#{sytle}/#{photo.image_file_name}"
        target_path = "photos/images/#{photo.slug}/#{sytle}/#{photo.image_file_name}"
        print "\rChecking #{source_path}...."
        if bucket.objects[source_path].exists?
          source_object = bucket.objects[source_path]
          target_object = bucket.objects[target_path]

          puts "\n    Found #{source_object.key}"
          
          target_object.delete()
          source_object.copy_to(target_object.key, acl: :public_read)
          puts "    Successful copy to #{target_path}?...#{bucket.objects[target_path].exists?}"
        end

      end


    end

    puts "...done."

  end
end