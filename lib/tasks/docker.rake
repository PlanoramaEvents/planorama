desc "A bunch of docker env utilities because I'm sick of typing"

namespace :docker do
    task :build do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "build"
    end

    task :restart, [:service] do |t, args|
        new_args = [ "docker-compose", "-f", "docker-compose-dev.yml", "restart"]
        if args[:service]
            new_args += [args[:service]]
        end
        sh *new_args 
    end

    task :quickstart do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "up", "-d"
    end

    task :start do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "up", "--build", "-d"
    end

    task :stop do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "down"
    end

    task :logs do
        sh "docker-compose", "-f", "docker-compose-dev.yml", "logs", "-f"
    end

    task :test do
        sh "docker", "exec", "planorama_planorama_1", "bundle", "exec", "rspec"
    end

    task :sh do
        sh "docker", "exec", "-it", "planorama_planorama_1", "sh"
    end

    task :mac_trunc_logs do
        sh "docker", "run", "-it", "--rm", "--privileged", "--pid=host", "planorama:dev", "nsenter",  "-t",  "1",  "-m", "-u", "-n", "-i", "--", "sh", "-c", "'truncate -s0 /var/lib/docker/containers/*/*-json.log'"
    end

    task :psql => :read_envrc do
        sh "docker", "exec", "-it", "planorama_postgres_1", "psql", "-U", ENV['POSTGRES_USER'], "-d", "planorama_development"
    end

    task :read_envrc do
        File.open(Rails.root.join('.envrc')) do |f|
            f.readlines.each do |line|
                (key, value) = /\w*=\w*/.match(line).to_s.split('=')
                ENV[key] = value
            end
        end
    end
end
