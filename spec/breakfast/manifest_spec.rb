require "spec_helper"
require "tmpdir"
require "json"

RSpec.describe Breakfast::Manifest do
  before do
    allow_any_instance_of(Digest::MD5).to receive(:hexdigest).and_return("digest")
    allow(SecureRandom).to receive(:hex) { "digest" }
  end

  let(:output_dir) { Dir.mktmpdir }

  it "will generate a manifest file and comiple digested assets" do
    Dir.mkdir("#{output_dir}/images/")

    app_js = File.open("#{output_dir}/app.js", "w")
    image = File.open("#{output_dir}/images/test.jpeg", "w")

    manifest = Breakfast::Manifest.new(base_dir: output_dir)
    manifest.digest!

    expect(File).to exist("#{output_dir}/app.js")
    expect(File).to exist("#{output_dir}/app-digest.js")

    expect(File).to exist("#{output_dir}/images/test.jpeg")
    expect(File).to exist("#{output_dir}/images/test-digest.jpeg")

    expect(JSON.parse(File.read("#{output_dir}/.breakfast-manifest-digest.json"))).to eq({
      "app.js" => "app-digest.js",
      "images/test.jpeg" => "images/test-digest.jpeg"
    })
  end

  it "will not fingerprint already fingerprinted assets" do
    File.open("#{output_dir}/app-523a40ea7f96cd5740980e61d62dbc77.js", "w")

    manifest = Breakfast::Manifest.new(base_dir: output_dir)
    manifest.digest!

    expect(File).to exist("#{output_dir}/app-523a40ea7f96cd5740980e61d62dbc77.js")
    expect(number_of_files(output_dir)).to eq(1)
  end

  it "will find an existing manifest" do
    File.open("#{output_dir}/.breakfast-manifest-869269cdf1773ff0dec91bafb37310ea.json", "w") do |file|
      file.write({ "app.js" => "app-abc123.js" }.to_json)
    end

    manifest = Breakfast::Manifest.new(base_dir: output_dir)

    expect(manifest.asset("app.js")).to eq("app-abc123.js")
  end

  it "will return the digested asset path for a given asset" do
    Dir.mkdir("#{output_dir}/images/")

    app_js = File.open("#{output_dir}/app.js", "w")
    image = File.open("#{output_dir}/images/test.jpeg", "w")

    manifest = Breakfast::Manifest.new(base_dir: output_dir)
    manifest.digest!

    expect(manifest.asset("app.js")).to eq("app-digest.js")
    expect(manifest.asset("images/test.jpeg")).to eq("images/test-digest.jpeg")
    expect(manifest.asset("doesnt-exist.png")).to be nil
  end

  it "will remove assets that are no longer referenced by the manifest" do
    Dir.mkdir("#{output_dir}/images/")

    File.open("#{output_dir}/outdated-523a40ea7f96cd5740980e61d62dbc77.js", "w")
    File.open("#{output_dir}/app.js", "w")
    File.open("#{output_dir}/images/test.jpeg", "w")
    File.open("#{output_dir}/images/outdated-523a40ea7f96cd5740980e61d62dbc77.jpeg", "w")

    manifest = Breakfast::Manifest.new(base_dir: output_dir)
    manifest.digest!

    expect { manifest.clean! }.to change { number_of_files(output_dir) }.by(-2)
  end

  it "will keep any assets that are referenced by a sprockets manifest" do
    Dir.mkdir("#{output_dir}/images/")

    File.open("#{output_dir}/outdated-523a40ea7f96cd5740980e61d62dbc77.js", "w")
    File.open("#{output_dir}/app.js", "w")
    File.open("#{output_dir}/images/test.jpeg", "w")
    File.open("#{output_dir}/images/outdated-523a40ea7f96cd5740980e61d62dbc77.jpeg", "w")

    File.open("#{output_dir}/sprockets-file-4e936bdd95c293bccbeefc56f191e4a7.js", "w")
    File.open("#{output_dir}/.sprockets-manifest-4e936bdd95c293bccbeefc56f191e4a7.json", "w") do |file|
      file.write({
        "files" => {
          "sprockets-file-4e936bdd95c293bccbeefc56f191e4a7.js" => {
            "logical_path"=>"sprockets-file.js",
            "mtime"=>"2016-10-26T18:26:19+00:00",
            "size"=>97551,
            "digest"=>"4e936bdd95c293bccbeefc56f191e4a7",
            "integrity"=>"sha256-hTHBWGfDx5DSg9+fD8EiCDkSZOCUpE+CNFjiFhKmICZ="
          }
        },
        "assets" => {
          "sprockets-file.js" => "sprockets-file-4e936bdd95c293bccbeefc56f191e4a7"
        }
      }.to_json)
    end

    manifest = Breakfast::Manifest.new(base_dir: output_dir)
    manifest.digest!

    expect { manifest.clean! }.to change { number_of_files(output_dir) }.by(-2)
  end

  def number_of_files(dir)
    Dir["#{dir}/**/*"].reject { |f| File.directory?(f) }.size
  end
end
