ENV['S3_JAR_PATH'] = 's3://reportgrid.com/deploy/production/'

# make sure IO stream is always flushed
STDOUT.sync = true

desc 'Deploy a ReportGrid JAR'
task :deploy do
  ENV['JAR_PATH'] = 'FIXME' unless ENV.include?('JAR_PATH')

  cwd             = File.expand_path(File.dirname(__FILE__))
  filename        = File.basename(ENV['JAR_PATH'])
  service         = File.basename(filename, File.extname(ENV['JAR_PATH']))
  filename_backup = service + '.' + Time.new.strftime('%Y-%m-%d-%H-%M-%S') +
                    File.extname(filename)
  s3cmd           = "s3cmd -c #{cwd}/ec2/s3cfg"

  sh "#{s3cmd} mv #{ENV['S3_JAR_PATH'] + filename} #{ENV['S3_JAR_PATH'] + filename_backup}"
  sh "#{s3cmd} -P put #{ENV['JAR_PATH']} #{ENV['S3_JAR_PATH']}"
  sh "cap -f #{cwd}/capfile SERVICE='#{service}' deploy"
end