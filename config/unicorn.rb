# rootパスのディレクトリを指定（「../」が先頭に追加）
root_path = File.expand_path('../../../', __FILE__)

# アプリケーションサーバの性能を決定する
worker_processes 2

# アプリケーションの設置されているディレクトリを指定（current内に変更）
working_directory "#{root_path}/current"

# プロセスIDの保存先を指定（shared内に変更）
pid "#{root_path}/shared/tmp/pids/unicorn.pid"

# ポート番号を指定（shared内に変更）
listen "#{root_path}/shared/tmp/sockets/unicorn.sock"

# エラーのログを記録するファイルを指定（shared内に変更）
stderr_path "#{root_path}/shared/log/unicorn.stderr.log"

# 通常のログを記録するファイルを指定（shared内に変更）
stdout_path "#{root_path}/shared/log/unicorn.stdout.log"

timeout 30

# ダウンタイムなしでUnicornを再起動時する
preload_app true

GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end 