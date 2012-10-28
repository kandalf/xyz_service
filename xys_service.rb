module XYZService

  @@filename_parts = []

  def self.xyz_filename(target)
    # File format:
    # [day of month zero-padded][three-letter prefix] \
    # _[kind]_[age_if_kind_personal]_[target.id] \
    # _[8 random chars]_[10 first chars of title].jpg

    add_publish_on(target)
    add_category_prefix(target)
    add_kind(target)
    add_age(target)
    add_id(target)
    add_random_bytes(target)
    add_title(target)
    add_suffix(target) #.join("_")

    @@filename_parts.join("_") #In favor of readability, I prefer this over the above join
  end

  def self.add_publish_on(target)
    @@filename_parts[0] = "#{target.publish_on.strftime("%d")}"
  end

  def self.add_category_prefix(target)
    @@filename_parts[0] = "#{@@filename_parts[0].to_s}#{target.xyz_category_prefix}"
  end

  def self.add_kind(target)
    @@filename_parts[0] = "#{@@filename_parts[0].to_s}#{target.kind.gsub("_", "")}"
  end

  def self.add_age(target)
    @@filename_parts << "%03d" % (target.age || 0) if target.personal?
  end

  def self.add_id
    @@filename_parts << target.id.to_s
  end

  def self.add_random_bytes(target)
    @@filename_parts << "#{Digest::SHA1.hexdigest(rand(10000).to_s)[0,8]}"
  end

  def self.add_title(target)
    truncated_title = target.title.gsub(/[^\[a-z\]]/i, '').downcase
    truncate_to = truncated_title.length > 9 ? 9 : truncated_title.length
    @@filename_parts << "#{truncated_title[0..(truncate_to)]}"
  end

  def self.add_suffix(target)
    @@filename_parts << ".jpg"
  end
end
