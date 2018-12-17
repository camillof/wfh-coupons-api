class SlackClient
    @client = Slack::Web::Client.new
    @default_channel = ENV['SLACK_DEFAULT_CHANNEL']
    

    class << self
        def send_notification(message, recipient = @default_channel)
            @client.chat_postMessage(channel: recipient, text: message, as_user: true)
        end

        def clear_bot_messages(channel = @default_channel)
            messages = @client.channels_history(channel: channel)
            messages["messages"].each do |msg|
                @client.chat_delete(channel: channel, ts: msg.ts) unless msg.bot_id.nil?
            end
        end

        private 



        # To-Do. Using interactive slack messages this requires a secure https endpoint
        def build_accept_reject_button
            attachments = {
                fallback: "An error ocurred",
                callback_id: "wfh-coupon-action",
                attachment_type: "default",
                actions: [
                    {  
                        name: "action",
                        text: "Approve",
                        type: "button",
                        value: "approve",
                        style: "primary"
                    },
                    {  
                        name: "action",
                        text: "Reject",
                        type: "button",
                        value: "reject",
                        style: "danger"
                    }
                ]

            }
            return attachments
        end
    end
    
end