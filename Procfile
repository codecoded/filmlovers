#web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
web: bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -p $PORT -e ${RACK_ENV:-staging}
