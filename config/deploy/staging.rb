set :branch, 'master'
server ENV['STAGING_SERVER'], user: ENV['STAGING_USER'], roles: %w{web app db}

set :deploy_to, ENV['STAGING_DEPLOY_PATH']

set :docker_volumes, [
  "#{shared_path}/config/sec_config.yml:/app/config/sec_config.yml",
  "#{shared_path}/log:/app/log",
  "#{shared_path}/public/uploads:/app/public/uploads",
  "people_staging_assets:/app/public/assets",
  "people_staging_node_modules:/app/node_modules",
  "#{shared_path}/assets/javascripts/react_bundle.js:/app/app/assets/javascripts/react_bundle.js",
]

set :docker_dockerfile, "docker/staging/Dockerfile"

