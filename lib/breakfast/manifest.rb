require "json"
require "digest"
require "fileutils"

module Breakfast
  class Manifest
    MANIFEST_REGEX = /^\.breakfast-manifest-[0-9a-f]{32}.json$/
    SPROCKETS_MANIFEST_REGEX = /^\.sprockets-manifest-[0-9a-f]{32}.json$/
    FINGERPRINT_REGEX = /-[0-9a-f]{32}./

    attr_reader :base_dir, :manifest_path, :cache
    def initialize(base_dir:)
      FileUtils.mkdir_p(base_dir)

      @base_dir = Pathname.new(base_dir)
      @manifest_path = find_manifest_or_create
      puts "DEBUG: MANIFEST PATH - #{@manifest_path}"
      @cache = update_cache!
    end

    def asset(path)
      cache[path]
    end

    # The #digest! method will run through all of the compiled assets and
    # create a copy of each asset with a digest fingerprint. This fingerprint
    # will change whenever the file contents change. This allows us to use HTTP
    # headers to cache these assets as we will be able to reliably know when
    # they change.
    #
    # These fingerprinted files are copies of the original. The originals are
    # not removed and still available should the need arise to serve a
    # non-fingerprinted asset.
    #
    # Example manifest:
    # {
    #   app.js => app-76c6ee161ba431e823301567b175acda.js,
    #   images/logo.png => images/logo-869269cdf1773ff0dec91bafb37310ea.png,
    # }
    #
    # Resulting File Structure:
    # - /
    #   - app.js
    #   - app-76c6ee161ba431e823301567b175acda.js
    #   - images/
    #     - logo.png
    #     - logo-869269cdf1773ff0dec91bafb37310ea.png
    def digest!
      puts "DEBUG: ########### STARING DIGEST ############"
      puts "DEBUG: MANIFEST_PATH - #{manifest_path}"
      puts "DEBUG: BASE_DIR - #{base_dir}"
      puts "DEBUG: ASSET PATHS - #{asset_paths}"
      assets = asset_paths.map do |path|
        digest = Digest::MD5.new
        digest.update(File.read("#{base_dir}/#{path}"))

        puts "DEBUG: COPYING ASSET TO - #{path}"
        digest_path = "#{path.sub_ext('')}-#{digest.hexdigest}#{File.extname(path)}"

        puts "DEBUG: COPYING ASSET TO DIGEST_PATH - #{digest_path}"
        FileUtils.cp("#{base_dir}/#{path}", "#{base_dir}/#{digest_path}")

        [path, digest_path]
      end
      puts "DONE DEBUGGING"

      File.open(manifest_path, "w") do |manifest|
        puts "DEBUG: WRITING TO MANIFEST - #{manifest}"
        puts "DEBUG: WRITING TO MANIFEST THESE ASSETS - #{assets}"
        manifest.write(assets.to_h.to_json)
      end

      update_cache!
    end

    # Remove any files not directly referenced by the manifest.
    def clean!
      files_to_keep = cache.keys.concat(cache.values)

      if (sprockets_manifest = Dir.entries("#{base_dir}").detect { |entry| entry =~ SPROCKETS_MANIFEST_REGEX })
        files_to_keep.concat(JSON.parse(File.read("#{base_dir}/#{sprockets_manifest}")).fetch("files", {}).keys)
      end

      Dir["#{base_dir}/**/*"].each do |path|
        next if File.directory?(path) || files_to_keep.include?(Pathname(path).relative_path_from(base_dir).to_s)

        FileUtils.rm(path)
      end
    end

    # Remove manifest, any fingerprinted files.
    def nuke!
      Dir["#{base_dir}/**/*"]
        .select { |path| path =~ FINGERPRINT_REGEX }
        .each { |file| FileUtils.rm(file) }

      FileUtils.rm(manifest_path)
    end

    private

    def update_cache!
      puts "DEBUG: UPDATING CACHE"
      @cache = JSON.parse(File.read(manifest_path))
    end

    # Creates a or finds a manifest file in a given directory. The manifest
    # file is is prefixed with a dot ('.') and given a random string to ensure
    # the file is not served or easily discoverable.
    def find_manifest_or_create
      if (manifest = Dir.entries("#{base_dir}").detect { |entry| entry =~ MANIFEST_REGEX })
        "#{base_dir}/#{manifest}"
      else
        manifest = "#{base_dir}/.breakfast-manifest-#{SecureRandom.hex(16)}.json"
        File.open(manifest, "w") { |manifest| manifest.write({}.to_json) }
        manifest
      end
    end

    def asset_paths
      puts "DEBUG: ASSET PATHS METHOD"
      all_files = Dir["#{base_dir}/**/*"]
      puts "DEBUG: BASE DIR ALL FILES: #{all_files}"
      Dir["#{base_dir}/**/*"]
        .reject do |path| 
          puts "DEBUG: INSPECTING PATH: #{path}"
          puts "DEBUG: SHOULD REJECT #{path}?  #{File.directory?(path) || path =~ FINGERPRINT_REGEX}"
          File.directory?(path) || path =~ FINGERPRINT_REGEX 
        end.map do |file| 
          puts "DEBUG: CREATING PATHNAME FOR: #{file}"
          Pathname(file).relative_path_from(base_dir)
        end
    end
  end
end
