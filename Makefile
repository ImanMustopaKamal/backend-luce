setup:
	yarn
	bundle install
	rails db:drop
	rails db:setup
	rails db:seed
	rails rake:generate_invoices

start:
	rails server

worker:
	bundle exec sidekiq -C config/sidekiq.yml

dev:
	@echo "Starting Rails server and Sidekiq in parallel..."
	bin/rails server & \
	bundle exec sidekiq -C config/sidekiq.yml & \
	wait