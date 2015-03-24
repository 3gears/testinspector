require 'cucumber'
require 'capybara'
require 'digest/sha1'

require 'cucumber/formatter/json'
require 'fileutils'

class Viewcumber < Cucumber::Formatter::Json

  module GherkinObjectAttrs
    def feature_hash
      @feature_hash
    end

    def feature_hashes
      @feature_hashes
    end
  end

  class << self
    attr_accessor :last_step_html
  end

  def rewrite_css_and_image_references(response_html)
    response_html.gsub! /\/assets\/([a-zA-Z0-9\-_\.\/]+)/ do |old_path|
      asset_name = $1
      sprockets_asset = Rails.application.assets.find_asset(asset_name)
      raise "asset #{asset_name} not found" unless sprockets_asset.present?

      filename = "asset-#{sprockets_asset.digest}.#{asset_name}"
      full_file_path = File.join(results_dir, filename)
      sprockets_asset.write_to(full_file_path) unless File.exist?(full_file_path)

      # current path will be the results dir, so the new relative path is just new filename
      filename
    end

    # we cheat here a bit since by default, file:// URLs are treated as ASCII (?)
    # Usually, this is set by the web server...
    '<meta charset="utf-8">' + response_html
  end

  def initialize(step_mother, path_or_io, options)
    make_output_dir
    copy_app
    super(step_mother, File.open(results_filename, 'w+'), options)
    @gf.extend GherkinObjectAttrs
  end

  def after_step(step)
    if @email.present?
      Viewcumber.last_step_html = rewrite_css_and_image_references(@email)
      @email = nil
    else
      Viewcumber.last_step_html = rewrite_css_and_image_references(Capybara.page.html.to_s)
    end

    additional_step_info = { 'html_file' => write_html_to_file(Viewcumber.last_step_html),
                             'emails' => emails_for_step(step) }

    current_element = @gf.feature_hash['elements'].last
    current_step = current_element['steps'].last
    current_step.merge!(additional_step_info)
  end

  # The JSON formatter adds the background as a feature element,
  # we only want full scenarios so lets delete all with type 'background'
  def after_feature(feature)
    # this might want to be feature_hashes and an each
    if @gf.feature_hash && @gf.feature_hash['elements']
      @gf.feature_hash['elements'].delete_if do |element|
        element['type'] == 'background'
      end
    end
    super(feature)
  end




  private


  # Writes the given html to a file in the results directory
  # and returns the filename.
  #
  # Filename are based on the SHA1 of the contents. This means
  # that we will only write the same html once
  def write_html_to_file(html)
    return nil unless html && html != ""
    filename = Digest::SHA1.hexdigest(html) + ".html"
    full_file_path = File.join(results_dir, filename)

    unless File.exists?(full_file_path)
      File.open(full_file_path, 'w+') do |f|
        f  << html
      end
    end

    filename
  end

  def emails_for_step(step)
    ActionMailer::Base.deliveries.collect{|mail| mail_as_json(mail) }
  end

  def mail_as_json(mail)
    html_filename = write_email_to_file('text/html', mail)
    text_filename = write_email_to_file('text/plain', mail)
    {
      :to => mail.to,
      :from => mail.from,
      :subject => mail.subject,
      :body => {
        :html => html_filename,
        :text => text_filename
      }
    }
  end

  # Writes the content of the given content type to disk and returns
  # the filename to access it.
  #
  # Returns nil if no file was written.
  def write_email_to_file(content_type, mail)
    mail_part = mail.parts.find{|part| part.content_type.to_s.include? content_type }
    return nil unless mail_part

    contents = mail_part.body.to_s
    filename = Digest::SHA1.hexdigest(contents) + content_type.gsub('/', '.') + ".email.html"

    full_file_path = File.join(results_dir, filename)
    unless File.exists?(full_file_path)
      File.open(full_file_path, 'w+') do |f|
        f << prepare_email_content(content_type, contents)
      end
    end

    filename
  end

  def prepare_email_content(content_type, contents)
    case content_type
    when 'text/html'
      rewrite_css_and_image_references(contents)
    when 'text/plain'
      "<html><body><pre>#{contents}</pre></body></html>"
    else
      contents
    end
  end

  def results_filename
    @json_file ||= File.join(output_dir, 'results.json')
  end

  def results_dir
    @results_dir ||= File.join(output_dir, "results")
  end

  def output_dir
    @output_dir ||= File.expand_path("viewcumber")
  end

  def make_output_dir
    FileUtils.mkdir output_dir unless File.directory? output_dir
    FileUtils.mkdir results_dir unless File.directory? results_dir
  end

  def copy_app
    app_dir = File.expand_path(File.join('..', '..', 'build'), __FILE__)
    FileUtils.cp_r "#{app_dir}/.", output_dir
  end
end
