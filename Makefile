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