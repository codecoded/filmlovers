object false


extends 'api/v1/shared/header'

child :user do 
  node { {:name => user.name} }
  node { {:username => user.username} }
  node(:email) {user.email}
  node(:created_at) {user.created_at}
  child user => :stats do 
    child user => :films do
      node(:watched) { user.films[:watched].count}
      node(:loved) { user.films[:loved].count}
      node(:owned) { user.films[:owned].count}
    end
  end
  child user.passports, :object_root => false do |pass|
    attributes :provider, :uid
  end
end