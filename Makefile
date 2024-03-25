build:
	docker compose build

scrape: build
	docker compose run --rm scrape
	docker compose down
