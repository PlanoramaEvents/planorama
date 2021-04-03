desc "A bunch of docker env utilities because I'm sick of typing"

namespace :docker do
    task :build do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "-f", "docker-compose.yml", "build"
    end

    task :start do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "-f", "docker-compose.yml", "up", "--build", "-d"
    end

    task :stop do
        sh "docker-compose", "down"
    end

    task :test do
        sh "docker", "exec", "planorama_planorama_1", "bundle", "exec", "rspec"
    end
end
