object @user

attributes  :name

node(:username) {|user| user.to_param}

node :stats do |user|
  {
    :watched => user.films[:watched].count,
    :loved => user.films[:loved].count,
    :owned => user.films[:owned].count,
    :queued => user.films_queue.count
  }
end



