object @user

attributes  :name, :username

node :stats do |user|
  {
    :watched => user.films[:watched].count,
    :loved => user.films[:loved].count,
    :owned => user.films[:owned].count,
    :queued => user.films_queue.count
  }
end



