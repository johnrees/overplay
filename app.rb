require 'sinatra'
require 'tempfile'

get '/' do
  "Hello World!"
end

def getThumb id, name='maxresdefault.jpg'
  file = Tempfile.new(id)
  file.write RestClient.get("https://img.youtube.com/vi/#{id}/#{name}").body
  # file.rewind
  return file
end

get '/:video_id' do
  original_thumbnail = getThumb(params['video_id'])
  temp_output = Tempfile.new(SecureRandom.hex)

  `composite -gravity center overlays/tool_yt-play-button.png #{original_thumbnail.path} #{temp_output.path}`
  original_thumbnail.close
  original_thumbnail.unlink

  send_file(temp_output, { filename: "#{params['video_id']}_with_overlay.jpg" })
end
