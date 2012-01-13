#!/usr/bin/env liquidsoap

#set("log.file",false)

def next_function()
  result = list.hd(get_process_lines("./bin/file-scheduler --status_file=/tmp/status files next"))
  request.create(result)
end

def forced_change()
  if 0s then
    log("check forced change")
    list.hd(get_process_lines("./bin/file-scheduler --status_file=/tmp/status files forced_next")) != ""
  else
    false
  end
end

# Create the source
source = request.dynamic(next_function)

# source = fallback.skip(
#   switch(track_sensitive=false, [ (forced_change, source) ] ),
#   source
# )

output.alsa(mksafe(source))
