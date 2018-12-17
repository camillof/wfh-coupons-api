Slack.configure do |config|
    config.token = ENV['SLACK_API_TOKEN']
    raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    raise 'Missing ENV[SLACK_DEFAULT_CHANNEL]!' unless ENV['SLACK_DEFAULT_CHANNEL']
end

