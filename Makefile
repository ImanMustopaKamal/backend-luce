setup:
	yarn
	bundle install
	rails db:drop
	rails db:setup
	rails db:seed

start:
	rails server